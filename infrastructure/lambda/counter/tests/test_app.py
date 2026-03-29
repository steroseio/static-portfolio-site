import importlib.util
import json
import os
import pathlib
import sys
import types
import unittest
from unittest.mock import patch


APP_PATH = pathlib.Path(__file__).resolve().parents[1] / "app.py"
MODULE_NAME = "counter_app_under_test"


class FakeDynamoDBClient:
    def __init__(self, response=None, error=None):
        self.response = response
        self.error = error
        self.calls = []

    def update_item(self, **kwargs):
        self.calls.append(kwargs)
        if self.error:
            raise self.error
        return self.response


def load_counter_module(fake_client, table_name="counter-table", partition_key="site-total"):
    fake_boto3 = types.ModuleType("boto3")
    fake_botocore = types.ModuleType("botocore")
    fake_exceptions = types.ModuleType("botocore.exceptions")

    class FakeBotoCoreError(Exception):
        pass

    class FakeClientError(Exception):
        pass

    def fake_client_factory(service_name):
        if service_name != "dynamodb":
            raise AssertionError(f"Unexpected AWS service requested: {service_name}")
        return fake_client

    fake_boto3.client = fake_client_factory
    fake_exceptions.BotoCoreError = FakeBotoCoreError
    fake_exceptions.ClientError = FakeClientError
    fake_botocore.exceptions = fake_exceptions

    with patch.dict(
        os.environ,
        {
            "COUNTER_TABLE_NAME": table_name,
            "COUNTER_PARTITION_KEY": partition_key,
        },
        clear=False,
    ):
        with patch.dict(
            sys.modules,
            {
                "boto3": fake_boto3,
                "botocore": fake_botocore,
                "botocore.exceptions": fake_exceptions,
            },
            clear=False,
        ):
            spec = importlib.util.spec_from_file_location(MODULE_NAME, APP_PATH)
            module = importlib.util.module_from_spec(spec)
            sys.modules[MODULE_NAME] = module
            spec.loader.exec_module(module)

    return module, FakeBotoCoreError, FakeClientError


class CounterHandlerTests(unittest.TestCase):
    def tearDown(self):
        sys.modules.pop(MODULE_NAME, None)

    def test_handler_returns_incremented_count_on_success(self):
        fake_client = FakeDynamoDBClient(
            response={"Attributes": {"count": {"N": "42"}}},
        )
        module, _, _ = load_counter_module(
            fake_client,
            table_name="steroseio-visitor-counter",
            partition_key="site-total",
        )

        response = module.handler(event={}, context=None)
        body = json.loads(response["body"])

        self.assertEqual(response["statusCode"], 200)
        self.assertEqual(response["headers"]["Content-Type"], "application/json")
        self.assertEqual(body, {"count": 42})

        self.assertEqual(len(fake_client.calls), 1)
        call = fake_client.calls[0]
        self.assertEqual(call["TableName"], "steroseio-visitor-counter")
        self.assertEqual(call["Key"], {"pk": {"S": "site-total"}})
        self.assertEqual(call["ReturnValues"], "UPDATED_NEW")
        self.assertIn("if_not_exists", call["UpdateExpression"])

    def test_handler_returns_500_when_dynamodb_client_error_is_raised(self):
        fake_client = FakeDynamoDBClient()
        module, _, fake_client_error = load_counter_module(fake_client)
        fake_client.error = fake_client_error("dynamodb update failed")

        response = module.handler(event={}, context=None)
        body = json.loads(response["body"])

        self.assertEqual(response["statusCode"], 500)
        self.assertEqual(body["error"], "Unable to increment counter")
        self.assertIn("dynamodb update failed", body["detail"])

    def test_handler_returns_500_when_response_count_is_not_numeric(self):
        fake_client = FakeDynamoDBClient(
            response={"Attributes": {"count": {"N": "not-a-number"}}},
        )
        module, _, _ = load_counter_module(fake_client)

        response = module.handler(event={}, context=None)
        body = json.loads(response["body"])

        self.assertEqual(response["statusCode"], 500)
        self.assertEqual(body["error"], "Unable to increment counter")
        self.assertIn("invalid literal", body["detail"])


if __name__ == "__main__":
    unittest.main()
