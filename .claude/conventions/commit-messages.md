# Commit Message Conventions

All agents must follow these commit message guidelines when making git commits.

## Format

```
<type>: <subject>

[optional body]

[optional footer]
```

## Types (Hint Words)

Use these prefixes to indicate the purpose of the commit:

- **feat**: New feature or functionality
- **fix**: Bug fix
- **docs**: Documentation changes (README, CLAUDE.md, comments)
- **test**: Adding or updating tests
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **style**: Formatting, missing semicolons, etc. (no code change)
- **chore**: Maintenance tasks, dependency updates
- **perf**: Performance improvement
- **ci**: Changes to CI/CD configuration
- **build**: Changes to build system or dependencies
- **revert**: Reverting a previous commit

## Subject Line Rules

1. **Be concise**: Max 72 characters
2. **No period** at the end
3. **Imperative mood**: "add" not "added" or "adds"
4. **Lowercase** after the colon
5. **Descriptive**: Explain what, not how

## Examples

**Good**:
```
feat: add dark mode toggle to settings page
fix: resolve login redirect loop on session timeout
docs: update CLAUDE.md with authentication flow
test: add E2E tests for user registration
refactor: extract theme constants to separate file
chore: update dependencies to latest versions
```

**Bad**:
```
Added dark mode  // Missing type prefix
Fix: Fixed the bug  // Redundant, not imperative
feat: Dark Mode Toggle.  // Capital letters, period
update  // Too vague, missing type
```

## Body (Optional but Recommended)

For complex changes, add a body explaining:
- **Why** the change was made
- **What** alternative approaches were considered
- **Impact** on other parts of the system

Wrap at 72 characters.

Example:
```
feat: add dark mode toggle to settings

Users requested ability to switch between light and dark themes.
Implements toggle in settings page with three modes:
- Light
- Dark
- System preference

Persists choice to localStorage for consistency across sessions.
```

## Footer (Optional)

Use for:
- **Breaking changes**: `BREAKING CHANGE: description`
- **Issue references**: `Closes #123` or `Fixes PROJ-456`
- **Co-authors**: `Co-authored-by: Agent Name <agent@claude.ai>`

Example:
```
feat: redesign authentication API

BREAKING CHANGE: Auth endpoints now require API version header.
Clients must include `X-API-Version: 2` in all requests.

Closes #234
```

## Frequency

**Commit early and often**:
- ✅ After each logical unit of work (function, component, test)
- ✅ Before switching context to different task
- ✅ When tests pass after a fix
- ✅ After refactoring a module
- ❌ Don't wait until feature is "perfect"
- ❌ Don't combine unrelated changes

Example workflow:
```bash
# Step 1: Implement component
git add src/components/ThemeToggle.tsx
git commit -m "feat: create ThemeToggle component"

# Step 2: Add styles
git add src/styles/theme.css
git commit -m "style: add dark mode CSS variables"

# Step 3: Integrate
git add src/pages/Settings.tsx
git commit -m "feat: integrate ThemeToggle into settings page"

# Step 4: Tests
git add tests/theme-toggle.spec.ts
git commit -m "test: add E2E tests for theme toggle"

# Step 5: Documentation
git add .claude/CLAUDE.md
git commit -m "docs: document dark mode implementation in CLAUDE.md"
```

## Agent-Specific Guidelines

### senior-software-engineer
- Commit after each component/function is complete
- Separate feature code from test code (different commits)
- Refactoring gets its own commit

### test-automation-engineer
- One commit per test file or test suite
- Use `test:` prefix for all test additions

### documentation-specialist
- Commit CLAUDE.md updates separately from code
- Use `docs:` prefix consistently

### devops-engineer
- Infrastructure changes use `ci:` or `chore:`
- Worktree setup uses `chore: setup worktree for <feature>`

## Commit Messages in Atomic Workflows

When using `/ship-feature` or `/parallel-implement`:
- Each agent commits its own work independently
- Orchestrator does NOT squash commits (preserve agent history)
- Final PR shows full commit history for transparency

## Tools

To check commit message format:
```bash
# Install commitlint (optional)
npm install -g @commitlint/cli @commitlint/config-conventional

# Validate commit message
echo "feat: add dark mode" | commitlint
```

## References

Based on:
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#commit)
