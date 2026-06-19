#!/bin/bash

# Mermaid Diagram Plugin - Installer
# Auto-detects installed AI coding tools and configures MCP server

set -e

PLUGIN_DIR="$(cd "$(dirname "$0")" && pwd)"
MCP_CONFIG="$PLUGIN_DIR/mcp-config.json"
SKILL_FILE="$PLUGIN_DIR/SKILL.md"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if tool is installed
check_tool() {
    local tool=$1
    case $tool in
        cursor)
            command -v cursor &>/dev/null || [ -d "/Applications/Cursor.app" ] || [ -d "$HOME/.cursor" ]
            ;;
        kiminext)
            command -v kimi &>/dev/null || [ -d "$HOME/.kimi" ]
            ;;
        mimocode)
            command -v mimocode &>/dev/null || [ -d "$HOME/.mimocode" ]
            ;;
        claude)
            [ -d "/Applications/Claude.app" ] || [ -d "$HOME/Library/Application Support/Claude" ]
            ;;
        cline)
            command -v code &>/dev/null && code --list-extensions 2>/dev/null | grep -q "cline"
            ;;
        continue)
            command -v code &>/dev/null && code --list-extensions 2>/dev/null | grep -q "continue"
            ;;
        *)
            false
            ;;
    esac
}

# Merge MCP config into existing file
merge_mcp_config() {
    local target_file=$1
    local tool_name=$2
    
    if [ ! -f "$target_file" ]; then
        mkdir -p "$(dirname "$target_file")"
        cp "$MCP_CONFIG" "$target_file"
        success "$tool_name: Created $target_file"
        return
    fi
    
    # Check if mermaid server already exists
    if grep -q '"mermaid"' "$target_file" 2>/dev/null; then
        warn "$tool_name: mermaid server already configured in $target_file"
        return
    fi
    
    # Merge using node if available, otherwise warn
    if command -v node &>/dev/null; then
        node -e "
            const fs = require('fs');
            const existing = JSON.parse(fs.readFileSync('$target_file', 'utf8'));
            const newConfig = JSON.parse(fs.readFileSync('$MCP_CONFIG', 'utf8'));
            
            if (!existing.mcpServers) existing.mcpServers = {};
            existing.mcpServers.mermaid = newConfig.mcpServers.mermaid;
            
            fs.writeFileSync('$target_file', JSON.stringify(existing, null, 2));
        "
        success "$tool_name: Merged mermaid server into $target_file"
    else
        warn "$tool_name: Cannot auto-merge (node not found). Please add manually:"
        echo "  Add to $target_file:"
        cat "$MCP_CONFIG"
    fi
}

# Copy skill file
copy_skill() {
    local target_dir=$1
    local tool_name=$2
    
    if [ -z "$target_dir" ]; then
        return
    fi
    
    # Expand ~ to home directory
    target_dir="${target_dir/#\~/$HOME}"
    
    mkdir -p "$target_dir/mermaid-diagram"
    cp "$SKILL_FILE" "$target_dir/mermaid-diagram/SKILL.md"
    success "$tool_name: Copied SKILL.md to $target_dir/mermaid-diagram/"
}

# Install for a specific tool
install_for_tool() {
    local tool=$1
    local config_path=$2
    local skill_path=$3
    
    info "Configuring $tool..."
    
    # Expand ~ to home directory
    config_path="${config_path/#\~/$HOME}"
    
    merge_mcp_config "$config_path" "$tool"
    copy_skill "$skill_path" "$tool"
}

# Main
echo ""
echo "=========================================="
echo "  Mermaid Diagram Plugin Installer"
echo "=========================================="
echo ""

# Check dependencies
if ! command -v npx &>/dev/null; then
    error "npx not found. Please install Node.js first."
    exit 1
fi

# Detect and configure tools
tools_found=0

if check_tool cursor; then
    install_for_tool "cursor" ".cursor/mcp.json" ".cursor/rules"
    ((tools_found++))
fi

if check_tool kiminext; then
    install_for_tool "kimi" "~/.kimi/mcp.json" "~/.kimi/skills"
    ((tools_found++))
fi

if check_tool mimocode; then
    install_for_tool "mimocode" "~/.mimocode/mcp.json" "~/.mimocode/skills"
    ((tools_found++))
fi

if check_tool claude; then
    install_for_tool "claude-desktop" "~/Library/Application Support/Claude/claude_desktop_config.json" ""
    ((tools_found++))
fi

if check_tool cline; then
    install_for_tool "cline" ".vscode/mcp.json" ".cline/rules"
    ((tools_found++))
fi

if check_tool continue; then
    install_for_tool "continue" "~/.continue/config.json" ""
    ((tools_found++))
fi

echo ""
if [ $tools_found -eq 0 ]; then
    warn "No supported AI coding tools detected."
    echo ""
    echo "Manual installation:"
    echo "  1. Copy mcp-config.json content to your tool's MCP config"
    echo "  2. Copy SKILL.md to your skills directory"
    echo ""
    echo "Supported tools: cursor, kimi, mimocode, claude-desktop, cline, continue"
else
    success "Configured $tools_found tool(s)!"
fi

echo ""
echo "=========================================="
echo "  Next Steps"
echo "=========================================="
echo ""
echo "  1. Restart your AI coding tool"
echo "  2. The mermaid MCP server will auto-install on first use"
echo "  3. Ask your AI to create a diagram!"
echo ""
echo "  Example: '创建一个用户登录流程图'"
echo ""
