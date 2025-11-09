-----
description: Synchronize and update project CLAUDE.md files across all projects. Consolidates agent learnings and ensures documentation stays current.
argument-hint: "[project-path] [--consolidate] [--template]"

## Mission

Keep project CLAUDE.md files up-to-date by:
1. Consolidating agent learnings from the "Agent Learnings" section
2. Updating stale information
3. Applying the latest template structure
4. Removing outdated content

## When to Use

- **Weekly**: Consolidate agent learnings from past week
- **After major changes**: Update architecture or patterns sections
- **New project setup**: Initialize CLAUDE.md from template
- **Template updates**: Apply new template structure to existing projects

## Command Modes

### Mode 1: Consolidate Agent Learnings (Default)

Review the "Agent Learnings" section and:
- Move important learnings to permanent sections
- Archive or remove time-specific entries
- Merge similar learnings
- Update timestamps

**Usage**:
```bash
/codebase-sync
```

**Process**:
1. documentation-specialist reads current CLAUDE.md
2. Identifies learnings in "Agent Learnings" section
3. Categorizes by importance:
   - **Critical**: Promote to main sections (Architecture, Patterns, etc.)
   - **Useful**: Keep in Agent Learnings with updated summary
   - **Outdated**: Archive or remove
4. Proposes changes to user for review
5. Updates CLAUDE.md

**Example Output**:
```
📚 Analyzing Agent Learnings in CLAUDE.md...

Found 12 entries in Agent Learnings section (oldest: 3 weeks ago)

Recommendations:
  ✅ Promote to "Common Patterns":
     - Dark mode implementation pattern (discovered 2025-01-15)
     - Form validation with Zod (discovered 2025-01-18)

  📝 Keep in Agent Learnings (recent & useful):
     - E2E test flakiness fixes (discovered 2025-01-22)
     - Performance optimization for data grid (discovered 2025-01-20)

  🗑️  Archive (outdated or resolved):
     - Workaround for old Vite bug (fixed in Vite 5.0)
     - Temporary API endpoint (deprecated)

Apply changes? [Y/n]
```

### Mode 2: Apply Template

Update existing CLAUDE.md to match latest template structure.

**Usage**:
```bash
/codebase-sync --template
```

**Process**:
1. Read current CLAUDE.md
2. Read template from `~/.claude/templates/CLAUDE.md`
3. Identify missing sections
4. Merge existing content into new template structure
5. Preserve all custom content
6. Show diff for review

**Example**:
```
📋 Applying latest CLAUDE.md template...

Current structure: 8 sections
Template structure: 14 sections

New sections to add:
  + Performance Considerations
  + Security
  + Project History

Sections to rename:
  "Development" → "Development Patterns"

Sections unchanged:
  ✓ Project Context
  ✓ Architecture Overview
  ✓ Testing Strategy

Preview changes? [Y/n]
```

### Mode 3: Full Sync

Combine consolidation + template update + freshness check.

**Usage**:
```bash
/codebase-sync --full
```

**Steps**:
1. Apply latest template structure
2. Consolidate agent learnings
3. Check for stale information (commands, URLs, versions)
4. Verify all code references still exist
5. Update "Last Updated" timestamp

### Mode 4: Initialize New Project

Create CLAUDE.md from template for a new project.

**Usage**:
```bash
/codebase-sync --init
```

**Process**:
1. Copy template to `.claude/CLAUDE.md`
2. Run code-archaeologist to discover project structure
3. Auto-fill template placeholders:
   - Project name from package.json or directory
   - Tech stack from dependencies
   - Commands from package.json scripts
   - File structure from actual directories
4. Leave TODOs for sections requiring human input

**Example**:
```
🆕 Initializing CLAUDE.md for new project...

Discovered:
  Project: my-app (from package.json)
  Stack: React 18.2, TypeScript 5.3, Vite 5.0
  Commands: dev, build, test, lint (from package.json)
  Structure: Standard React app (src/, tests/, public/)

Created: .claude/CLAUDE.md

TODO sections (need your input):
  - Project Context: Purpose and target users
  - Key Architectural Patterns
  - Deployment process
  - Common gotchas

Edit now or later? [Edit/Later]
```

## Agent Responsibilities

### documentation-specialist

Primary agent for this command. Tasks:
1. **Read & Analyze**: Parse current CLAUDE.md structure
2. **Categorize**: Sort agent learnings by importance
3. **Consolidate**: Merge similar entries, remove duplicates
4. **Update**: Apply template changes while preserving content
5. **Verify**: Check code references still exist
6. **Report**: Show clear diff of proposed changes

