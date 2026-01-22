# OpenSpec Scripts

Utility scripts for OpenSpec maintenance and development.

## update-flake.sh

Updates `flake.nix` pnpm dependency hash automatically.

**When to use**: After updating dependencies (`pnpm install`, `pnpm update`).

**Usage**:
```bash
./scripts/update-flake.sh
```

**What it does**:
1. Reads version from `package.json` (dynamically used by `flake.nix`)
2. Automatically determines the correct pnpm dependency hash
3. Updates the hash in `flake.nix`
4. Verifies the build succeeds

**Example workflow**:
```bash
# After dependency updates
pnpm install
./scripts/update-flake.sh
git add flake.nix
git commit -m "chore: update flake.nix dependency hash"
```

## postinstall.js

Post-installation script that runs after package installation.

## update-from-source.sh

Pulls latest changes from git and rebuilds OpenSpec from source.

**When to use**: Regularly update your local OpenSpec installation with latest changes from the repository.

**Usage**:
```bash
./scripts/update-from-source.sh
```

**What it does**:
1. Validates prerequisites (git, node, pnpm)
2. Fetches latest changes from remote repository
3. Pulls changes from the main/master branch
4. Installs/updates dependencies with pnpm
5. Builds TypeScript to JavaScript
6. Verifies the build and global CLI installation
7. Updates global CLI if installed via `npm link`

**Features**:
- Safely skips pull if on a non-main branch to preserve local work
- Color-coded output for easy reading
- Validates that all prerequisites are available
- Checks and updates global CLI installation

**Typical workflow**:
```bash
# From anywhere in the OpenSpec directory
./scripts/update-from-source.sh

# Or use the convenience wrapper from anywhere
update-openspec
```

**Convenience wrapper**:
A wrapper script (`bin/update-openspec`) is provided to make updates easier from any location:

1. **Option A: Add to PATH**
```bash
# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
export PATH="/Users/montimage/buildspace/luongnv89/OpenSpec/bin:$PATH"

# Then use from anywhere:
update-openspec
```

2. **Option B: Set environment variable**
```bash
# Set where your OpenSpec is located
export OPENSPEC_ROOT="/Users/montimage/buildspace/luongnv89/OpenSpec"

# Then run from anywhere:
"$OPENSPEC_ROOT/bin/update-openspec"
```

3. **Option C: Create an alias**
```bash
# Add to your shell profile
alias update-openspec="/Users/montimage/buildspace/luongnv89/OpenSpec/bin/update-openspec"

# Then use from anywhere:
update-openspec
```

## pack-version-check.mjs

Validates package version consistency before publishing.
