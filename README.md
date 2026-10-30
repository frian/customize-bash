# customize-bash

A small, modular Bash customization toolkit. It sets prompt colors by connection type (local blue, SSH green, root red), useful aliases, and optional machine-specific modules. Pure Bash, no `sudo` required.

## Install (v2)

```bash
git clone https://github.com/frian/customize-bash.git
cd customize-bash
./install.sh --dry-run  # preview what would change
./install.sh            # activate the default profile
```

Open a **new Bash session** to load your changes. You can clone into any directory, including one whose name contains spaces. Keep the clone at that path while using the configuration; `.bashrc` sources `init.sh` **directly from the clone**, without copying code to your home directory.

The installer only manages a marked block in `~/.bashrc`. It backs up the original file before changing it and does not automatically reload the current shell. Re-running it is safe and does not duplicate the block.

To install a named profile:

```bash
./install.sh --profile myprofile
```

Create `profiles/myprofile/` and provide `bash_customize_profile.sh` (you may start with a copy of `profiles/default/bash_customize_profile.sh.dist`). Additional `.sh` files in that profile directory are loaded after the standard aliases. The default profile works directly from the provided `.dist` file, without copying it.

## Customize without touching Git-tracked files

Place your machine-specific profile settings in:

```text
~/.config/customize-bash/profile.sh
```

This optional file is sourced **after** the selected profile's `bash_customize_profile.sh` (or `.dist`), so you can override individual settings without copying the whole profile. The directory can also contain modules:

```text
~/.config/customize-bash/modules/git.sh
~/.config/customize-bash/modules/symfony.sh
```

For example, start with `mkdir -p ~/.config/customize-bash/modules`, then copy selected files from `samples/` to that directory. Local modules are loaded after the core and profile modules. If `$XDG_CONFIG_HOME` is set, that directory is used instead of `~/.config`.

## Optional smart prompt

The original prompt colors remain unchanged. Two additions are **off by default**, so
remote shells do not incur extra Git lookups unless you opt in. Put the following
settings into your personal `~/.config/customize-bash/profile.sh`:

```bash
CUSTOMIZE_BASH_PROMPT_GIT=1     # show [branch] in Git repositories
CUSTOMIZE_BASH_PROMPT_STATUS=1  # show [!N] if the previous command failed
```

For example: `user@host:~/project [!1] [main] # customize-bash

A small, modular Bash customization toolkit. It sets prompt colors by connection type (local blue, SSH green, root red), useful aliases, and optional machine-specific modules. Pure Bash, no `sudo` required.

## Install (v2)

```bash
git clone https://github.com/frian/customize-bash.git
cd customize-bash
./install.sh --dry-run  # preview what would change
./install.sh            # activate the default profile
```

Open a **new Bash session** to load your changes. You can clone into any directory, including one whose name contains spaces. Keep the clone at that path while using the configuration; `.bashrc` sources `init.sh` **directly from the clone**, without copying code to your home directory.

The installer only manages a marked block in `~/.bashrc`. It backs up the original file before changing it and does not automatically reload the current shell. Re-running it is safe and does not duplicate the block.

To install a named profile:

```bash
./install.sh --profile myprofile
```

Create `profiles/myprofile/` and provide `bash_customize_profile.sh` (you may start with a copy of `profiles/default/bash_customize_profile.sh.dist`). Additional `.sh` files in that profile directory are loaded after the standard aliases. The default profile works directly from the provided `.dist` file, without copying it.

## Customize without touching Git-tracked files

Place your machine-specific profile settings in:

```text
~/.config/customize-bash/profile.sh
```

This optional file overrides the selected profile's `bash_customize_profile.sh` (or `.dist`). The directory can also contain modules:

```text
~/.config/customize-bash/modules/git.sh
~/.config/customize-bash/modules/symfony.sh
```

For example, start with `mkdir -p ~/.config/customize-bash/modules`, then copy selected files from `samples/` to that directory. Local modules are loaded after the core and profile modules. If `$XDG_CONFIG_HOME` is set, that directory is used instead of `~/.config`.

.

The Git command runs only when drawing an interactive prompt and only if enabled.
No `PROMPT_COMMAND` or DEBUG trap is installed. If you already use `PROMPT_COMMAND`,
Bash may replace the previous command status before PS1 expands; the optional exit
status indicator then reflects that modified status. Command-duration timing is
intentionally excluded because obtaining it accurately would require intrusive hooks.

## Check your setup

Run a read-only diagnostic to inspect the current clone, startup hook, selected profile,
and available user modules:

```bash
./doctor.sh
# or
./customize-bash doctor
```

The command reports missing files, a broken/mismatched `.bashrc` hook, an invalid
installed profile, and optional legacy leftovers. It never executes `.bashrc`,
loads modules, deletes files, or changes shell configuration. A nonzero exit code
means that at least one required check failed.

For convenience, `./customize-bash install` and `./customize-bash uninstall` are
also available, with the same options as the standalone scripts. No PATH change
is required.

## Update

From the same clone:

```bash
git pull --ff-only
```

Start a new Bash session. There is **no need to reinstall** when only the code changes: the shell loads files directly from the clone. Review upstream changes before pulling, since shell startup executes the repository's scripts.

If the clone has moved, run `./install.sh` again from its new location to update the path in `.bashrc`.

## Uninstall

```bash
./uninstall.sh --dry-run
./uninstall.sh
```

The uninstaller removes only the v2-managed `.bashrc` block and backs up `.bashrc` beforehand. It does **not** remove your clone, `~/.config/customize-bash`, old `~/.customize-bash` files, or any other user configuration. Open a new shell afterward.

## Migrating from v1

`./install.sh` removes the **exact** old startup line created by the original installer (if present) and replaces it with the v2-managed block. It does **not** delete `~/.customize-bash` or change other lines in `.bashrc`.

If you customized the old generated `~/.customize-bash/.bash_customize_profile`, you can preserve those changes in the new user configuration:

```bash
mkdir -p ~/.config/customize-bash
cp ~/.customize-bash/.bash_customize_profile ~/.config/customize-bash/profile.sh
```

Review that old file before copying. If you had customized files in `profiles/`, they continue to work. The original `customize-bash.sh` now acts as a non-destructive compatibility wrapper for the old `source customize-bash.sh [profile]` invocation; prefer `./install.sh` for new installations.

The installer targets **Bash** and `~/.bashrc` only. It does not try to configure Zsh or POSIX login shells.

## Tests

```bash
bash tests/test_install.sh
```

The tests use an isolated temporary home and a disposable copy of the repository; they do not edit your real `.bashrc`.

## License

MIT — see [LICENSE](LICENSE).
