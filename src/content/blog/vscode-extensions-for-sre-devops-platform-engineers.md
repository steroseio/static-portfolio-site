---
title: 'VS Code Extensions for SRE, DevOps, and Platform Engineers'
description: 'A practical list of VS Code extensions that improve daily work across Kubernetes, Terraform, debugging, ops automation, and incident response.'
pubDate: 'Feb 1 2026'
category: 'Tools'
tags: ['vscode', 'sre', 'devops', 'platform-engineering', 'kubernetes', 'terraform', 'productivity']
---

I’ve tried hundreds of VS Code extensions. Most got uninstalled after a day. This list is focused on operational work: infrastructure, clusters, pipelines, YAML, APIs, and on-call reality.

No novelty picks. Just extensions that help me move faster and make fewer mistakes.

## The Core Ops Stack

### 1. YAML (Red Hat)

**Why:** Most SRE and platform workflows run through YAML at some point.

Schema validation and hover docs catch mistakes before they become deploy failures.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  replicas: 3
```

### 2. Kubernetes (Microsoft)

**Why:** Cluster context in-editor is a major time saver.

You can inspect resources, switch contexts, apply manifests, and troubleshoot without bouncing between terminals and UIs.

```bash
kubectl config current-context
kubectl get pods -A
kubectl describe pod api-7d9f8f4f6c-2xt5m
```

### 3. Docker

**Why:** Makes image/container workflows easier to reason about.

Good for quickly reviewing Dockerfiles, images, and running containers while iterating locally.

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
CMD ["npm", "run", "start"]
```

### 4. HashiCorp Terraform

**Why:** Syntax help + validation feedback reduce IaC mistakes.

```hcl
resource "aws_s3_bucket" "logs" {
  bucket = "acme-prod-logs"

  tags = {
    Environment = "prod"
    Owner       = "platform"
  }
}
```

### 5. GitLens

**Why:** During incidents, history is evidence.

Blame, commit context, and line-level history are useful when you need to answer: *what changed right before this started?*

```bash
git log --oneline --decorate --graph -20
git show <commit-sha>
```

## Reliability and Incident Response Helpers

### 6. Error Lens

**Why:** Inline errors reduce context switching.

For large infra repos and CI config files, seeing issues directly in-place is faster than chasing Problems panel entries.

```json
{
  "errorLens.enabledDiagnosticLevels": ["error", "warning"],
  "errorLens.messageEnabled": true
}
```

### 7. Thunder Client (or REST Client)

**Why:** API checks directly from your editor.

Great for quick health checks, auth validation, and testing internal endpoints while debugging rollouts.

```http
GET https://api.example.com/health
Authorization: Bearer {{token}}
```

### 8. Continue / Copilot (pick one and use it intentionally)

**Why:** Fast draft support for runbooks, scripts, and repetitive config.

Useful when scoped and reviewed carefully. I treat generated content like junior code: helpful, never trusted by default.

```bash
# Always verify generated commands before running:
terraform plan
kubectl diff -f deploy/
```

## Platform Workflow Accelerators

### 9. Remote - SSH

**Why:** Safer edits on bastions and remote tooling boxes with less friction.

```bash
Host prod-bastion
  HostName 203.0.113.10
  User ec2-user
  IdentityFile ~/.ssh/prod.pem
```

### 10. Dev Containers

**Why:** Reproducible local environments for platform repos.

This is especially helpful for onboarding and avoiding "works on my laptop" drift.

```json
{
  "name": "platform-dev",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/kubectl-helm-minikube:1": {}
  }
}
```

### 11. Path IntelliSense

**Why:** Infrastructure repos get deep quickly.

Autocompletion for paths helps avoid subtle include/import mistakes in large mono-repos.

```hcl
module "network" {
  source = "../modules/network"
}
```

### 12. Todo Tree

**Why:** Operational debt visibility.

I use this for tracking risk markers across repos: TODOs, FIXMEs, and follow-up tasks after incident work.

```text
TODO: tighten IAM policy for deploy role
FIXME: add rate limit alert on /login endpoint
HACK: temporary retry backoff until upstream fix lands
```

## Settings I Keep in Most Ops Projects

```json
{
  "editor.formatOnSave": true,
  "editor.rulers": [100],
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "yaml.format.enable": true,
  "terraform.languageServer.enable": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit"
  }
}
```

And for shell-heavy workflows:

```json
{
  "terminal.integrated.defaultProfile.osx": "zsh",
  "terminal.integrated.scrollback": 100000
}
```

## A Simple Rule for Extension Hygiene

If an extension does not make me measurably faster after two weeks, I remove it.

My baseline test:

1. Did it reduce mistakes?
2. Did it reduce context switching?
3. Did it speed up common paths (debugging, deployment, review)?

If the answer is no, uninstall.

## Final Take

For SRE and platform work, VS Code is most effective when it acts as an operational cockpit, not just a text editor.

Pick a small, high-signal extension set, keep your settings consistent across repos, and optimize for clarity during incidents, not aesthetics during calm periods.
