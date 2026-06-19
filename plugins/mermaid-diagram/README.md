# Mermaid Diagram Plugin

Create stable, accurate, and beautiful Mermaid diagrams with automated validation and styling.

## Features

- **Theme System**: Built-in light/dark themes (github-light, tokyo-night, etc.)
- **Macaron Colors**: Soft, elegant color palette for diagrams
- **Auto Validation**: Verify syntax before output
- **Layout Optimization**: Self-assessment and improvement cycle

## Requirements

- **MCP Server**: [mcp-mermaid](https://github.com/hustcc/mcp-mermaid)
- **MimoCode**: Latest version with skill support

## Quick Start

1. Install the MCP server (see `mcp-config.json`)
2. Copy `SKILL.md` to your skills directory
3. Use the skill in your workflow

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
