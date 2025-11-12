-----
description: End-to-end feature delivery workflow. Orchestrates PM → UX → Engineer → Tester → Reviewer → PR creation. The complete autonomous agent pipeline.
argument-hint: "<feature-description>"

## Mission

Execute the complete feature delivery lifecycle with minimal user intervention. This command orchestrates multiple specialized agents in sequence (or parallel where possible) to take a high-level feature request from conception to review-ready pull request.

## Complete Workflow

```
User Input (Feature Request)
         ↓
   product-manager → PRD
         ↓
   ux-designer → Design Brief
         ↓
   senior-software-engineer → Implementation
         ↓
   test-automation-engineer → E2E Tests
         ↓
   code-reviewer → Review Feedback
         ↓
   Apply Fixes (if needed)
         ↓
   Create Pull Request
         ↓
   Update CLAUDE.md
         ↓
   Update Linear Priorities (Phase 6)
```

## When to Use

- Implementing a complete feature end-to-end
- Need full product/UX/eng/test/review cycle
- Want maximum autonomy with quality gates
- Working on a well-defined user story

## Command Invocation

**Basic**:
```bash
/ship-feature "Add dark mode toggle to user settings"
```

**With options**:
```bash
/ship-feature "Implement user notifications system" --skip-prd --parallel-test
```

**From Linear ticket**:
```bash
/ship-feature --linear PROJ-123
```

## Execution Phases

### Phase 1: Discovery & Planning (Parallel)

Run these agents in parallel to gather context:

1. **code-archaeologist** (Main Thread)
   - Explore codebase to understand existing patterns
   - Find similar features for reference
   - Identify components to reuse
   - Report findings: 2-minute summary

2. **product-manager** (Agent 1)
   - Create lightweight PRD
   - Define acceptance criteria
   - Identify success metrics
   - Output: `plans/prd-<feature-name>.md` or `plans/prd-<linear-issue>.md`

3. **ux-designer** (Agent 2)
   - Design user flow and states
   - Reuse existing components
   - Define accessibility requirements
   - Output: `plans/design-<feature-name>.md` or `plans/design-<linear-issue>.md`

**Checkpoint 1**: User reviews PRD + Design (30-second review)
```
📋 Planning Complete

PRD Summary:
- Feature: Dark mode toggle
- User Story: As a user, I want to switch between light/dark themes
- Success Metrics: 60%+ adoption within 2 weeks
- Scope: Settings page toggle + theme persistence

Design Summary:
- Component: Toggle switch (reuse existing Switch component)
- States: Light, Dark, System-preference
- Accessibility: Keyboard accessible, persists to localStorage
- Files: SettingsPage.tsx, ThemeProvider.tsx

✅ Proceed with implementation? [Y/n]
```

### Phase 2: Implementation

4. **senior-software-engineer** (Agent 3)
   - Read PRD and design brief
   - Use serena-mcp to find existing patterns
   - Implement feature following TDD
   - Run unit tests
   - Commit changes with clear messages
   - Output: Implementation in feature branch

**Progress Updates** (every 5 minutes):
```
⏳ Implementation in progress...
   ✅ Created ThemeContext (src/lib/theme.ts)
   ✅ Implemented ThemeToggle component (src/components/ThemeToggle.tsx)
   ⏳ Integrating into SettingsPage...
```

### Phase 3: Testing (Parallel with Fixes)

5. **test-automation-engineer** (Agent 4)
   - Write E2E tests based on acceptance criteria
   - Test all states (light, dark, system)
   - Test persistence and accessibility
   - Run tests, capture results
   - Output: `tests/dark-mode.spec.ts`

If tests fail → senior-software-engineer fixes → re-run tests

### Phase 4: Code Review

6. **code-reviewer** (Agent 5)
   - Use serena-mcp to understand full context
   - Review implementation for correctness, security, clarity
   - Check test coverage
   - Provide structured feedback
   - Output: Review report

**If blockers found**: senior-software-engineer addresses → code-reviewer re-reviews

**If approved**: Proceed to PR creation

### Phase 5: Pull Request Creation

7. **Finalization**
   - Ensure all tests pass
   - Update CLAUDE.md with learnings (documentation-specialist)
   - Create PR with comprehensive description
   - Link to PRD and design docs
   - **Requires user approval** before creating PR

### Phase 6: Priority Management

8. **Update Linear Priorities** (after PR created)
   - Update Linear ticket status to "Done"
   - Apply priority rules to all backlog issues:
     - Next task to work on → **Urgent** (Priority 1)
     - NOW label → **High** (Priority 2)
     - NEXT label → **Medium** (Priority 3)
     - LATER label → **Low** (Priority 4)
   - Identify the next task (next issue by lowest issue number with NOW label)
   - Promote that task to Urgent priority

