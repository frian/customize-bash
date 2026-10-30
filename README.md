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

This optional file overrides the selected profile's `bash_customize_profile.sh` (or `.dist`). The directory can also contain modules:

```text
~/.config/customize-bash/modules/git.sh
~/.config/customize-bash/modules/symfony.sh
```

For example, start with `mkdir -p ~/.config/customize-bash/modules`, then copy selected files from `samples/` to that directory. Local modules are loaded after the core and profile modules. If `$XDG_CONFIG_HOME` is set, that directory is used instead of `~/.config`.

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
