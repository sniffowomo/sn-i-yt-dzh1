# MiniMax Agent Guide

This guide explains how to use agentic coding capabilities to automate multi-step tasks.

## What Are Agentic Capabilities?

Agentic capabilities allow the AI to execute complex, multi-step tasks autonomously without requiring confirmation at each step. The AI can:
- Break down complex requests into smaller tasks
- Execute actions sequentially or in parallel
- Adapt to findings and adjust its approach
- Complete tasks end-to-end with minimal intervention

## Available Agents

| Agent | Purpose |
|-------|---------|
| `general` | General-purpose agent for research and execution |
| `explore` | Fast agent for exploring codebases, finding files, understanding patterns |

## Basic Usage Pattern

```bash
Task tool with:
- subagent_type: Which agent to use
- description: Short 3-5 word summary
- prompt: Detailed instructions for the task
- session_id: (optional) Continue from previous session
```

## Simple Example: Find All API Endpoints

**Goal**: Find all API endpoint definitions in a codebase and list them.

### Step 1: Launch the Agent

```json
{
  "subagent_type": "explore",
  "description": "Find API endpoints",
  "prompt": "Find all API endpoint definitions in this codebase. Look for:\n- Route definitions (e.g., @app.route, router.get, /api/...)\n- Controller files with HTTP methods\n- URL patterns in configuration files\n\nReturn a list of all endpoints found with their file paths and line numbers."
}
```

### Step 2: Agent Execution

The agent will:
1. Search for common endpoint patterns
2. Explore relevant directories
3. Report findings with locations

### Step 3: Get Results

The agent returns a summary like:

```
Found 12 API endpoints:
- GET /api/users        src/controllers/users.py:15
- POST /api/users       src/controllers/users.py:22
- GET /api/users/:id    src/controllers/users.py:28
- PUT /api/products     src/controllers/products.py:8
...
```

## Example 2: Complete Refactoring Task

**Goal**: Rename a function across all files and update all references.

```json
{
  "subagent_type": "general",
  "description": "Rename function across codebase",
  "prompt": "Rename the function 'getUserData' to 'fetchUserData' across the entire codebase:\n1. Find all occurrences of 'getUserData'\n2. Update the function definition in src/userService.js\n3. Update all call sites in other files\n4. Verify no references are missed\n\nReturn a summary of changes made."
}
```

## Best Practices

1. **Be specific in prompts**: Clearly define the expected output format
2. **Set boundaries**: Mention which directories to include/exclude
3. **Specify output format**: Ask for structured results (lists, tables)
4. **Chain for complex tasks**: Break huge tasks into sequential agent calls
5. **Review results**: Always verify agent outputs, especially for destructive changes

## Advanced: Session Continuity

Use `session_id` to continue work across multiple prompts:

```json
// First call
{
  "subagent_type": "explore",
  "description": "Explore codebase structure",
  "prompt": "Explore the codebase structure and identify main components"
}

// Subsequent call
{
  "subagent_type": "general",
  "description": "Analyze components",
  "prompt": "Now analyze the components identified and suggest improvements",
  "session_id": "previous-session-id"
}
```

## Tips for Effective Agent Use

- **Start broad, then refine**: Begin with exploration, then focus on specific tasks
- **Parallelize independent searches**: Launch multiple agents for different concerns
- **Use the right agent**: `explore` for finding/understanding, `general` for execution
- **Provide context**: Include relevant file paths, patterns, or constraints
- **Ask for summaries**: Request concise outputs rather than raw data dumps

## Summary

Agentic capabilities transform you from a hands-on coder to a hands-off architect. Describe what you want, and the agent figures out how to get there.
