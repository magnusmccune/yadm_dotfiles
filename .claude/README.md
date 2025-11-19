# Claude Code Multi-Agent Workflow System

**Version**: 1.0.0
**Last Updated**: 2025-01-08

A comprehensive multi-agent orchestration system for Claude Code that enables autonomous, parallel development workflows with continuous learning and knowledge capture.

---

## Overview

This system transforms Claude Code from a single-agent assistant into a coordinated multi-agent development platform where you act as architect, directing specialized agents that work autonomously in parallel worktrees, coordinate complex tasks, and continuously improve project knowledge.

### Key Features

- **8 Specialized Agents** with domain expertise (PM, UX, Engineering, Testing, DevOps, Review, Documentation, Code Archaeology)
- **Multi-Agent Orchestration** via git worktrees and tmux sessions
- **MCP Server Integration** (serena, playwright, github, filesystem, fetch, postgres)
- **Automated CLAUDE.md Updates** - agents learn and document as they work
- **End-to-End Workflows** - from ticket to PR with minimal human intervention
- **Conventional Commit Standards** - agents commit early and often with structured messages
- **Moderate Autonomy** - agents make tactical decisions, escalate strategic ones

---

## What Was Built

### Phase 1: Infrastructure Foundation

**Global MCP Configuration** (`~/.claude/.mcp.json`):
- `serena-global` - Code symbol search and pattern finding
- `playwright` - E2E testing and browser automation
- `github` - Repository operations, PRs, issues
- `filesystem` - File access for Projects directory
- `fetch` - Web content retrieval
- `brave-search` - Web search capabilities
- `postgres` - Database access

**Global Settings** (`~/.claude/settings.json`):
- Permissions configured for safe agent operation
- Read operations allowed, write operations require approval
- GitHub/Linear operations always ask before executing
- Dangerous operations (force push, rm -rf) blocked

### Phase 2: Specialized Agents

Created in `~/.claude/agents/`:

1. **test-automation-engineer** - Playwright E2E testing specialist
2. **devops-engineer** - Git worktrees, tmux, CI/CD orchestration
3. **documentation-specialist** - CLAUDE.md maintenance
4. **code-archaeologist** - Serena-MCP expert for codebase exploration

Updated existing agents:
5. **senior-software-engineer** - Enhanced with MCP tools, commit conventions
6. **code-reviewer** - Uses serena-mcp for context
7. **product-manager** - Explores codebases with serena
8. **ux-designer** - Discovers existing components via serena

All agents configured with:
- MCP tool usage patterns
- CLAUDE.md update responsibilities
- Moderate autonomy guidelines
- Conventional commit message formats

### Phase 3: Worktree & Tmux Orchestration

**Commands** (`~/.claude/commands/`):

- **/worktree-setup** - Create git worktrees for parallel development
- **/tmux-workspace** - Launch tmux sessions with agent panes
- **/parallel-implement** - Orchestrate agents across worktrees

Enables true parallel workflows:
```
Main repo (tmux pane 0) - Orchestrator
├── worktree-1 (pane 1) - Agent implementing feature A
├── worktree-2 (pane 2) - Agent implementing feature B
└── logs (pane 3) - Monitoring and test output
```

### Phase 4: End-to-End Workflows

**/ship-feature** - Complete autonomous pipeline:
```
Feature Request
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
Pull Request Created
    ↓
CLAUDE.md Updated
```

### Phase 5: Continuous Learning System

**Enhanced CLAUDE.md Template** (`~/.claude/templates/CLAUDE.md`):
- Comprehensive project documentation structure
- Dedicated "Agent Learnings" section
- Architecture patterns, testing strategy, gotchas
- Auto-updated by agents after each task

**/codebase-sync** - Documentation maintenance:
- Consolidate agent learnings weekly
- Apply template updates
- Check for stale information
- Multi-project sync support

**Commit Conventions** (`~/.claude/conventions/commit-messages.md`):
- Conventional Commits format enforced
- Agents commit early and often
- Types: feat, fix, docs, test, refactor, chore, ci, etc.

---

## Quick Start

**📖 For concise setup instructions, see [SETUP.md](SETUP.md)**