### code-archaeologist

Supporting role for --init and --full modes:
1. **Discover**: Explore project structure with serena-mcp
2. **Extract**: Pull metadata (project name, dependencies, commands)
3. **Verify**: Check that documented files/symbols still exist
4. **Report**: Provide findings to documentation-specialist

## Consolidation Heuristics

### When to Promote Learning to Main Section

Promote if:
- ✅ Referenced by 3+ agents in their work
- ✅ Solves a recurring problem
- ✅ Establishes a new pattern for the project
- ✅ Contains architectural insights

Keep in Agent Learnings if:
- 📝 Recent (< 1 week old)
- 📝 Specific to one feature
- 📝 Temporary workaround
- 📝 Requires more validation

### When to Archive/Remove

Remove if:
- 🗑️ Problem no longer exists (dependency updated)
- 🗑️ Feature was rolled back
- 🗑️ Outdated (> 1 month and not referenced)
- 🗑️ Redundant with other entries

## Verification Checks

### Stale Information Detection

Check for:
- **Version numbers**: Compare with package.json
- **URLs**: Verify links aren't 404
- **Code references**: Ensure file:line references still exist
- **Commands**: Verify npm scripts match package.json
- **Dependencies**: Check if deprecated packages removed

**Example**:
```
⚠️  Stale information detected:

1. React version: Documented as 18.0, actual: 18.2
   → Update to 18.2? [Y/n]

2. Dead link: https://old-docs.example.com/api
   → Remove or update? [Remove/Update/Skip]

3. Code reference: src/components/OldButton.tsx:45
   → File no longer exists
   → Remove reference? [Y/n]
```

## Multi-Project Sync

Sync across multiple projects in a workspace.

**Usage**:
```bash
/codebase-sync --all ~/Projects/**
```

**Process**:
1. Find all projects with `.claude/CLAUDE.md`
2. For each project:
   - Run consolidation
   - Apply template updates
   - Check for stale info
3. Generate summary report

**Report**:
```
📊 Multi-Project Sync Complete

Processed 5 projects:
  ✅ my-app: 3 learnings promoted, template updated
  ✅ api-server: 1 learning promoted, 2 stale links removed
  ✅ admin-dashboard: Template updated, no learnings
  ⚠️  legacy-project: No CLAUDE.md found (skip or init?)
  ✅ mobile-app: 5 learnings consolidated

Total changes:
  - Promoted: 9 learnings
  - Archived: 12 outdated entries
  - Updated: 5 template structures
  - Fixed: 8 stale references

Commit changes? [Y/n]
```

## Output Format

After sync, create a summary commit:

```bash
git add .claude/CLAUDE.md
git commit -m "docs: sync CLAUDE.md with agent learnings

Consolidated:
- Promoted dark mode pattern to Common Patterns
- Promoted Zod validation to Development Patterns
- Archived 3 outdated workarounds

Updated:
- Applied latest template structure
- Fixed 2 stale code references
- Updated dependency versions

Agent: documentation-specialist"
```

## Integration with Agents

All agents should:
1. **Check CLAUDE.md** before starting work (use serena-mcp to find it)
2. **Append learnings** to "Agent Learnings" section after completing tasks
3. **Reference existing patterns** documented in CLAUDE.md
4. **Suggest /codebase-sync** if Agent Learnings section has >10 entries

## Best Practices

### Frequency

- **After each agent task**: Agent appends to Agent Learnings (automatic)
- **Weekly**: Run /codebase-sync to consolidate (manual or automated)
- **Monthly**: Run /codebase-sync --full for deep sync (manual)
- **After template updates**: Run /codebase-sync --template on all projects

### Preservation

Always preserve:
- ✅ Custom project-specific content
- ✅ Team-contributed sections
- ✅ Manual documentation additions
- ✅ Historical context in Project History

Never auto-delete:
- ❌ Manually written sections
- ❌ Team decisions documented
- ❌ Critical gotchas (even if old)

### Review

Always show user:
- Diff before applying changes
- List of promoted learnings
- List of archived entries
- Verification issues found

---

**Related Commands**:
- `/ship-feature` - Agents auto-update CLAUDE.md after feature completion
- See also: `~/.claude/templates/CLAUDE.md` for latest template structure
