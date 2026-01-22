# OpenSpec Update Scripts Setup Guide

Two bash scripts have been created to make it easy to update OpenSpec from source.

## Scripts Created

1. **`scripts/update-from-source.sh`** - Main update script
2. **`bin/update-openspec`** - Convenience wrapper script

## Quick Start (Easiest Method)

### Method 1: Add to PATH (Recommended)

Add this line to your shell profile (`~/.bashrc`, `~/.zshrc`, `~/.fish/config.fish`, etc.):

```bash
# For bash/zsh (add to ~/.bashrc or ~/.zshrc)
export PATH="/Users/montimage/buildspace/luongnv89/OpenSpec/bin:$PATH"
```

Then reload your shell:
```bash
source ~/.bashrc  # or ~/.zshrc
```

Now you can run from anywhere:
```bash
update-openspec
```

### Method 2: Create an Alias

Add to your shell profile:
```bash
# For bash/zsh (add to ~/.bashrc or ~/.zshrc)
alias update-openspec="/Users/montimage/buildspace/luongnv89/OpenSpec/bin/update-openspec"
```

Then reload your shell and use:
```bash
update-openspec
```

### Method 3: Use Full Path

Run directly without setup:
```bash
/Users/montimage/buildspace/luongnv89/OpenSpec/scripts/update-from-source.sh
```

Or from within the OpenSpec directory:
```bash
cd /Users/montimage/buildspace/luongnv89/OpenSpec
./scripts/update-from-source.sh
```

## What These Scripts Do

Both scripts perform the following steps:

1. ✅ Verify prerequisites (git, Node.js, pnpm)
2. ✅ Fetch latest changes from GitHub
3. ✅ Pull the latest code from main branch
4. ✅ Install/update dependencies with pnpm
5. ✅ Build TypeSpec from TypeScript
6. ✅ Verify the build and CLI installation
7. ✅ Update global CLI if needed

## Usage Examples

### Update from anywhere (after setup):
```bash
update-openspec
```

### Update from project directory:
```bash
cd /Users/montimage/buildspace/luongnv89/OpenSpec
./scripts/update-from-source.sh
```

### Update using wrapper script:
```bash
/Users/montimage/buildspace/luongnv89/OpenSpec/bin/update-openspec
```

## Example Output

```
╭─ OpenSpec Update from Source ─╮
✓ Prerequisites
  Node.js: v25.3.0
  pnpm: 10.28.0
  Git: 2.52.0

1/4 Fetching latest from remote...
✓ Fetched latest

2/4 Pulling latest changes...
    Current branch: main
Already up to date.
✓ Pulled latest changes

3/4 Installing dependencies and building...
✓ Dependencies installed and build completed

4/4 Verifying installation...
    OpenSpec version: 0.23.0
✓ Global CLI is up-to-date

╭─ Update Complete! ─╮
✅ OpenSpec is up-to-date (v0.23.0)

Usage:
  openspec --help        Show available commands
  openspec --version     Show version
```

## Features

- **Error Handling**: Stops gracefully if any step fails
- **Smart Branch Detection**: Won't pull if you're on a feature branch
- **Color Output**: Easy-to-read colored status messages
- **Prerequisite Checks**: Validates that all required tools are available
- **CLI Auto-Update**: Automatically updates global CLI installation
- **Cross-Platform**: Works on macOS, Linux, and Unix-like systems

## Troubleshooting

### Script not found after adding to PATH
- Make sure you've reloaded your shell: `source ~/.bashrc` or `source ~/.zshrc`
- Verify the path is correct: `which update-openspec`

### Permission denied error
- Make sure the script is executable:
  ```bash
  chmod +x /Users/montimage/buildspace/luongnv89/OpenSpec/scripts/update-from-source.sh
  chmod +x /Users/montimage/buildspace/luongnv89/OpenSpec/bin/update-openspec
  ```

### "Could not find OpenSpec project root" error
- The wrapper script couldn't locate OpenSpec automatically
- Set the environment variable:
  ```bash
  export OPENSPEC_ROOT="/Users/montimage/buildspace/luongnv89/OpenSpec"
  ```

### pnpm/npm not found
- Install Node.js and pnpm:
  ```bash
  # Install pnpm
  npm install -g pnpm
  ```

## Scheduling Regular Updates

You can schedule the update script to run periodically using `cron`:

```bash
# Edit your crontab
crontab -e

# Add this line to run updates daily at 8 AM
0 8 * * * /Users/montimage/buildspace/luongnv89/OpenSpec/bin/update-openspec >> ~/.openspec_updates.log 2>&1
```

## Manual Update (Without Scripts)

If you prefer to update manually:

```bash
cd /Users/montimage/buildspace/luongnv89/OpenSpec
git fetch origin
git pull origin main
pnpm install
pnpm build
npm link  # If installed globally
```

## Need Help?

- View script details: `cat scripts/update-from-source.sh`
- View wrapper script: `cat bin/update-openspec`
- Check OpenSpec version: `openspec --version`
- See OpenSpec commands: `openspec --help`
