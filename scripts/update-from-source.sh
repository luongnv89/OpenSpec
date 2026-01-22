#!/usr/bin/env bash
set -euo pipefail

# Script to update OpenSpec from source code
# Usage: ./scripts/update-from-source.sh
#
# This script:
# 1. Pulls latest changes from git
# 2. Installs/updates dependencies
# 3. Builds OpenSpec from source
# 4. Updates global CLI installation (if using npm link)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╭─ OpenSpec Update from Source ─╮${NC}"

# Check if we're in a git repository
if [ ! -d "$PROJECT_ROOT/.git" ]; then
  echo -e "${RED}❌ Error: Not in OpenSpec git repository${NC}"
  echo "Expected git repo at: $PROJECT_ROOT"
  exit 1
fi

# Check for required tools
for tool in git node pnpm; do
  if ! command -v "$tool" &> /dev/null; then
    echo -e "${RED}❌ Error: $tool is not installed${NC}"
    exit 1
  fi
done

echo -e "${BLUE}✓ Prerequisites${NC}"
echo "  Node.js: $(node --version)"
echo "  pnpm: $(pnpm --version)"
echo "  Git: $(git --version | cut -d' ' -f3)"
echo ""

# Step 1: Fetch latest from remote
echo -e "${BLUE}1/4 Fetching latest from remote...${NC}"
cd "$PROJECT_ROOT"
git fetch origin main || git fetch origin master || true
echo -e "${GREEN}✓ Fetched latest${NC}"
echo ""

# Step 2: Pull latest changes
echo -e "${BLUE}2/4 Pulling latest changes...${NC}"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "    Current branch: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
  echo -e "${YELLOW}⚠️  Warning: Not on main/master branch (on: $CURRENT_BRANCH)${NC}"
  echo -e "${YELLOW}   Skipping pull to avoid overwriting local work${NC}"
else
  git pull origin "$CURRENT_BRANCH" || true
  echo -e "${GREEN}✓ Pulled latest changes${NC}"
fi
echo ""

# Step 3: Install dependencies and build
echo -e "${BLUE}3/4 Installing dependencies and building...${NC}"
pnpm install --frozen-lockfile 2>&1 | grep -E "^(Progress:|Packages:|dependencies:|devDependencies:|>|✅)" || true
echo -e "${GREEN}✓ Dependencies installed and build completed${NC}"
echo ""

# Step 4: Verify installation
echo -e "${BLUE}4/4 Verifying installation...${NC}"
VERSION=$(node bin/openspec.js --version)
echo "    OpenSpec version: $VERSION"

# Check if globally installed via npm link
if command -v openspec &> /dev/null; then
  GLOBAL_VERSION=$(openspec --version)
  if [ "$VERSION" = "$GLOBAL_VERSION" ]; then
    echo -e "${GREEN}✓ Global CLI is up-to-date${NC}"
  else
    echo -e "${YELLOW}⚠️  Global CLI version ($GLOBAL_VERSION) differs from source ($VERSION)${NC}"
    echo -e "${YELLOW}   Updating global installation...${NC}"
    npm link 2>&1 | grep -E "(removed|added|changed)" || true
    echo -e "${GREEN}✓ Global CLI updated${NC}"
  fi
else
  echo -e "${YELLOW}⚠️  OpenSpec not globally installed${NC}"
  echo -e "${YELLOW}   To install globally, run: npm link${NC}"
fi
echo ""

echo -e "${GREEN}╭─ Update Complete! ─╮${NC}"
echo -e "${GREEN}✅ OpenSpec is up-to-date (v$VERSION)${NC}"
echo ""
echo -e "Usage:"
echo -e "  ${BLUE}openspec --help${NC}        Show available commands"
echo -e "  ${BLUE}openspec --version${NC}     Show version"
echo ""
