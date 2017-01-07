customize bash
==============

configurable and extendable bash customisation

- colored prompt
- colored man pages


Setup
-----

clone or download


#### configure

copy files from samples or add your own files to the personal folder ( files must start with a dot and have the .sh extension )

create .bash_customize.sh

```bash
cp .bash_customize.sh.dist .bash_customize.sh
```

uncomment the scripts from samples and add your own scripts

create .bash_customize_profile.sh

```bash
cp .bash_customize_profile.sh .bash_customize_profile.sh
```

add your environment variable



#### install

```bash
. bash_customize.sh
```

Core files
----------

| File | Description |
| --- | --- |
| customize-bash.sh | the installer script |
| core/.bash_customize.sh | main file, loads all other files |
| core/.bash_customize_colors.sh | colors definitions |
| core/.bash_customize_shell.sh | common shell aliases and env variables |
| core/.bash_customize_prompt_colors.sh | colored prompt |



Samples files
---------------------

some sample personal files.

personal files have to be placed in the personal dir