The SETUP.md guide provides quick reference for:
- **Global setup** (one-time, already complete ✅)
- **Per-project setup** (once per project)
- **Per-session workflow** (each time you work)

This README contains comprehensive documentation. Use SETUP.md for quick reference during daily work.

---

## Agent Usage Patterns

### Invoking Agents Directly

Agents are automatically selected by orchestration commands, but you can invoke them directly:

```bash
# Explore codebase
Use the code-archaeologist agent to find where user authentication is handled

# Implement feature
Use the senior-software-engineer agent to add a dark mode toggle

# Write tests
Use the test-automation-engineer agent to add E2E tests for the new feature

# Review code
Use the code-reviewer agent to review the changes in the current branch
```

### Agent Autonomy Levels

**Agents Decide Independently**:
- Code structure, naming, file organization
- Which existing patterns to reuse
- Test strategies
- Documentation wording

**Agents Escalate to You**:
- Architectural changes
- New major dependencies
- Breaking API changes
- Database schema changes
- Security-sensitive operations

**Always Require Approval**:
- Creating GitHub PRs or issues
- Pushing to git
- Publishing packages
- Database operations
- Writing files via MCP

---

## Configuration Files

### Global (~/.claude/)

```
.claude/
├── .mcp.json                  # Global MCP servers
├── settings.json              # Global settings & permissions
├── settings.local.json        # Local overrides (git-managed via yadm)
├── CLAUDE.md                  # Personal preferences
├── agents/                    # Agent definitions
│   ├── code-archaeologist.md
│   ├── code-reviewer.md
│   ├── devops-engineer.md
│   ├── documentation-specialist.md
│   ├── product-manager.md
│   ├── senior-software-engineer.md
│   ├── test-automation-engineer.md
│   └── ux-designer.md
├── commands/                  # Slash commands
│   ├── codebase-sync.md
│   ├── Linear.md
│   ├── parallel-implement.md
│   ├── ship-feature.md
│   ├── tmux-workspace.md
│   └── worktree-setup.md
├── conventions/               # Shared conventions
│   └── commit-messages.md
└── templates/                 # Templates
    └── CLAUDE.md              # Project CLAUDE.md template
```

### Per-Project (.claude/)

```
<project>/.claude/
├── CLAUDE.md                  # Project documentation
├── .mcp.json                  # Project MCP servers (optional)
├── settings.local.json        # Project permissions (optional)
└── project-context.json       # Shared agent knowledge (future)
```

---

## Workflows

### Workflow 1: Ship a Feature End-to-End

```bash
# Option A: From scratch
/ship-feature "Add user notifications system"

# Option B: From Linear ticket
/ship-feature --linear PROJ-123

# System will:
# 1. PM creates PRD
# 2. UX creates design brief
# 3. Checkpoint: You review and approve
# 4. Engineer implements with tests
# 5. Tests run and pass
# 6. Code review identifies issues
# 7. Engineer fixes issues
# 8. Code review approves
# 9. CLAUDE.md updated
# 10. PR created (with your approval)
```

### Workflow 2: Parallel Development

```bash
# Setup worktrees and tmux
/parallel-implement "Feature A" "Feature B" "Fix bug C"

# Attach to tmux to monitor
tmux attach -t parallel-dev

# Orchestrator (Pane 0): You monitor progress
# Pane 1: Agent working on Feature A
# Pane 2: Agent working on Feature B
# Pane 3: Agent fixing bug C

# When done, review changes in each worktree
cd ../project-feature-a && git diff main
cd ../project-feature-b && git diff main

# Create PRs or merge
```

### Workflow 3: Test-Driven Development

```bash
# 1. Write tests first
Use test-automation-engineer to write E2E tests for the planned dark mode feature

# 2. Implement feature
Use senior-software-engineer to implement dark mode to pass the tests

# 3. Review
Use code-reviewer to review the implementation
```

### Workflow 4: Code Archaeology

```bash
# Understand unfamiliar codebase quickly
Use code-archaeologist to explain how user authentication works in this project

# Agent will:
# - Use serena-mcp to find auth-related code
# - Trace the flow from API to database
# - Document findings
# - Update CLAUDE.md
```

### Workflow 5: Weekly Maintenance