**PR Description Template**:
```markdown
## Summary
[One-sentence description of the feature]

## Context
See full PRD: Plans/prd-dark-mode.md
See design: Plans/design-dark-mode.md

## Changes
- Added ThemeContext for app-wide theme state
- Implemented ThemeToggle component in settings
- Persists preference to localStorage
- Added E2E tests for all theme states

## Testing
- ✅ Unit tests: 12 passing
- ✅ E2E tests: 5 passing (tests/dark-mode.spec.ts)
- ✅ Accessibility: Keyboard navigation verified
- ✅ Code review: Approved (see review report)

## Screenshots
[If applicable]

## Rollout Plan
- Feature flag: `ENABLE_DARK_MODE` (default: true)
- Rollback: Remove toggle from settings UI

## Checklist
- [x] Tests added and passing
- [x] Code reviewed
- [x] CLAUDE.md updated
- [x] Accessibility verified
- [ ] Pending human approval
```

## Autonomy & User Checkpoints

### Auto-Proceed (No User Input):
- ✅ Agent task execution (PM, UX, Eng, Test)
- ✅ Running tests
- ✅ Code review process
- ✅ Updating CLAUDE.md
- ✅ Fixing issues identified by code review

### Ask User (Requires Approval):
- 🛑 After PRD/Design (Checkpoint 1): Proceed with implementation?
- 🛑 If major architectural change needed: Escalate for decision
- 🛑 Before creating PR: Review final changes?
- 🛑 Before pushing to GitHub: Confirm PR creation?

## Command Options

### `--skip-prd`
Skip product-manager agent, use user description as requirements.

### `--skip-design`
Skip ux-designer agent, engineer decides UI approach.

### `--parallel-test`
Run test-automation-engineer in parallel with implementation (risk: tests may need rework).

### `--auto-pr`
Automatically create PR after approval without final user review.

### `--linear <TICKET>`
Pull feature description from Linear ticket.

### `--worktree`
Execute in a dedicated git worktree (recommended for large features).

## Example Execution

```bash
> /ship-feature "Add dark mode toggle to settings"

🚀 Starting feature delivery workflow...

Phase 1: Discovery & Planning
  🔍 code-archaeologist exploring codebase...
     ✅ Found existing ThemeProvider pattern
     ✅ Settings page located at src/pages/Settings.tsx
     ✅ Similar toggle pattern in NotificationSettings

  📝 product-manager creating PRD...
     ✅ PRD complete: Plans/prd-dark-mode.md

  🎨 ux-designer creating design brief...
     ✅ Design complete: Plans/design-dark-mode.md

📋 [Checkpoint 1] Review planning artifacts?
   PRD: Dark mode toggle with light/dark/system modes
   Design: Reuse Switch component, localStorage persistence
   Estimated effort: 4 hours

   Proceed? [Y/n]: y

Phase 2: Implementation
  💻 senior-software-engineer implementing...
     ✅ Created ThemeContext
     ✅ Implemented ThemeToggle component
     ✅ Integrated into Settings page
     ✅ Added localStorage persistence
     ✅ Unit tests passing (14/14)
     ⏱️  Duration: 18 minutes

Phase 3: Testing
  🧪 test-automation-engineer writing E2E tests...
     ✅ Test: Toggle light → dark
     ✅ Test: Toggle dark → system
     ✅ Test: Persistence on reload
     ✅ Test: Keyboard navigation
     ✅ All tests passing (5/5)
     ⏱️  Duration: 8 minutes

Phase 4: Code Review
  👀 code-reviewer analyzing changes...
     ✅ Security: No vulnerabilities
     ✅ Correctness: Logic sound
     ✅ Tests: Adequate coverage
     💡 1 suggestion: Extract theme constants
     ⏱️  Duration: 3 minutes

  💻 senior-software-engineer applying feedback...
     ✅ Extracted theme constants to constants.ts
     ✅ Code review: APPROVED

Phase 5: Documentation & PR
  📚 documentation-specialist updating CLAUDE.md...
     ✅ Added dark mode pattern to CLAUDE.md

  📤 Preparing pull request...
     Title: Add dark mode toggle to user settings
     Branch: feature/dark-mode
     Files changed: 4 files (+187, -12)
     Tests: 19 passing

🎉 Feature complete! Ready to create PR.

[Checkpoint 2] Create pull request?
   Preview: https://github.com/<user>/<repo>/compare/feature/dark-mode

   Create PR? [Y/n]: y

✅ Pull request created: PR #42
   URL: https://github.com/<user>/<repo>/pull/42

Phase 6: Priority Management
  🎯 Updating Linear priorities...
     ✅ Marked M3L-31 as "Done"
     ✅ Updated 4 backlog issues with phase-based priorities
     ✅ Promoted M3L-35 to Urgent (next task to work on)
     ⏱️  Duration: 1 minute

📊 Summary:
   ⏱️  Total time: 33 minutes (agents working autonomously)
   ✅ All quality gates passed
   📝 Documentation updated
   🧪 Test coverage: 92%
   🎯 Next task ready: M3L-35 (Urgent priority)

Next steps:
   1. Review PR on GitHub
   2. Request reviews from team
   3. Merge when approved
   4. Work on M3L-35 (now marked Urgent)
```

