---
name: git-convention
description: |-
  Write commit messages following datarockets repository conventions. Use for commits
  in projects using this style, or when asked to follow datarockets git patterns.
  Use proactively when user says "commit this", "write a commit message", or works
  in a codebase with datarockets-style history.
  
  Examples:
  - user: "Commit these changes" → write subject line per datarockets conventions
  - user: "Write a commit message for this diff" → use natural English, no conventional prefixes
  - user: "How should I commit this upgrade?" → follow upgrade format with changelog links
  - user: "Follow datarockets style for this commit" → apply verb patterns and body conventions
  - user: "Review my commit message" → check against sentence case, 72-char limit, no prefixes
---

# Git History Rules — datarockets style

Apply when writing commits, reviewing history, or planning releases.

---

## 1. Subject Line

- **Sentence case**. Start with a capital letter.
- **No trailing period.**
- **No conventional-commit prefixes** (`feat:`, `fix:`, `chore:` etc. are NOT used).
- **Natural English** — the subject should read as a short, clear sentence fragment.
- **72-char soft limit.** Keep subjects scannable; push detail into the body.

### Verb patterns (pick the one that fits)

| Pattern | When to use | Example |
|---|---|---|
| `Add <thing>` | Brand-new module, resource, or capability | `Add aws/iam module that helps creating users and roles` |
| `Upgrade <thing> X.Y.Z -> A.B.C` | Dependency or provider version bump | `Upgrade cert-manager 1.4.1 -> 1.6.1` |
| `Update <thing> to X.Y` | Internal version change (no "from" version) | `Update postgres to 12.8` |
| `Make it possible to <action>` | Enabling a new optional behavior | `Make it possible to set termination_grace_period_seconds per service` |
| `Allow <thing/action>` | Relaxing a constraint or adding an option | `Allow EKS nodes to connect to public internet via http (port 80)` |
| `Remove <thing>` | Deleting code/config | `Remove redundand security group rules` |
| `Move <thing> to <place>` | Reorganization without behavior change | `Move vpc creation code to eks.tf file for readability` |
| `Split <thing> on <parts>` | Breaking a unit into submodules | `Split kubernetes on multiple submodules` |
| `Don't <action>` | Stopping an incorrect/unwanted behavior (bug fix) | `Don't create a separate ingress for serving ACME challenges` |
| `<module>: <change>` | Scoped change within a known module | `kubernetes/stack: pick keys from secrets and configmaps as env variables` |
| Declarative statement | Stating a fact or principle | `We use nginx ingress snippets in many projects` |
| `Declare <thing>` | Establishing policy or structure | `Declare principles` |

### Important: bug fixes

Bug fixes do NOT use "Fix" as a prefix. Instead, describe what the code does now:
- `Don't use sensitive dcr_credentials value in for_each key`
- `Don't create a separate ingress for serving ACME challenges`
- `Run database creation job in default namespace`

Or describe what the correct state is:
- `kubernetes/stack: field_refs were added, not from_fields`

### Module scope prefix

When a change is scoped to a specific module, prefix the subject:
```
kubernetes/stack: add ability to overwrite service annotations
templates/aws: add bootstrappable secure config
```
Use this ONLY when the change is entirely within one module. Cross-module changes use a plain subject.

---

## 2. Commit Body

The body explains **WHY**, not what. The diff already shows what changed.

### When a body is required

- New modules or major features (explain intent, sometimes include usage example)
- Upgrade commits with breaking changes (explain what changed and link changelogs)
- Bug fixes where the root cause is non-obvious
- Decisions that might look wrong without context

### When a body can be omitted

- Trivial 1-line changes where the subject says it all
- Simple version bumps with no breaking changes
- Obvious refactors (moves, renames)

### Body conventions

- Wrap at ~72 characters.
- Use first person naturally: "We need it to...", "I wrongly assumed that..."
- Be honest about work-in-progress: "It is still in progress. What I think needs to be added: ..."
- Note things to discuss later: "Only increase minor version for now. Upgrade to postgres 13 to be discussed."
- Explain misconceptions that led to bugs: "I wrongly assummed that they work like a firewall rules..."

### Upgrade commit bodies

For dependency/provider upgrades, include changelog links for each intermediate version:

```
Upgrade cert-manager 1.4.1 -> 1.6.1
Changelog:
* 1.5.0: https://github.com/jetstack/cert-manager/releases/tag/v1.5.0
* 1.6.0: https://github.com/jetstack/cert-manager/releases/tag/v1.6.0
* 1.6.1: https://github.com/jetstack/cert-manager/releases/tag/v1.6.1
```

For upgrades with breaking changes, explain each breaking change and how it was handled:

```
Upgrade hashicorp's aws/eks module to latest version 18.2
There are a lot of changes between version 17 and 18:

1. eks module no longer uses and creates any resources in kubernetes
   cluster. [explanation of impact]

2. eks module no longer provision aws-auth ConfigMap in kubernetes
   cluster so we have to do it on our own.

Read more: https://github.com/terraform-aws-modules/...
```

