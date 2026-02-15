# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

<!-- antfarm:workflows -->
# Antfarm Workflows

Antfarm CLI (always use full path to avoid PATH issues):
`node ~/.openclaw/workspace/antfarm/dist/cli/cli.js`

Commands:
- Install: `node ~/.openclaw/workspace/antfarm/dist/cli/cli.js workflow install <name>`
- Run: `node ~/.openclaw/workspace/antfarm/dist/cli/cli.js workflow run <workflow-id> "<task>"`
- Status: `node ~/.openclaw/workspace/antfarm/dist/cli/cli.js workflow status "<task title>"`
- Logs: `node ~/.openclaw/workspace/antfarm/dist/cli/cli.js logs`

Workflows are self-advancing via per-agent cron jobs. No manual orchestration needed.

## DELEGATION RULE (CRITICAL)
- When a user asks for a new project/feature/app: DO NOT code it yourself. You are the orchestrator, not the developer.
- ALWAYS delegate to antfarm workflow: `node ~/.openclaw/workspace/antfarm/dist/cli/cli.js workflow run feature-dev "<task>"`
- Get next available port: `curl -s http://127.0.0.1:3080/api/projects/next-port`
- ALWAYS specify the repo directory explicitly in the task description:
  - Format: REPO: /home/setrox/<project-name>
  - The project name should be kebab-case (lowercase, hyphens)
- ALWAYS include the port in the task description: Frontend port: <port>
- After starting the workflow, monitor progress and report to the user
<!-- /antfarm:workflows -->