```bash
# Run weekly on Friday afternoon
/codebase-sync

# Reviews agent learnings from past week
# Promotes important patterns to main sections
# Archives outdated entries
# Shows you a summary for approval
```

---

## MCP Server Details

### serena-global

**Purpose**: Efficient code symbol search and pattern finding

**When agents use it**:
- Before implementing features (find existing patterns)
- During code review (find all usages)
- For code archaeology (understand architecture)

**Benefit**: 60%+ reduction in context usage vs Grep/Glob

**Configuration**:
```json
{
  "type": "stdio",
  "command": "/Users/mmccune/.local/bin/uvx",
  "args": [
    "--from", "git+https://github.com/oraios/serena",
    "serena", "start-mcp-server",
    "--context", "ide-assistant"
  ]
}
```

### playwright

**Purpose**: E2E testing and browser automation

**When agents use it**:
- test-automation-engineer writing tests
- senior-software-engineer verifying implementation
- /ship-feature automated testing phase

**Common operations**:
- Navigate pages
- Click elements
- Fill forms
- Capture screenshots

### github

**Purpose**: Repository operations, PRs, issues

**Permissions**: Always ask before create/update/delete operations

**When agents use it**:
- devops-engineer creating PRs
- /ship-feature final PR creation
- product-manager fetching Linear tickets
- code-reviewer checking PR status

### Other MCP Servers

- **filesystem**: Read project files, list directories
- **fetch**: Retrieve web documentation
- **brave-search**: Research during PRD creation
- **postgres**: Database queries (ask first)

---

## Permissions Model

### Philosophy

Agents have **moderate autonomy**:
- Read/explore freely
- Implement/test autonomously
- Ask before publishing/deploying

### Permission Levels

**Allow (No Prompt)**:
- MCP serena, playwright (all operations)
- MCP github get/list/search (read operations)
- MCP filesystem read/list
- git status, log, diff, branch
- git worktree operations
- tmux operations
- Playwright test execution

**Ask (Requires Approval)**:
- MCP github create/update/delete
- MCP filesystem write/create
- MCP postgres (all operations)
- git push
- gh pr create, gh issue create
- npm publish, docker push

**Deny (Blocked)**:
- git push --force
- rm -rf

### Customization

**Global** (`~/.claude/settings.json`):
```json
{
  "permissions": {
    "allow": [...],
    "ask": [...],
    "deny": [...]
  }
}
```

**Per-Project** (`.claude/settings.local.json`):
```json
{
  "permissions": {
    "allow": [
      "Bash(npm run dev:*)",
      "Bash(npm run test:*)"
    ]
  }
}
```

---

## Troubleshooting

### MCP Server Not Found

**Issue**: Agent tries to use MCP tool but it's not available

**Solution**:
```bash
# Check enabled servers
cat ~/.claude/settings.json | grep enabledMcpjsonServers

# Ensure server is in list
# If not, add it:
"enabledMcpjsonServers": [
  "serena-global",
  "playwright",
  ...
]
```

### Tmux Session Already Exists

**Issue**: `/tmux-workspace` says session already exists

**Solution**:
```bash
# Option 1: Attach to existing
tmux attach -t <session-name>

# Option 2: Kill and recreate
tmux kill-session -t <session-name>
/tmux-workspace <session-name>
```

### Worktree Path Conflict

**Issue**: `/worktree-setup` says worktree already exists

**Solution**:
```bash
# List existing worktrees
git worktree list

# Remove if no longer needed
git worktree remove ../<repo>-<feature>

# Or use different name
/worktree-setup feature-v2
```

### Agent Not Following Conventions

**Issue**: Agent not using conventional commit messages

**Solution**:
Agent prompts have been updated. If issue persists:
1. Remind agent: "Please follow conventional commit format"
2. Check agent file has commit conventions section
3. Reference: `~/.claude/conventions/commit-messages.md`

---

## Future Enhancements

### Planned Features

- **project-context.json**: Shared agent knowledge across sessions
- **Agent learning hooks**: Auto-update CLAUDE.md after every agent task
- **Cost tracking**: Token usage estimation before workflows
- **Agent dashboard**: Real-time progress monitoring in tmux
- **Auto conflict resolution**: AI-powered merge conflict handling
- **Dependency graph visualization**: See task dependencies
- **A/B variant generation**: Parallel implementation of different approaches

