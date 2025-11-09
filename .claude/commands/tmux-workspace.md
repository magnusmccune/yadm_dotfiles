-----
description: Create a tmux session with panes for multi-agent parallel workflows. Automatically detects git worktrees or sets up custom pane layout.
argument-hint: "[session-name] [layout-type]"

## Mission

Launch a tmux session optimized for multi-agent development workflows. Automatically discovers git worktrees and creates a pane for each, or allows custom layout specification for coordinating multiple agents.

## When to Use

- After creating worktrees with `/worktree-setup`
- Coordinating multiple agents (implement, review, test, deploy)
- Monitoring logs/builds while developing
- Parallel feature development

## Layout Types

### 1. Auto (Default)
Detects git worktrees and creates one pane per worktree + orchestrator pane.

### 2. Review Workflow
3 panes: Implementer, Reviewer, Test Runner
```
+-------------------+-------------------+
| Orchestrator      | Code Reviewer     |
| (main repo)       | (review worktree) |
+-------------------+-------------------+
| Test Runner       |                   |
| (test output)     |                   |
+-------------------+-------------------+
```

### 3. Parallel Features
4 panes: Orchestrator + 3 feature worktrees
```
+-------------------+-------------------+
| Orchestrator      | Feature 2         |
| (main repo)       | (worktree-2)      |
+-------------------+-------------------+
| Feature 1         | Feature 3         |
| (worktree-1)      | (worktree-3)      |
+-------------------+-------------------+
```

### 4. Full Stack
4 panes: Frontend, Backend, Database, Logs
```
+-------------------+-------------------+
| Frontend Dev      | Backend Dev       |
| (port 8080)       | (port 3000)       |
+-------------------+-------------------+
| Database          | Logs/Monitor      |
| (psql shell)      | (tail -f)         |
+-------------------+-------------------+
```

### 5. Custom
Specify number of panes (1-9) and manually assign purposes.

## Command Behavior

### Auto-Detection Flow

1. **Detect Worktrees**
   ```bash
   git worktree list --porcelain
   ```

2. **Count Panes Needed**
   - Main repo: 1 pane (orchestrator)
   - Each worktree: 1 pane
   - Logs/monitoring: 1 pane (optional)
   - Total: 2-6 panes recommended

3. **Create Session**
   ```bash
   session_name="${1:-dev-workspace}"
   tmux new-session -s "$session_name" -d

   # Split into appropriate layout
   # Navigate each pane to its directory
   # Optional: Start dev server in each pane
   ```

### Example Usage

**Basic (auto-detect worktrees)**:
```bash
/tmux-workspace
```

**Named session**:
```bash
/tmux-workspace feature-dev
```

**Specific layout**:
```bash
/tmux-workspace dev-session review-workflow
```

**Custom panes**:
```bash
/tmux-workspace fullstack 4
```

### Output

```
🚀 Creating tmux workspace: dev-session

📊 Detected Environment:
   Main repo: /Users/user/Projects/<repo-name> (main)
   Worktree 1: ../<repo-name>-dark-mode (feature/dark-mode)
   Worktree 2: ../<repo-name>-api (feature/api-refactor)

🎛️  Layout: 4-pane parallel (orchestrator + 2 worktrees + logs)

✅ Tmux session created!

   Attach to session:
     tmux attach -t dev-session

   Pane navigation:
     Ctrl+b + arrow keys  (move between panes)
     Ctrl+b + z           (zoom current pane)
     Ctrl+b + d           (detach from session)

   Kill session:
     tmux kill-session -t dev-session

📝 Session saved to ~/.tmux-workspace-dev-session.conf
```

## Implementation Steps

### 1. Detect Environment

```bash
# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
  echo "❌ Error: tmux is not installed"
  echo "Install: brew install tmux"
  exit 1
fi

# Get git context
repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -z "$repo_root" ]; then
  echo "⚠️  Warning: Not in a git repository. Using current directory."
  repo_root=$(pwd)
fi

# List worktrees
worktrees=$(git worktree list --porcelain 2>/dev/null | grep "^worktree" | cut -d' ' -f2)
```

### 2. Create Session

