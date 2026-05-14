---
name: drafting-pr-info-cn
description: Use when preparing Chinese Pull Request information from the current branch diff, including requests like "帮我写PR信息", "我要进行PR了", "生成PR标题/正文", or branch-diff-based PR summaries without creating the remote PR
---

# Drafting PR Info CN

## Overview

Draft ready-to-paste Chinese PR information from the actual branch diff. Treat repository state as source of truth.

**Core principle:** inspect first, draft second, never create the remote PR unless the user explicitly asks.

## Required Checks

Run repository inspection before drafting:

```bash
git status --short --branch
git branch --show-current
git log --oneline --reverse <base>..HEAD
git diff --stat <base>..HEAD
```

If the base branch is unclear, ask one concise question.

Inspect key file diffs when the stat/log is not enough:

```bash
git diff <base>..HEAD -- <path>
```

## Drafting Rules

- Write the final PR information in Simplified Chinese.
- Use PR title format `[版本号]type(scope): 中文标题` when a version is present.
- If no version is present, use `type(scope): 中文标题`.
- Preserve the Conventional Commit `type(scope)` style; infer `type` and `scope` from the diff.
- Example title: `[0.1.1]feat(agent-ui): 支持仪表盘编辑草稿预览与任务流体验优化`
- Base the content only on committed/tracked branch changes.
- Separate `untracked` files from PR content; warn that they are not included in the branch diff.
- Call out version/config changes separately instead of burying them in feature bullets.
- Do NOT run `gh pr create` or push branches unless the user explicitly asks.
- 不要虚构验证结果. If verification was not run in this turn, label it as `待验证` or `建议验证`.

## Output Format

Use this structure:

```markdown
## PR 标题

<[版本号]type(scope): 中文标题>

## 变更说明

<one short paragraph>

## 主要改动

- <change 1>
- <change 2>
- <change 3>

## 影响范围

- <affected area>

## 验证方式

- 已验证: <command and result, only if actually run>
- 待验证: <suggested command or manual check>

## 注意事项

- <untracked files, version/config drift, migration notes, or none>
```

## Quick Reference

| Situation                          | Action                                           |
| ---------------------------------- | ------------------------------------------------ |
| User asks for PR info              | Draft title/body only                            |
| Base branch unclear                | Infer common base or ask                         |
| `git status` shows untracked files | Mention separately, do not include as PR changes |
| Tests not run                      | Mark verification as `待验证` or `建议验证`      |
| User asks to create PR             | Confirm remote action, then use project workflow |

## Common Mistakes

### Creating the PR too early

- **Problem:** The user asked for PR information, not a remote PR.
- **Fix:** Draft ready-to-paste content. Do NOT run `gh pr create`.

### Including local-only files

- **Problem:** Untracked files appear in `git status` but are not part of the branch diff.
- **Fix:** Warn about them under `注意事项`.

### Overclaiming verification

- **Problem:** Listing tests as passed when they were not run in the current turn.
- **Fix:** Only write `已验证` with fresh command evidence; otherwise write `待验证`.

## Red Flags

**Never:**

- Draft from memory without checking current git state.
- Include `untracked` files as PR changes.
- Claim tests passed without running them.
- Run `gh pr create` unless explicitly requested.

**Always:**

- Inspect `git status --short --branch` first.
- Use `git log --oneline --reverse` and `git diff --stat` against the base.
- Keep the output ready to paste.
- Keep code identifiers, file paths, commands, and branch names unchanged.