## Error Handling

### Tests Fail
```
❌ E2E tests failing (2/5 failed)

   Issue: Dark mode not applying to navigation bar

   Options:
   1. [Auto] senior-software-engineer investigates and fixes
   2. [Manual] You debug in worktree: cd ../<repo>-dark-mode

   Proceed with auto-fix? [Y/n]: y

   ✅ Fix applied, tests now passing
```

### Code Review Blocker
```
🚨 Code reviewer found blocking issues:
   - Security: Potential XSS in theme name rendering
   - Missing error handling for localStorage quota exceeded

   Escalating to user...

   Options:
   1. senior-software-engineer addresses automatically
   2. You review manually before proceeding

   Auto-fix? [Y/n]: n

   Review the issues in: Plans/code-review-dark-mode.md
```

### Merge Conflicts
```
⚠️  Merge conflict detected with main branch

   Conflicting files:
   - src/pages/Settings.tsx (both modified navigation)

   Options:
   1. Abort and ask user to resolve
   2. devops-engineer attempts auto-merge
   3. Pause and notify user

   How to proceed? [1/2/3]: 1

   ❌ Feature delivery paused. Please resolve conflicts manually.
```

## Integration with /Linear

When invoked with `--linear PROJ-123`:

1. Fetch ticket from Linear via Linear MCP
2. Extract:
   - Title → Feature name
   - Description → User story & requirements
   - Acceptance criteria → Test scenarios
   - Labels → Skip flags (e.g., `no-design` → --skip-design)
3. Proceed with workflow

After PR created:
- Update Linear ticket with PR link
- Add comment: "PR created by Claude Code autonomous workflow"
- Move ticket to "In Review" status (if user configured)

After PR merged/ticket marked "Done":
1. **Update priorities for all backlog issues**:
   ```bash
   # Priority rules based on phase labels
   - Next task (first NOW issue in backlog) → Urgent (Priority 1)
   - All NOW label issues → High (Priority 2)
   - All NEXT label issues → Medium (Priority 3)
   - All LATER label issues → Low (Priority 4)
   ```

2. **Automatic priority promotion**:
   - When a NOW task is completed, the next NOW task becomes Urgent
   - Ensures continuous workflow: always one Urgent task to work on next
   - Phase labels (NOW/NEXT/LATER) remain stable, priorities update dynamically

3. **Example workflow**:
   ```
   Before completing M3L-31:
   - M3L-31 (NOW) → Urgent ✓ (working on this)
   - M3L-35 (NOW) → High
   - M3L-54 (NEXT) → Medium

   After completing M3L-31:
   - M3L-31 → Done (archived)
   - M3L-35 (NOW) → Urgent ✓ (promoted - work on this next)
   - M3L-54 (NEXT) → Medium
   ```

## Success Metrics

Track and report:
- ⏱️ **Time to ship**: Total duration from start to PR
- 🤖 **Agent handoffs**: Number of successful agent transitions
- ✅ **First-time pass rate**: Features that pass review without fixes
- 🐛 **Issues caught**: Bugs found by code-reviewer before human review
- 📈 **Velocity**: Features shipped per week using this workflow

## Limitations

What this command does NOT do:
- ❌ Make product decisions (user decides scope)
- ❌ Resolve ambiguous requirements (will ask for clarification)
- ❌ Merge PR to main (user approval required)
- ❌ Deploy to production (use CD pipeline)
- ❌ Handle breaking API changes without escalation

## Future Enhancements

- Real-time progress dashboard in tmux pane
- Parallel implementation of independent sub-features
- A/B test variant generation
- Automatic rollback if tests fail in CI
- Cost estimation before starting (token usage prediction)

-----
