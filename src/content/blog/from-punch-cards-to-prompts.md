---
title: "From Punch Cards to Prompts: Is AI the Next Abstraction Layer for SRE?"
description: "SRE's next evolution might be about who - or what - holds the system understanding."
pubDate: 'Dec 1 2025'
category: 'AI'
tags: ['ai', 'sre', 'best-practices', 'design']
---

In the early days of programming, we didn’t “write code” so much as *physically* describe it. Instructions were punched into cards, stacked into decks, and fed into machines with all the ceremony of a Victorian loom. It was slow, rigid, and unforgiving — one misplaced card and your “deployment pipeline” was basically gravity.

## Abstraction always arrives with a shiver

Assembly language was a breakthrough because it let humans speak in symbolic instructions instead of raw machine codes. But it still kept you close to the metal — you felt the hardware in your bones. Then C arrived and shifted the ground again: portable, expressive, powerful … and just abstract enough to trigger suspicion.

The pattern repeats: every time we climb a level of abstraction, we gain leverage — and lose *some* immediacy. That trade has always produced an emotional cocktail: *excitement* (look what we can build now) mixed with *resentment* (you’re making my hard-earned craft feel less relevant).

A famous example of that vibe is the satirical essay **“Real Programmers Don’t Use Pascal”** — a tongue-in-cheek defence of “serious” low-level work, and a not-so-subtle jab at higher-level languages and the people who used them. It’s funny, but it’s also revealing: beneath the jokes is a real fear that abstraction means *dilution* — of skill, of control, of identity.

## Now the abstraction is wearing a face

Enter AI.

For SREs, it’s hard not to feel the weight of it. AI can already produce working code in minutes, explain logs, summarise incidents, suggest remediations, and generate infrastructure snippets from a prompt. It’s the kind of capability that makes you stare at your carefully curated knowledge and wonder, *“Am I being upstreamed out of my own job?”*

And the more practical question: if we let AI do more of the *thinking-shaped* work, do we risk losing the deep systems intuition that SRE has traditionally relied on?

## The SRE-shaped version of the question

SRE isn’t just writing code. It’s **operational taste**. It’s knowing when a metric is lying. It’s reading between the lines of a graph at 3am and recognising the difference between “we’re fine” and “we’re about to have a very bad morning.”

AI promises to reduce toil — *and it probably will*. But it also tempts us toward a world where the feedback loops get fuzzier:

- If AI writes the remediation, do we still understand the failure mode?
- If AI correlates the signals, do we still build the instincts to spot the weird edge cases?
- If AI drafts the postmortem, do we still learn the lesson — or just record it?

## An open question worth arguing about

So maybe AI *is* “just the next abstraction layer” — like punch cards to assembly, assembly to C, and C to everything that followed. Or maybe it’s different, because it doesn’t just abstract syntax … it abstracts *judgement*.

If that’s true, then the interesting question isn’t whether SREs will adapt.

It’s this:

**When AI can generate the fixes, the explanations, and the designs — what part of reliability work remains distinctly *human*, and how do we make sure we don’t accidentally automate away the very understanding that keeps systems safe?**
