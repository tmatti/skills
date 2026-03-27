# TDD Section Question Bank

Use this file while drafting so each section of `template.md` is completed with concrete, decision-oriented content.

## Title (`YYYYMMDD {Subject}`)

- What is the implementation-focused subject line?
- Is the date current and in `YYYYMMDD` format?

## Introduction

- What business or product problem is being solved?
- What user impact justifies this change now?
- Are there supporting docs (PRD, issue, mocks)?

## Resources (optional)

- Which links should be captured for future readers?
- Are there prior ADRs, RFCs, or incidents that should be linked?

## Glossary (optional)

- Which domain terms or abbreviations are easy to misinterpret?
- Do we need canonical definitions for cross-team alignment?

## Current State (optional)

- How does this work today in code and operations?
- Which files or services represent current behavior?
- What pain points or constraints exist in the current state?

## Future State (optional)

- What will be different after rollout?
- Why is this design chosen over alternatives?
- What tradeoffs are accepted and why?

## Not in Scope

- Which related asks are intentionally deferred?
- Which risky assumptions should be explicitly excluded from this phase?

## Technical Design

### Summary

- What is the selected approach in 2-4 sentences?
- Which alternatives were considered and rejected?
- Which systems/components are touched?

### Design Sections

- What data model changes are needed?
- What lifecycle/state-machine transitions change?
- What API/UI/background job changes are required?
- What integration boundaries and failure modes must be handled?

## ERD

- Are model/relationship changes proposed?
- Is a diagram or link included when schema changes exist?

## Release Plan

- What order of deployment is required?
- Are migrations/backfills/flags needed?
- How is rollback handled?

## Monitoring/Telemetry

### Mandatory

- What alerts/dashboards are required at launch?
- What SLO/SLA or failure thresholds should trigger action?

### Nice to have

- What additional metrics would improve iteration later?

## Testing

### Use Cases

- What core success paths must pass?
- What failure/edge paths must be covered?
- What tenant/account permission boundaries must be validated (if applicable)?

### Testing Notes

- What setup data or mocks are needed?
- What manual verification steps are important?

## Steps to Completion

- What repo-level work items are required?
- Can tasks be ordered into safe implementation sequence?
- Which tasks must happen before/after deployment checkpoints?

## Open Questions

- Which unresolved items block implementation?
- Who owns each decision?
- Are resolved items struck through with final decisions captured in the main sections?
