# Generic Mitigations: the SRE Swiss Army Knife

In SRE and Platform Engineering, a mitigation is any action you take to stop the bleeding and reduce user impact **before** you fully understand the underlying cause. It is not *the fix*. It is the tactical move that buys you time, restores service, and gets everyone thinking clearly again.

Mitigations come in many shapes. Sometimes it is SSHing to a host to flush a cache or restart a stuck process. Sometimes it is kicking a suspicious node out of a load balancer pool. Sometimes it is a hotfix, a feature flag, or a rollback. Sometimes it is failing traffic over to a different region. And yes, “pull the network cable” is technically a mitigation too.

## The fire extinguisher mindset

You do not need full understanding before you mitigate. You need enough confidence that your action will reduce harm. Mitigate first, diagnose second.

That ordering can save money, protect customer trust, and lower stress on-call. It buys headspace. Once the service is stable (or at least less on fire), you can do proper RCA without your users acting as involuntary test subjects.

MTTR matters, but let’s be honest about what the business wants in the moment. Most of the time they care about recovery more than correctness. They want the checkout working and the API returning 200s. The deeper fix comes later, with evidence, cooler heads, and a plan that does not involve “restart everything every 15 minutes forever”.

## Where can I buy the magic recovery button?

Somewhere between “next to the unicorn feed” and “behind the self-healing distributed systems”.

Sadly, you do not buy it. You build it.

In reality, the recovery button is a set of trusted options plus judgement. Even “generic” mitigations still demand competent thinking: build a quick mental model of the critical path, estimate blast radius, prefer reversible moves, and choose the smallest hammer that still hits the nail.

## The Swiss Army Knife: five generic mitigations

With that in mind, here are a few mitigations I think every engineer should keep close at hand. Not because they are glamorous, but because they work.

**1) Scale up or scale out.** Add replicas, increase capacity, raise limits. It is expensive, sure, but it beats the user going somewhere else because your service is slow. Scaling is often the fastest path back to green when the failure mode is resource exhaustion or sudden traffic. Just be honest about bottlenecks: adding web replicas will not help if your database is already pinned.

**2) Drain and reroute.** If you are multi-homed, use it. Drain traffic away from a failing node, AZ, or region and shift load to a healthier pool. It shines when the problem is localized (bad network path, flaky storage, one region having a bad day). It also tests whether your health checks and routing are trustworthy, which is an awkward truth you want to learn before you need it.

**3) Isolate.** Quarantine the troublemaker. Evict the pod, cordon the node, demote the replica, remove a cache shard from rotation. Hockey analogy: put it in the sin bin to cool off. You can investigate it properly once it is no longer punching your users in the face.

**4) Block.** Sometimes the issue is not your system, it is what is being thrown at it. A single customer, integration, bot, or runaway job can cause disproportionate load. Rate limit, throttle, temporarily block, or degrade their experience to protect everyone else.

Boat analogy time: if one passenger is drilling holes in the hull, you remove the drill first. You can debate fairness later, ideally with a better quota model and a calmer post-incident review.

**5) Rollback.** The classic. If the incident lines up with a deployment, roll back to the last known good.

Should you do it? It depends. What is your SLA? How depleted is your error budget? What is the appetite to fix forward? Rollbacks also come in flavours: binary rollback, config rollback, feature flag off, or traffic shifting back to the stable version. The best rollback is the one you practiced.

## The uncomfortable truth: even “generic” needs context

Generic mitigations still require business context. Scaling might restore latency but double your bill. Failover might save users but risk data inconsistency. Blocking might protect the platform but upset a key customer. This is why SRE sits at the intersection of delivery speed and reliability: you are managing trade-offs under pressure.

The other theme is upkeep. Every new service, dependency, and feature can invalidate yesterday’s playbook. As new things ship, do they change the fundamentals of your mitigation plans? Are mitigations part of production readiness reviews, or do you discover them at 2am with an audience?

## Working first, fixed later

If you take one thing away, let it be this: aim for “working” first, then travel the road to “fixed”.

Customers do not award points for elegant root cause narratives while the site is down. Outages are financially expensive and reputationally expensive.

Mitigations are your fire extinguisher. Messy, unglamorous, and occasionally powdery, but they stop the house burning down long enough for you to figure out who left the toast in too long.
