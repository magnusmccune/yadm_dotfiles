-----
description: Orchestrate multiple agents working in parallel across git worktrees to implement features simultaneously. Auto-creates worktrees, tmux session, and dispatches appropriate agents.
argument-hint: "<task-1> <task-2> [task-3]"

## Mission

Enable true parallel development by orchestrating multiple agents across isolated git worktrees. Each agent works independently on its assigned task in a dedicated worktree, coordinated via tmux for visibility and monitoring.

## When to Use

- Multiple independent features to implement simultaneously
- Breaking a large feature into parallel sub-tasks
- Experimenting with different approaches concurrently
- Maximizing throughput on a multi-feature sprint

## Command Workflow

### 1. Task Input & Planning

**Input**: 2-5 task descriptions
```bash
/parallel-implement "Add dark mode toggle" "Implement user settings page" "Fix authentication bug"
```

**Planning Phase**:
- Analyze each task for independence (no shared files)
- Warn if tasks might conflict
- Suggest task breakdown if dependencies detected
- Assign appropriate agent to each task

### 2. Infrastructure Setup

Automatically execute:
```bash
# Create worktrees for each task
/worktree-setup dark-mode user-settings auth-fix

# Create tmux session with panes
/tmux-workspace parallel-dev parallel-features
```

### 3. Agent Dispatch

For each task, determine best agent:
- **Code implementation** → `senior-software-engineer`
- **Bug fixes** → `senior-software-engineer`
- **Testing** → `test-automation-engineer`
- **Documentation** → `documentation-specialist`
- **UI/UX work** → `ux-designer` then `senior-software-engineer`

### 4. Parallel Execution

Launch agents in their respective worktrees:

```
Orchestrator (Main Pane):
  ├─ Monitoring agent progress
  ├─ Resolving conflicts if detected
  └─ Coordinating next steps

Agent 1 (Pane 1 - worktree-1):
  └─ Task: senior-software-engineer implementing dark mode

Agent 2 (Pane 2 - worktree-2):
  └─ Task: senior-software-engineer implementing settings page

Agent 3 (Pane 3 - worktree-3):
  └─ Task: senior-software-engineer fixing auth bug
```

### 5. Progress Monitoring

Orchestrator tracks:
- ✅ Completed tasks
- ⏳ In-progress tasks
- ❌ Blocked tasks (waiting on dependencies or conflicts)
- 🔄 Tasks requiring merge conflict resolution

### 6. Consolidation

When all agents complete:
1. Review each worktree's changes
2. Run tests in each worktree independently
3. Merge successful changes back to main
4. Create consolidated PR or individual PRs per task
5. Clean up worktrees

## Example Execution

```
> /parallel-implement "Dark mode toggle" "Settings page UI" "Fix login redirect bug"

📋 Planning Parallel Implementation...

Task Analysis:
  ✅ Task 1: Dark mode toggle (UI + state management)
     Agent: senior-software-engineer
     Files: src/components/ThemeToggle.tsx, src/lib/theme.ts
     Conflicts: None detected

  ✅ Task 2: Settings page UI (new feature)
     Agent: ux-designer → senior-software-engineer
     Files: src/pages/Settings.tsx, src/components/SettingsForm.tsx
     Conflicts: None detected

  ✅ Task 3: Fix login redirect bug (bugfix)
     Agent: senior-software-engineer
     Files: src/auth/login.ts
     Conflicts: None detected

🔧 Setting up infrastructure...
  ✅ Created worktree: ../helpful-badger-dark-mode
  ✅ Created worktree: ../helpful-badger-settings
  ✅ Created worktree: ../helpful-badger-login-fix
  ✅ Tmux session: parallel-dev (4 panes)

🚀 Dispatching agents...
  Pane 1: senior-software-engineer → Dark mode
  Pane 2: ux-designer + senior-software-engineer → Settings page
  Pane 3: senior-software-engineer → Login bug fix
  Pane 0: Orchestrator (monitoring)

⏳ Agents working... (Use `tmux attach -t parallel-dev` to observe)

[15 minutes later]

📊 Progress Update:
  ✅ Task 1: Dark mode - COMPLETE (tests passing)
  ✅ Task 2: Settings page - COMPLETE (tests passing)
  ✅ Task 3: Login fix - COMPLETE (tests passing)

🎉 All tasks complete!

Next steps:
  1. Review changes: cd ../helpful-badger-dark-mode && git diff main
  2. Run integration tests across all worktrees
  3. Merge to main or create PRs

Would you like to:
  [1] Create individual PRs for each task
  [2] Merge all changes into a single PR
  [3] Review changes manually first
```

