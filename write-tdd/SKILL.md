---
name: write-tdd
description: Collaboratively write or refine technical design documents (TDDs) from a user prompt using the template.md structure. Use when a user asks to draft a TDD, improve an existing TDD, or review TDD completeness.
---

# Write TDD

Produce a complete TDD that matches the skill template section-for-section while running a tight collaboration loop with the user.

## Workflow

1. Read `references/template.md` first.
2. Confirm the TDD subject from the user prompt and infer an initial scope.
3. Research the codebase before asking broad questions:
- Find existing models, controllers, jobs, services, APIs, UI pages, and tests related to the feature.
- Gather concrete file references that inform the draft.
4. Build a "known vs unknown" list for template sections.
5. Ask focused follow-up questions only for high-impact unknowns.
- Ask at most 1-3 questions per round.
- Prioritize blockers for architecture, release safety, and testing.
6. Draft the TDD in template order, filling what is known and marking unresolved decisions in `Open Questions`.
7. Iterate with the user:
- Incorporate answers.
- Re-check impacted sections for consistency.
- Resolve or update `Open Questions`.
8. Run a completeness pass against `template.md` before finalizing.

## Collaboration Rules

- Treat TDD writing as a collaborative interview, not a one-shot generation task.
- Prefer specific questions tied to a section and a decision.
- When possible, offer 2-3 concrete options with tradeoffs to speed decision-making.
- If an answer is not yet available, keep moving and park it in `Open Questions` with owner context.
- Do not invent product constraints that are not supported by the prompt or codebase evidence.

## Template Fidelity Rules

- Follow the exact section order from `references/template.md`.
- Preserve optional sections; if not applicable, write `N/A` with a brief reason.
- Keep `Open Questions` current throughout drafting, not only at the end.
- Ensure `Summary`, `Release Plan`, `Monitoring/Telemetry`, `Testing`, and `Steps to Completion` are concrete and actionable.
- Use `YYYYMMDD {Subject}` title format.

## Codebase Exploration Rules

- Start with `rg`/file inspection to anchor claims in existing code.
- Cite real file paths when describing current behavior or proposing changes.
- Investigate related migrations, models, services, jobs, controllers, frontend pages, and tests before declaring unknowns.
- If evidence is conflicting, call it out explicitly and ask a resolving question.

## Output Contract

- Deliver a markdown TDD that can be pasted directly as a document.
- Include all sections from `references/template.md`.
- Keep language decisive where decisions are made and explicit where they are pending.
- End with the latest `Open Questions` list, including resolved entries crossed out when appropriate.

Use [template.md](references/template.md) as the canonical structure and [tdd-section-question-bank.md](references/tdd-section-question-bank.md) to drive section-specific discovery questions and completeness checks.