### Code examples in bodies

When adding a new module or major feature, include a usage example in the body:

```
Make it possible to set env variables from deployment descriptions
Example:
\`\`\`
module "kubernetes" {
  source = "git@github.com:datarockets/infrastructure//k8s/basic?ref=v0.1.0
  ...
  services = {
    app = {
      env_from_field = {
        POD_IP = "status.podIP"
      }
    }
  }
}
\`\`\`
```

---

## 3. Commit Granularity

- **One logical change per commit.** Each commit should be self-contained and coherent.
- New modules can be large (8-12 files, 200-800 lines) in a single commit — that is fine.
- Upgrade commits are typically tiny (1 file, 1 line changed) — that is also fine.
- Do NOT squash related-but-distinct changes. Separate commits are preferred:
  - `Make aws/postgresql module to setup necessary security group rules` (one commit)
  - `Make aws/redis module to setup necessary security group rules` (separate commit)
- Refactors and behavior changes go in separate commits:
  - `Move vpc creation code to eks.tf file for readability` (refactor, no behavior change)
  - `Upgrade hashicorp's aws/eks module to latest version 18.2` (separate commit with actual changes)

---

## 4. Merge Strategy & Branch Workflow

- **Linear history is strongly preferred.** Out of 80 commits, only 1 is a merge commit.
- Most work is committed directly to `main`.
- PRs exist but are rare and used primarily for external/team contributions.
- When PRs are used, merge commits follow GitHub's default format: `Merge pull request #N from org/branch`
- **No squash-merge pattern.** Individual commits are preserved in PRs.
- Single long-lived branch: `main`. No develop, staging, etc.

---

## 5. Versioning & Tags

- **Semantic versioning**: `vMAJOR.MINOR.PATCH` (e.g. `v0.1.0`, `v0.2.2`)
- **Release candidates**: `vMAJOR.MINOR.PATCH-rcN` (e.g. `v0.3.0-rc1`, `v0.3.0-rc2`)
- Tags are placed directly on commits (no release branches).
- Tag progression observed: `v0.0.1` -> `v0.1.0` -> `v0.2.0` -> `v0.2.1` -> `v0.2.2` -> `v0.3.0-rc1` -> `v0.3.0-rc2`
- Minor version bumps correspond to significant new capabilities or breaking changes.
- Patch versions are for non-breaking additions and fixes.

---

## 6. Edge Cases & Anti-patterns to Avoid

### DO NOT

- Use conventional commit prefixes (`feat:`, `fix:`, `chore:`, `build:`)
- Use ALL CAPS or exclamation marks in subjects
- Write passive subjects ("Security group rules were removed") — use active voice
- Amend commits to fix typos in messages (the repo has natural typos like "redundand", "assummed", "startard", "binded" — they are left as-is)
- Force-push to rewrite history on main
- Create empty merge commits
- Write generic messages like "Update code", "Fix bug", "Changes"
- Add ticket/issue numbers as prefixes (no `[JIRA-123]` or `#42:` style)

### EDGE CASES

1. **Draft/WIP commits** — acceptable with honest language: "Add draft of config for AWS", "Add very first version of do/k8s and k8s/basic modules"
2. **Multiple small changes in same area** — separate commits even if they could be squashed: each gets its own message explaining its purpose
3. **Reverting a wrong assumption** — explain what was wrong: "I wrongly assummed that they work like a firewall rules and I thought if we make a request to particular port from random port we need to allow connections back."
4. **Noting future work** — put it in the body: "It is still in progress. What I think needs to be added: * list of items"
5. **Cross-module changes** — no module prefix; use a descriptive subject covering the whole change
6. **Terraform-specific** — reference module paths in subjects when helpful: "In aws/iam module allow roles.*.assumers.current_users"
7. **One-liner facts** — sometimes a commit subject IS the entire message when it is self-explanatory: "Sometimes we attach AdministratorAccess to roles"
8. **PR description becomes commit body** — for the rare PRs, the merge commit uses the PR title; the individual commits inside carry the detail

---

## 7. Quick Reference

```
<Subject: Sentence case, no period, natural English, <=72 chars>

<Body: WHY not what, wrap at 72, first person OK>

<Optional: changelog links, code examples, future work notes>
```

### Checklist before committing

- [ ] Subject reads as natural English (not a machine format)
- [ ] Subject starts with a capital letter, no trailing period
- [ ] No conventional-commit prefix
- [ ] Body explains why (if the change is non-trivial)
- [ ] Upgrade commits include version transition in subject
- [ ] Upgrade commits link changelogs in body (for multi-version jumps)
- [ ] One logical change per commit
- [ ] Module prefix used only when change is scoped to one module
