---
title: 'The NGINX Ingress Deadline: Apocalypse, Now?'
description: 'Ingress NGINX is being retired in March 2026. Your clusters will keep running, but the security and maintenance clock has stopped. Here is what is happening and why you should care.'
pubDate: 'Mar 1 2026'
category: 'Kubernetes'
tags: ['kubernetes', 'ingress', 'ingress-nginx', 'nginx', 'gateway-api', 'sre', 'platform-engineering', 'security']
---

As I write, it is March. The date we have all been hearing about for months has arrived. And no, your servers are not about to melt through the floor.

Your apps will keep routing traffic.

But you did just receive an eviction notice.

The Kubernetes project is retiring **Ingress NGINX** in March 2026. The important bit is not “will my apps still work?” but “who is patching the internet-facing entry point to my cluster?”. After retirement there will be **no more releases, no bug fixes, and no security patches**.

Picture the building you live in firing its maintenance staff. Everything looks normal, right up until it does not.

## First, let us fix the confusion

Kubernetes networking has a naming problem. There are three separate things here, and they keep getting mashed into one sentence.

### 1) NGINX the web server

NGINX is fine. It is not going anywhere. It will keep doing what it has always done: serve traffic, proxy requests, terminate TLS.

### 2) The Kubernetes Ingress API

The **Ingress** API object is also fine. It is not being removed from Kubernetes as part of this retirement. You can still write Ingress YAML.

But Ingress is an API, not a data plane. Without a controller running in the cluster, your Ingress object is just an optimistic document.

### 3) Ingress NGINX (the controller)

This is the one that is going away.

**Ingress NGINX** is the community maintained controller that watches Ingress resources and configures an NGINX proxy to route traffic into your cluster. Kubernetes SIG Network and the Security Response Committee announced best-effort maintenance until March 2026, and then it stops. Repos go read-only. Project retired.

No updates. No fixes. No CVE patches.

## The bouncer, the hacks, and the technical debt

Ingress NGINX became popular for good reasons. It was early, flexible, and broadly usable. It did not care which cloud you ran in. It handled “get traffic into my cluster” without forcing you into a vendor specific corner.

It was also the stoic bouncer outside your Kubernetes nightclub. Stood outside in all weathers, it checked TLS certs, decided who got into the VIP pod, and who got thrown out into the nearest convenient alley.

Then, teams wanted more complex routing. Workarounds appeared. Annotations piled up. People injected custom config snippets directly into the underlying NGINX engine.

That is convenient until you remember a controller is a security boundary. When “flexibility” includes “let users inject strings into proxy config”, maintainers end up patching a moving target built out of escape hatches.

The Kubernetes retirement post calls this out directly: features like “snippets” annotations went from helpful to serious security flaws, and the accumulated technical debt became unmanageable.

## How we got here (and why this is not a surprise)

Ingress NGINX has been chronically under-maintained for years. Despite its popularity, it often had only one or two people doing development work in their spare time.

In March 2025, ingress-nginx had a set of serious vulnerabilities including **CVE-2025-1974**. It is not the only reason for retirement, but it is a bright neon sign pointing at the risk.

There was also an attempt to wind down Ingress NGINX and build a replacement controller alongside the Gateway API community (InGate). It never matured and is also being retired.

## What retirement actually means in practice

Retirement does **not** mean your cluster suddenly stops routing traffic.

It means:
- no more upstream releases after March 2026
- no bug fixes after that point
- newly discovered vulnerabilities stay unpatched
- repositories become read-only and stay up for reference
- existing artifacts remain available

So yes, you can technically leave it running.

It is still a bad plan for an internet-facing component in the same way that leaving your front door protected by a scarecrow is a bad plan. The crows might stay away for a while. But then, the crows are the least of your worries.

Do you want to be the person explaining to your boss that company data was stolen because you did not want to write a few new YAML files? Me either.

## Quick reality check: are you even using it?

Before you panic, find out if you are actually running it. The Kubernetes post gives a simple check:

```bash
kubectl get pods --all-namespaces --selector app.kubernetes.io/name=ingress-nginx
```

If you get results, congratulations, you have homework.

If you do not, still double check your platform defaults. Some distros ship it. Some ship alternatives. Some avoid the Ingress pattern entirely.

Do not guess. Inventory.

## Why this matters even if everything looks fine today

The Kubernetes Steering Committee and Security Response Committee were blunt in January 2026: staying on Ingress NGINX after retirement leaves you and your users vulnerable to attack, and you might not know you are affected until you are compromised.

That is the nasty thing about unmaintained infrastructure. It fails silently, right up to the moment it does not.

## OK. Breathe. What now?

Here is the calm, boring truth: you have time to do this properly, but not time to ignore it.

This post is part one: what is happening, why it is happening, and why you should take it seriously. Part two will be practical: migration options, safe cutovers, and how to avoid swapping one mess for another.

For now, do three things:

1. Identify where ingress-nginx is running and who owns it.
2. Map which apps depend on it, and which annotations you rely on.
3. Decide whether you are aiming for a different Ingress controller or moving toward Gateway API.

You do not need to solve it this week. You do need to start.

## Closing thought

Ingress NGINX powered an absurd amount of traffic for years. It earned its place in the Kubernetes hall of fame. I'm not suggesting such a place exists in actuality.

But, nostalgia runs usually end in disappointment. Take it from the guy who recently tried Crystal Pepsi again for the first time since childhood.

Treat this like an eviction notice. Get moving, keep your cool, and you will get through it without breaking sweat.

Stay tuned for part two.

## Sources

```text
https://kubernetes.io/blog/2025/11/11/ingress-nginx-retirement/
https://kubernetes.io/blog/2026/01/29/ingress-nginx-statement/
https://kubernetes.io/blog/2025/03/24/ingress-nginx-cve-2025-1974/
```
