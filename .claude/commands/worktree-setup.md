-----
description: Set up git worktrees for parallel development across multiple feature branches. Creates isolated working directories with independent node_modules.
argument-hint: "[feature-name-1] [feature-name-2] ..."

## Mission

Create one or more git worktrees to enable parallel development workflows. Each worktree is an independent checkout of the repository at a different branch, allowing multiple agents or developers to work simultaneously without conflicts.

## When to Use

- Working on multiple features concurrently
- Running parallel agent workflows (e.g., one implements, one reviews)
- Testing changes across different branches
- Coordinating multi-agent development with tmux

## Command Behavior

### Input Parsing

The command accepts 1-5 feature names as arguments:
```bash
/worktree-setup dark-mode api-refactor
```

If no arguments provided, prompt user for feature names interactively.

### Worktree Creation Pattern

For each feature name, create:
1. **Branch**: Create new branch from current HEAD (or main/master)
2. **Worktree Directory**: `../[repo-name]-[feature-name]`
3. **Initial Setup**: Run `npm install` (or equivalent) in each worktree
4. **Validation**: Verify worktree is functional

### Example Output

```
Current repo: <repo-name> (on branch: main)
Creating worktrees for parallel development...

✅ Worktree 1: dark-mode
   Branch: feature/dark-mode (created from main)
   Location: ../<repo-name>-dark-mode
   Dependencies: Installed (npm install completed)

✅ Worktree 2: api-refactor
   Branch: feature/api-refactor (created from main)
   Location: ../<repo-name>-api-refactor
   Dependencies: Installed (npm install completed)

📋 Worktree Summary:
   Total: 2 worktrees created
   Main repo: /Users/user/Projects/<repo-name>

To use worktrees:
   cd ../<repo-name>-dark-mode && npm run dev

To view all worktrees:
   git worktree list

To remove a worktree:
   git worktree remove ../<repo-name>-dark-mode
```

## Implementation Steps

1. **Detect Repository Context**
   ```bash
   repo_root=$(git rev-parse --show-toplevel)
   repo_name=$(basename "$repo_root")
   current_branch=$(git rev-parse --abbrev-ref HEAD)
   ```

2. **Parse Arguments**
   - Validate feature names (no spaces, valid git branch name characters)
   - Default base branch: current branch (or main/master if on detached HEAD)

3. **For Each Feature**:
   ```bash
   feature_name="$1"
   branch_name="feature/$feature_name"
   worktree_path="../${repo_name}-${feature_name}"

   # Create branch if it doesn't exist
   git show-ref --verify --quiet "refs/heads/$branch_name" || \
     git branch "$branch_name"

   # Create worktree
   git worktree add "$worktree_path" "$branch_name"

   # Setup dependencies
   cd "$worktree_path"
   if [ -f "package.json" ]; then
     npm install
   elif [ -f "Cargo.toml" ]; then
     cargo build
   elif [ -f "requirements.txt" ]; then
     pip install -r requirements.txt
   fi
   cd "$repo_root"
   ```

4. **Summary Output**
   - List all created worktrees
   - Show commands to use them
   - Provide cleanup instructions

5. **Update CLAUDE.md**
   Append to project CLAUDE.md:
   ```markdown
   ## Git Worktrees (Updated: YYYY-MM-DD)

   Active worktrees for parallel development:
   - `../[repo]-[feature-1]` - [Branch: feature/name-1]
   - `../[repo]-[feature-2]` - [Branch: feature/name-2]

   Created by: /worktree-setup command

   Usage:
   \`\`\`bash
   cd ../[repo]-[feature-1]
   npm run dev  # or test, build, etc.
   \`\`\`

   Cleanup:
   \`\`\`bash
   git worktree remove ../[repo]-[feature-1]
   git worktree prune
   \`\`\`
   ```

## Safety Checks

- ✅ Verify we're in a git repository
- ✅ Check for uncommitted changes (warn, don't block)
- ✅ Validate worktree path doesn't already exist
- ✅ Confirm enough disk space for dependencies
- ❌ Don't create worktree for currently checked-out branch

## Error Handling

**Already exists**:
```
❌ Error: Worktree ../<repo-name>-dark-mode already exists

   Options:
   1. Remove existing: git worktree remove ../<repo-name>-dark-mode
   2. Use different name: /worktree-setup dark-mode-v2
```

**No git repository**:
```
❌ Error: Not in a git repository

   Run this command from within a git-managed project.
```

**Disk space low**:
```
⚠️ Warning: Low disk space detected (<5GB free)

   Each worktree will install dependencies (~500MB per copy).
   Continue anyway? [y/N]
```

## Integration with /tmux-workspace

This command is often used as a prerequisite for `/tmux-workspace`, which creates a tmux session with panes for each worktree. Suggest running `/tmux-workspace` after setup if multiple worktrees created.

## Cleanup Command (Optional)

Consider creating a companion command `/worktree-cleanup` that:
- Lists all worktrees
- Prompts user to select which to remove
- Cleans up branches if fully merged
- Updates CLAUDE.md

-----
