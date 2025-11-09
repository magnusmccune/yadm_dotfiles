# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Last Updated**: [YYYY-MM-DD]
**Project**: [Project Name]
**Tech Stack**: [e.g., React + TypeScript + Vite + Tailwind]

---

## Project Context

**Purpose**: [One-sentence description of what this project does]

**Target Users**: [Who uses this? Internal tool, public app, library, etc.]

**Development Status**: [Active development | Maintenance mode | Prototype | Production]

**Key Constraints**:
- [Any important constraints: legacy support, performance requirements, etc.]

---

## Quick Start

### Prerequisites
```bash
# List required tools and versions
node >= 18.0.0
npm >= 9.0.0
```

### Development Commands

```bash
npm install              # Install dependencies
npm run dev              # Start dev server (http://localhost:XXXX)
npm run build            # Production build
npm run build:dev        # Development build
npm run lint             # Run linter
npm run type-check       # TypeScript type checking
```

### Testing

```bash
npm run test             # Run all tests
npm run test:unit        # Unit tests only
npm run test:e2e         # E2E tests (Playwright)
npm run test:e2e:ui      # Playwright UI mode
npm run test:watch       # Watch mode
```

**Test Framework**: [Jest | Vitest | Playwright | etc.]
**Test Location**: [tests/ | **/*.test.ts | etc.]
**Coverage Target**: [X%]

---

## Architecture Overview

### Application Structure

```
project-root/
├── src/
│   ├── components/      # UI components
│   ├── pages/          # Route-level pages
│   ├── lib/            # Utilities and helpers
│   ├── api/            # API client functions
│   ├── hooks/          # Custom React hooks
│   └── types/          # TypeScript types
├── tests/              # E2E tests
├── public/             # Static assets
└── .claude/            # Claude Code configuration
```

### Key Architectural Patterns

1. **[Pattern Name]**: [Description]
   - **When to use**: [Scenario]
   - **Example**: [Code reference or file path]

2. **[Another Pattern]**: [Description]
   - **When to use**: [Scenario]
   - **Example**: [Code reference or file path]

### Data Flow

```
User Action (Component)
     ↓
API Call (React Query / SWR / etc.)
     ↓
Backend Endpoint
     ↓
Data Store Update
     ↓
UI Re-render
```

---

## Development Patterns

### File Naming Conventions

- **Components**: PascalCase (`Button.tsx`, `UserProfile.tsx`)
- **Utilities**: camelCase (`formatDate.ts`, `apiClient.ts`)
- **Tests**: `*.test.ts` or `*.spec.ts`
- **Styles**: `*.module.css` or co-located with components

### Import Path Aliases

```typescript
import { Button } from '@/components/Button';
import { formatDate } from '@/lib/utils';
```

**Alias Configuration**: [Location of path alias config, e.g., tsconfig.json, vite.config.ts]

### State Management

**Approach**: [Redux | Zustand | React Context | TanStack Query | Jotai | etc.]

**When to use**:
- **Server State**: [Tool for async data]
- **UI State**: [Tool for local state]
- **Global State**: [Tool for app-wide state]

**Example**:
```typescript
// Example of state management pattern
[Code snippet]
```

### Styling Approach

**Framework**: [Tailwind | CSS Modules | Styled Components | etc.]

**Pattern**:
- Use utility classes for common patterns
- Extract to components for complex styles
- Theme tokens: [Location, e.g., tailwind.config.ts]

**Example**:
```tsx
// Styling pattern example
[Code snippet]
```

---

## Common Patterns

### API Integration

**Client**: [fetch | axios | custom wrapper]
**Base URL**: [Development URL]
**Authentication**: [How auth is handled]

**Pattern**:
```typescript
// Example API call
[Code snippet showing the pattern]
```

**Error Handling**:
```typescript
// How errors are handled
[Code snippet]
```

### Form Handling

**Library**: [React Hook Form | Formik | Native | etc.]
**Validation**: [Zod | Yup | etc.]

**Pattern**:
```typescript
// Form pattern example
[Code snippet]
```

### Routing

**Router**: [React Router | Next.js | TanStack Router | etc.]
**Pattern**: [File-based | Config-based]

**Route Structure**:
- `/` → Landing page
- `/feature` → Feature page
- [Other routes]

---

## Testing Strategy

### Unit Testing

**What to test**:
- ✅ Business logic functions
- ✅ Custom hooks
- ✅ Utility functions
- ❌ Simple presentational components (test via E2E instead)

**Pattern**:
```typescript
// Unit test pattern
[Example test]
```

### E2E Testing

**Framework**: [Playwright | Cypress | etc.]
**Location**: [tests/ directory]

**What to test**:
- ✅ Critical user journeys
- ✅ Authentication flows
- ✅ Form submissions
- ✅ Error states and recovery

**Pattern**:
```typescript
// E2E test pattern with page object
[Example test]
```

**Known Flaky Tests**:
- [Test name]: [Why it's flaky and how to fix]

---

## Git Workflow

### Branch Naming

```
feature/[name]     # New features
fix/[name]         # Bug fixes
refactor/[name]    # Code refactoring
docs/[name]        # Documentation updates
```

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add user authentication
fix: resolve memory leak in data fetcher
docs: update README with new setup steps
test: add E2E tests for checkout flow
```

See also: `~/.claude/conventions/commit-messages.md`

### Worktrees (Multi-Agent Development)

This project supports git worktrees for parallel development:

```bash
# Create worktree for new feature
git worktree add ../[project]-feature-name feature-name

# List all worktrees
git worktree list

# Remove completed worktree
git worktree remove ../[project]-feature-name
```

**Active Worktrees**: [List current worktrees if any]

---

## Deployment

### Environments

- **Development**: [URL or description]
- **Staging**: [URL or description]
- **Production**: [URL or description]

### Deployment Process

[How code gets deployed - CI/CD pipeline, manual steps, etc.]

**Trigger**: [What triggers deployment]
**Pipeline**: [GitHub Actions | GitLab CI | etc.]
**Duration**: [Typical deployment time]

### Rollback Procedure

```bash
# How to rollback if deployment fails
[Commands or steps]
```

---

## Gotchas & Debugging

### Common Issues

**Issue**: [Description of problem]
**Cause**: [Why it happens]
**Solution**: [How to fix]

**Issue**: [Another common problem]
**Cause**: [Why it happens]
**Solution**: [How to fix]

### Debugging Tips

- [Tip 1]
- [Tip 2]
- [Tip 3]

### Environment-Specific Issues

**macOS**: [Any macOS-specific issues]
**Windows**: [Any Windows-specific issues]
**Linux**: [Any Linux-specific issues]

---

## Dependencies

### Core Dependencies

- `[package]@[version]` - [Purpose]
- `[package]@[version]` - [Purpose]

### Dev Dependencies

- `[package]@[version]` - [Purpose]
- `[package]@[version]` - [Purpose]

### Updating Dependencies

```bash
# Check for updates
npm outdated

# Update specific package
npm update [package-name]

# Update all (carefully)
npm update
```

**Policy**: [When to update - monthly, quarterly, on security alerts, etc.]

---

## Agent Learnings

> **Note**: This section is automatically updated by Claude Code agents after completing tasks.
> Entries are timestamped and attributed to specific agents.

### 2025-01-XX: [Feature/Change Name]

**Agent**: [agent-name]
**Context**: [What task was being performed]

**Key Findings**:
- [Discovery 1]
- [Discovery 2]

**Architectural Insights**:
- [Pattern discovered or confirmed]
- [Why it matters]

**Implementation Notes**:
- File locations: `path/to/file.ts:123`
- Gotchas discovered: [Any unexpected behavior]

**Recommendations**:
- [Suggestion for future work]

---

### 2025-01-XX: [Another Feature/Change]

**Agent**: [agent-name]
**Context**: [What task was being performed]

[Same structure as above]

---

## Performance Considerations

### Bundle Size

- **Target**: [Target bundle size]
- **Current**: [Current bundle size]
- **Monitor**: [How to check bundle size]

### Runtime Performance

- **Page Load**: [Target time]
- **Interaction**: [Target time for interactions]
- **Monitoring**: [How performance is monitored]

### Optimization Techniques

- [Technique 1 used in this project]
- [Technique 2 used in this project]

---

## Security

### Authentication

[How authentication works]

### Authorization

[How authorization/permissions work]

### Secrets Management

- **Environment Variables**: [How env vars are managed]
- **API Keys**: [How API keys are stored - NEVER commit to repo]
- **Sensitive Data**: [How sensitive data is handled]

**⚠️ Never Commit**:
- `.env.local`
- `secrets.json`
- API keys or credentials

---

## Project History

### Major Milestones

- **YYYY-MM**: [Milestone 1]
- **YYYY-MM**: [Milestone 2]

### Technical Decisions

**Decision**: [Chose X over Y]
**Reason**: [Why this choice was made]
**Trade-offs**: [What we gave up]
**Date**: YYYY-MM-DD

---

## Resources

### Documentation

- [Internal Docs Link]
- [API Documentation]
- [Design System / Component Library]

### External References

- [Relevant external docs, tutorials, etc.]

---

## Contributing

### For Human Developers

[Guidelines for team members contributing to the project]

### For Claude Code Agents

Agents should:
1. Read this file before starting any task
2. Use serena-mcp to explore codebase before making changes
3. Follow established patterns documented here
4. Commit early and often with conventional commit messages
5. Update the "Agent Learnings" section after completing tasks
6. Escalate ambiguous requirements or architectural decisions to user

---

**Maintained by**: [Team Name / Person]
**Questions**: [How to ask questions - Slack channel, email, etc.]
