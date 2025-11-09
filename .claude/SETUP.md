# Claude Code Multi-Agent Setup Guide

Quick reference for global, per-project, and per-session setup.

---

## Global Setup (One-Time)

Already complete! ✅

Your global configuration is synced via yadm and includes:

- **MCP Servers**: serena, playwright, github, filesystem, fetch, brave-search, postgres
- **Agents**: 8 specialized agents with moderate autonomy
- **Commands**: /ship-feature, /parallel-implement, /worktree-setup, /tmux-workspace, /codebase-sync
- **Permissions**: Safe operations allowed, writes/publishes require approval
- **Tools**: tmux installed

**No action required unless**:
- You add a new machine → Run `yadm clone <your-repo>` to sync
- You want to add/modify MCP servers → Edit `~/.claude/.mcp.json`
- You need custom permissions → Edit `~/.claude/settings.json`

---

## Per-Project Setup (Once Per Project)

### 1. Initialize Project Documentation

```bash
cd ~/Projects/your-project
/codebase-sync --init
```

This creates `.claude/CLAUDE.md` with auto-discovered project details.

### 2. Configure Project MCP Servers (Optional)

If project needs specific MCP servers:

```bash
# Create project MCP config
cat > .claude/.mcp.json <<EOF
{
  "mcpServers": {
    "serena": {
      "type": "stdio",
      "command": "/Users/mmccune/.local/bin/uvx",
      "args": [
        "--from", "git+https://github.com/oraios/serena",
        "serena", "start-mcp-server",
        "--context", "ide-assistant",
        "--project", "$(pwd)"
      ]
    }
  }
}
EOF
```

### 3. Set Project Permissions (Optional)

If project has custom tool requirements:

```bash
# Create project settings
cat > .claude/settings.local.json <<EOF
{
  "permissions": {
    "allow": [
      "Bash(npm run dev:*)",
      "Bash(npm run test:*)",
      "Bash(python manage.py:*)"
    ]
  },
  "enableAllProjectMcpServers": true
}
EOF
```

### 4. Commit Configuration (Optional)

```bash
git add .claude/
git commit -m "chore: add Claude Code configuration"
```

**That's it!** Project is ready for agent workflows.

---

## Per-Session (Each Time You Work)

### Starting Work

**Option A: Single Feature (Autonomous Pipeline)**

```bash
/ship-feature "Your feature description"
```

Orchestrates PM → UX → Engineer → Tester → Reviewer → PR.

**Option B: Parallel Development**

```bash
# Setup worktrees and tmux
/parallel-implement "Feature A" "Feature B" "Fix bug C"

# Attach to monitor
tmux attach -t parallel-dev
```

**Option C: Manual Agent Invocation**

```bash
# Explore codebase
Use code-archaeologist to find authentication implementation

# Implement feature
Use senior-software-engineer to add dark mode toggle

# Add tests
Use test-automation-engineer to write E2E tests
```

### During Work

**Monitor parallel agents**:
```bash
tmux attach -t <session-name>
# Ctrl+b then arrow keys to navigate panes
# Ctrl+b then d to detach
```

**Check worktrees**:
```bash
git worktree list
cd ../<repo>-<feature> && git status
```

### Ending Work

**Weekly maintenance** (run Friday afternoon):
```bash
/codebase-sync
```

Consolidates agent learnings and updates CLAUDE.md.

**Cleanup worktrees** (after PR merged):
```bash
git worktree remove ../<repo>-<feature>
git worktree prune
```

**Kill tmux session** (when done):
```bash
tmux kill-session -t <session-name>
```

---

## Quick Reference

### Agent Selection

- **Explore code**: code-archaeologist
- **Implement**: senior-software-engineer
- **Test**: test-automation-engineer
- **Review**: code-reviewer
- **Design**: ux-designer
- **Plan**: product-manager
- **Document**: documentation-specialist
- **Deploy**: devops-engineer

### Common Commands

```bash
/ship-feature "<description>"        # Full workflow
/parallel-implement "A" "B" "C"      # Parallel work
/worktree-setup feature-a feature-b  # Just worktrees
/tmux-workspace dev-session          # Just tmux
/codebase-sync                       # Weekly cleanup
/codebase-sync --init                # New project
```

### Tmux Shortcuts

```bash
tmux attach -t <name>       # Attach to session
Ctrl+b, arrow               # Navigate panes
Ctrl+b, z                   # Zoom pane (toggle)
Ctrl+b, d                   # Detach
tmux kill-session -t <name> # Kill session
```

### Git Worktree Commands

```bash
git worktree list                    # Show all worktrees
git worktree add ../<repo>-<name>    # Create worktree
git worktree remove ../<repo>-<name> # Remove worktree
git worktree prune                   # Clean references
```

---

## Troubleshooting

### Issue: MCP server not found
```bash
# Check enabled servers
cat ~/.claude/settings.json | grep enabledMcpjsonServers

# Restart Claude Code to reload MCP servers
```

### Issue: Tmux session already exists
```bash
tmux kill-session -t <name>
# Then retry command
```

### Issue: Worktree already exists
```bash
git worktree remove ../<repo>-<name>
# Or use different name
```

### Issue: Agent not committing properly
Remind agent: "Please follow conventional commit format from ~/.claude/conventions/commit-messages.md"

---

## Documentation

- **Full Guide**: `~/.claude/README.md`
- **Commit Conventions**: `~/.claude/conventions/commit-messages.md`
- **Agent Details**: `~/.claude/agents/`
- **Command Details**: `~/.claude/commands/`
- **Project Template**: `~/.claude/templates/CLAUDE.md`

---

**System Version**: 1.0.0
**Last Updated**: 2025-01-08
