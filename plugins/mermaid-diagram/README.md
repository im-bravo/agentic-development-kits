# Mermaid Diagram Plugin

Create stable, accurate, and beautiful Mermaid diagrams with automated validation and styling.

## Features

- **Theme System**: Built-in light/dark themes (github-light, tokyo-night, etc.)
- **Macaron Colors**: Soft, elegant color palette for diagrams
- **Auto Validation**: Verify syntax before output
- **Layout Optimization**: Self-assessment and improvement cycle

## Requirements

- **Node.js**: v18+ (for npx)
- **MCP Server**: [mcp-mermaid](https://github.com/hustcc/mcp-mermaid) (auto-installed)

## Quick Start

### Auto Install (Recommended)

```bash
./install.sh
```

Auto-detects installed tools (Cursor, Kimi, MimoCode, Claude Desktop, Cline, Continue) and configures them.

### Manual Install

1. Add MCP config to your tool (see `mcp-config.json`)
2. Copy `SKILL.md` to your skills directory
3. Restart your tool

### Any MCP-Compatible Tool

Paste this into your tool's MCP config file:

```json
{
  "mcpServers": {
    "mermaid": {
      "command": "npx",
      "args": ["-y", "mcp-mermaid"],
      "env": {}
    }
  }
}
```

Config file locations:

| Tool | Config Path |
|------|-------------|
| Cursor | `.cursor/mcp.json` or `~/.cursor/mcp.json` |
| Kimi | `~/.kimi/mcp.json` |
| MimoCode | `~/.mimocode/mcp.json` |
| Claude Desktop | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Cline | `.vscode/mcp.json` or `~/.cline/mcp.json` |
| Continue | `~/.continue/config.json` |

## Usage Example

```
用户: 创建一个用户登录流程图
AI: [Loads mermaid-diagram skill, generates diagram with theme, validates, outputs]
```

## Supported Diagram Types

- Flowchart (TD/LR)
- Sequence Diagram
- Class Diagram
- State Diagram
- Gantt Chart
- Pie Chart

## Configuration

See `mcp-config.json` for MCP server setup.