```bash
session_name="${1:-dev-workspace}"

# Check if session already exists
if tmux has-session -t "$session_name" 2>/dev/null; then
  echo "⚠️  Session '$session_name' already exists"
  echo "   Attach: tmux attach -t $session_name"
  echo "   Kill:   tmux kill-session -t $session_name"
  exit 1
fi

# Create new session (detached)
tmux new-session -s "$session_name" -d -c "$repo_root"
```

### 3. Configure Layout

For review-workflow:
```bash
# Split horizontally (top/bottom)
tmux split-window -h -t "$session_name:0"

# Split bottom pane vertically
tmux split-window -v -t "$session_name:0.0"

# Pane 0 (top-left): Orchestrator at main repo
tmux send-keys -t "$session_name:0.0" "cd $repo_root" C-m
tmux send-keys -t "$session_name:0.0" "clear && echo 'Orchestrator: Main Repo'" C-m

# Pane 1 (top-right): Code reviewer
worktree_review=$(echo "$worktrees" | sed -n '1p')
tmux send-keys -t "$session_name:0.1" "cd $worktree_review" C-m
tmux send-keys -t "$session_name:0.1" "clear && echo 'Code Reviewer'" C-m

# Pane 2 (bottom-left): Test runner
tmux send-keys -t "$session_name:0.2" "cd $repo_root" C-m
tmux send-keys -t "$session_name:0.2" "clear && echo 'Test Runner'" C-m
```

### 4. Optional: Auto-start Services

If project has dev servers, optionally start them:
```bash
# Check for package.json with "dev" script
if [ -f "$worktree_path/package.json" ] && grep -q '"dev"' "$worktree_path/package.json"; then
  tmux send-keys -t "$session_name:0.1" "npm run dev" C-m
fi
```

### 5. Save Configuration

```bash
# Save session for easy restoration
tmux_config="$HOME/.tmux-workspace-${session_name}.conf"
cat > "$tmux_config" <<EOF
# Tmux workspace: $session_name
# Created: $(date)
# Layout: review-workflow

# To restore:
#   source $tmux_config
#   tmux attach -t $session_name

Session: $session_name
Panes:
  0 - Orchestrator: $repo_root
  1 - Feature Dev: $worktree_1
  2 - Test Runner: $repo_root
EOF
```

## Pane Management

### Default Keybindings (User Reference)

```
Ctrl+b + %         Split vertically
Ctrl+b + "         Split horizontally
Ctrl+b + arrow     Navigate panes
Ctrl+b + z         Zoom current pane (toggle fullscreen)
Ctrl+b + x         Kill current pane
Ctrl+b + d         Detach from session
Ctrl+b + [         Scroll mode (q to exit)
```

### Custom Keybindings (Optional Enhancement)

Add to `~/.tmux.conf`:
```bash
# Better pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
```

## Integration with Agents

### Agent Assignment Pattern

After creating tmux session, you can manually invoke agents in specific panes or use `/parallel-implement` to auto-assign.

**Example Manual Assignment**:
1. Attach to session: `tmux attach -t dev-session`
2. Navigate to Pane 1 (feature worktree)
3. Run Claude Code in that directory
4. Invoke agent: "Use senior-software-engineer agent to implement dark mode feature"

**Example Automated Assignment** (via /parallel-implement):
```
/parallel-implement dark-mode api-refactor
  → Creates tmux session
  → Launches agent in each pane
  → Monitors progress from orchestrator pane
```

## Cleanup

### Detach from Session
```bash
# While in tmux
Ctrl+b + d
```

### Kill Session
```bash
tmux kill-session -t dev-session
```

### List Active Sessions
```bash
tmux list-sessions
```

## Error Handling

**Tmux not installed**:
```
❌ Error: tmux is not installed

   Install via homebrew:
     brew install tmux

   Or run: /help tmux-workspace
```

**Session already exists**:
```
⚠️  Session 'dev-session' already exists

   Options:
   1. Attach: tmux attach -t dev-session
   2. Kill:   tmux kill-session -t dev-session && /tmux-workspace dev-session
   3. Rename: /tmux-workspace dev-session-2
```

**No worktrees found**:
```
⚠️  No git worktrees detected

   Create worktrees first:
     /worktree-setup feature-a feature-b

   Or specify a custom layout:
     /tmux-workspace dev-session custom 4
```

## Advanced: Persistent Sessions

For long-running agent workflows, consider using `tmux-resurrect` plugin to save/restore sessions across reboots.

-----