## Conflict Detection & Resolution

### Pre-Flight Conflict Check

Before starting, analyze tasks for potential conflicts:

```bash
# For each pair of tasks, check file overlap
task1_files=$(analyze_task_files "dark mode toggle")
task2_files=$(analyze_task_files "settings page")

overlap=$(comm -12 <(echo "$task1_files" | sort) <(echo "$task2_files" | sort))

if [ -n "$overlap" ]; then
  echo "⚠️  Warning: Tasks may conflict on files:"
  echo "$overlap"
  echo "   Recommendation: Run sequentially or assign one agent to both"
fi
```

### Runtime Conflict Handling

If agents modify overlapping files:

1. **Detect**: Monitor git status in each worktree
2. **Alert**: Notify orchestrator of conflict risk
3. **Resolve**:
   - Option A: Pause one agent, let other complete, then rebase
   - Option B: Manually merge in orchestrator pane
   - Option C: Re-assign tasks to single agent

## Agent Assignment Logic

```
function assign_agent(task_description):
  if task contains ["UI", "design", "layout", "component"]:
    return "ux-designer" then "senior-software-engineer"

  elif task contains ["test", "e2e", "playwright"]:
    return "test-automation-engineer"

  elif task contains ["bug", "fix", "issue"]:
    return "senior-software-engineer"

  elif task contains ["docs", "README", "guide"]:
    return "documentation-specialist"

  elif task contains ["deploy", "CI", "pipeline"]:
    return "devops-engineer"

  else:
    return "senior-software-engineer"  # default
```

## Implementation Notes

### Orchestrator Responsibilities

The orchestrator (main pane) is YOU (the user) or an orchestration agent that:

1. **Monitors Progress**: Watches each pane for completion signals
2. **Handles Blockers**: If an agent gets stuck, intervenes
3. **Coordinates Dependencies**: If Task B depends on Task A, ensures ordering
4. **Validates Results**: Runs cross-worktree integration tests
5. **Manages Merges**: Consolidates successful changes

### Agent Communication

Agents can't directly communicate, but can:
- Update shared CLAUDE.md with discoveries (user reviews)
- Use `project-context.json` for findings (if Phase 5 implemented)
- Signal completion via git commits

### Resource Management

**CPU/Memory Limits**:
- Max 3-4 parallel agents on typical laptop
- Heavy builds (npm install) can strain resources
- Consider staggering agent start times

**Disk Space**:
- Each worktree = full node_modules copy (~500MB)
- Monitor available disk space
- Clean up worktrees after merge

## Success Criteria

Parallel implementation is successful when:
- ✅ All tasks complete without conflicts
- ✅ Tests pass in each worktree independently
- ✅ Integration tests pass after merging
- ✅ No duplicate work or conflicting implementations
- ✅ CLAUDE.md updated with learnings from each agent

## Safety & Rollback

### Save State Before Starting

```bash
# Save current branch and uncommitted changes
current_branch=$(git rev-parse --abbrev-ref HEAD)
git stash push -m "pre-parallel-implement backup"

# Log can rollback if needed
echo "Rollback: git checkout $current_branch && git stash pop"
```

### Abort Mid-Execution

If things go wrong:
```bash
# Kill tmux session (stops all agents)
tmux kill-session -t parallel-dev

# Remove worktrees
git worktree remove --force ../helpful-badger-dark-mode
git worktree remove --force ../helpful-badger-settings
git worktree remove --force ../helpful-badger-login-fix
git worktree prune

# Return to original state
git checkout $current_branch
git stash pop
```

## Future Enhancements (Phase 5+)

- **Agent Progress API**: Real-time progress updates in orchestrator
- **Automatic Conflict Resolution**: AI-powered merge conflict resolution
- **Dependency Graph**: Visual representation of task dependencies
- **Cost Estimation**: Predict token usage for parallel vs sequential

-----