### Integration Opportunities

- **Linear**: Full bidirectional sync with tickets
- **Slack**: Agent notifications in team channels
- **1Password**: Secure credential access for deployments
- **Datadog/NewRelic**: Observability integration
- **Sentry**: Error tracking integration

---

## Best Practices

### For You (The Architect)

1. **Start Small**: Use `/ship-feature` on small features first
2. **Review Agent Learnings**: Run `/codebase-sync` weekly
3. **Provide Feedback**: When agents escalate, give clear direction
4. **Trust but Verify**: Agents are autonomous, but review PRs
5. **Iterate**: Refine agent prompts based on what works

### For Agents (Automated)

Agents already configured to:
1. Read CLAUDE.md before starting any task
2. Use serena-mcp for code exploration
3. Follow conventional commit messages
4. Commit early and often
5. Update CLAUDE.md after completing tasks
6. Escalate ambiguous requirements

---

## Maintenance

### Weekly

```bash
# Consolidate agent learnings
/codebase-sync

# Review and push to yadm
yadm status
yadm commit -m "docs: weekly CLAUDE.md consolidation"
yadm push
```

### Monthly

```bash
# Full documentation sync
/codebase-sync --full

# Review MCP server versions
# Check for agent prompt updates
# Update templates if needed
```

### After Template Changes

```bash
# Apply to all projects
/codebase-sync --template ~/Projects/**
```

---

## Ubuntu 24.04 GNOME Setup

### Overview

This yadm configuration includes full support for Ubuntu 24.04 GNOME desktop environments with:
- **Ghostty Terminal**: Modern, fast terminal with built-in Nerd Font support
- **JetBrains Mono Nerd Font**: Installed automatically via bootstrap
- **GNOME Settings**: Tracked via dconf for consistent desktop configuration
- **GTK Theming**: Dark theme with Yaru theme by default
- **oh-my-posh**: Consistent shell prompt across macOS and Linux

### Deployment to New Ubuntu Machine

```bash
# 1. Install yadm (if not already installed)
sudo apt install yadm

# 2. Clone your dotfiles
yadm clone git@github.com:magnusmccune/yadm_dotfiles.git

# 3. Run bootstrap (this will install everything)
yadm bootstrap

# 4. Decrypt secrets
yadm decrypt

# 5. Reload shell
exec zsh

# 6. Verify installations
ghostty --version
oh-my-posh --version
claude --version
```

### Post-Bootstrap Steps

**1. Verify Ghostty Installation**:
```bash
ghostty --version
ghostty +list-themes  # See available themes
```

**2. Set Ghostty as Default Terminal** (optional):
```bash
# GNOME default terminal
gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'

# Or use GNOME Settings UI:
# Settings > Default Applications > Terminal
```

**3. Test Font Rendering**:
```bash
fc-list | grep JetBrains
# Should show JetBrainsMono Nerd Font variants
```

Launch Ghostty and verify Nerd Font icons render correctly.

**4. Customize GNOME Settings**:

After personalizing your GNOME desktop (keybindings, extensions, themes), export your settings:

```bash
~/.local/bin/export-gnome-settings
yadm add ~/.config/dconf/user.conf
yadm commit -m "feat: update GNOME settings"
yadm push
```

**5. Install GNOME Extensions** (manual):

Visit https://extensions.gnome.org/ and install via browser extension.

Recommended extensions:
- **Dash to Dock**: Better dock functionality
- **AppIndicator Support**: Tray icon support
- **Clipboard Indicator**: Clipboard history
- **Caffeine**: Prevent screen lock
- **Sound Input & Output Device Chooser**: Quick audio switching

### Configuration Files

**Ghostty**: [.config/ghostty/config](~/.config/ghostty/config)
- Theme: catppuccin-mocha
- Font: JetBrainsMono Nerd Font Mono
- Shell integration enabled (SSH + sudo)

**GNOME**: [.config/dconf/user.conf](~/.config/dconf/user.conf)
- Dark theme (Yaru-dark)
- Workspace keybindings (Super+1-4)
- Favorite apps configured

**GTK**: [.config/gtk-4.0/settings.ini](~/.config/gtk-4.0/settings.ini)
- Consistent theming for GTK4 apps

**Fonts**: [.config/fontconfig/fonts.conf](~/.config/fontconfig/fonts.conf)
- Monospace default: JetBrainsMono Nerd Font
- Optimized rendering hints

### Troubleshooting

**Ghostty SSH Issues**

If remote SSH connections fail with:
```
Error opening terminal: xterm-ghostty
```

The `shell-integration-features = ssh-terminfo` setting should handle this automatically by copying terminfo to remote systems on first connection.

If it doesn't work, manually copy terminfo:
```bash
infocmp -x xterm-ghostty | ssh REMOTE_HOST -- tic -x -
```

Or add to `~/.ssh/config`:
```
Host *
    SetEnv TERM=xterm-256color
```

**Font Icons Not Showing**

Ghostty has built-in Nerd Font symbol support, so icons should work even without Nerd Fonts installed. If you're seeing boxes instead of icons:

1. Verify font installation:
   ```bash
   fc-list | grep -i nerd
   fc-cache -fv  # Rebuild font cache
   ```

2. Check Ghostty config:
   ```bash
   grep font-family ~/.config/ghostty/config
   # Should show: JetBrainsMono Nerd Font Mono
   ```

3. Restart Ghostty

**GNOME Settings Not Applied**

If GNOME settings from dconf don't apply after bootstrap:

1. Check if dconf is installed:
   ```bash
   which dconf
   ```

2. Manually load settings:
   ```bash
   dconf load / < ~/.config/dconf/user.conf
   ```

3. Log out and back in

**Homebrew Cask Warning**

You may see a warning about `cask "claude-code"` not working on Linux in the Brewfile. This is expected - Claude Code is installed separately on Linux via apt/snap/appimage, not through Homebrew casks. The line is ignored harmlessly.

### Ubuntu-Specific Notes

**Packages Installed via Bootstrap**:
- build-essential, curl, git, wget, unzip
- **zsh** (shell with oh-my-posh configuration)
- libgtk-4-dev, libadwaita-1-dev (for Ghostty)
- fontconfig, fonts-powerline
- gnome-shell-extensions, gnome-tweaks
- chrome-gnome-shell (for browser extension support)

**Shell Configuration**:
- Bootstrap automatically installs zsh and sets it as default shell
- Change takes effect on next login/reboot
- To use zsh immediately after bootstrap: `exec zsh`

**Ghostty Installation**:
- Installed via community .deb from mkasberg/ghostty-ubuntu
- Auto-updates not configured (check for updates manually)
- Alternative: Use snap (`snap install ghostty`)

**oh-my-posh**:
- Installed via Homebrew (in `.Brewfile##os.Linux`)
- Theme: `.m3.omp.json` (already tracked)
- Configured in `.zshrc##template`

### Maintaining Your Setup

**Weekly**:
```bash
# Update GNOME settings if you changed anything
~/.local/bin/export-gnome-settings
yadm status
yadm commit -m "feat: update GNOME settings"
yadm push
```

**Monthly**:
```bash
# Update Homebrew packages
brew update && brew upgrade

# Update Ghostty
# Check https://github.com/mkasberg/ghostty-ubuntu/releases
# Download and install latest .deb

# Update system packages
sudo apt update && sudo apt upgrade
```

---

## Resources

- **Conventional Commits**: https://www.conventionalcommits.org/
- **Serena MCP**: https://github.com/oraios/serena
- **Playwright MCP**: https://github.com/executeautomation/playwright-mcp-server
- **tmux Guide**: https://github.com/tmux/tmux/wiki
- **Git Worktrees**: https://git-scm.com/docs/git-worktree

---

## Support

**Questions or Issues**:
1. Check this README
2. Review agent documentation in `~/.claude/agents/`
3. Check command documentation in `~/.claude/commands/`
4. Review conventions in `~/.claude/conventions/`

**Contributing**:
This is your personal Claude Code setup. Customize freely:
- Modify agent prompts for your workflow
- Add new commands in `.claude/commands/`
- Create custom conventions
- Update the CLAUDE.md template

---

**Built**: 2025-01-08
**System Version**: 1.0.0
**Claude Code**: Latest
**All changes committed to yadm**: ✅
