customize bash
==============

configurable and extendable bash customisation

## Usage

```
usage : source customize-bash.sh [ -f startup_file ] [ profile ]

  startup_file : .bash_profile, .bash_login, .profile, .bashrc (default)
```

## Setup


clone or download


### configure

copy files from samples or add your own files to the profiles/default folder ( files must have .sh extension )


create bash_customize_profile.sh

```bash
cp profiles/default/bash_customize_profile.sh.dist profiles/default/bash_customize_profile.sh
```

add your environment variables



install

```bash
. customize-bash.sh
```

## Create a profile

create a profile dir

```bash
mkdir profiles/newprofile
```
add a bash_customize_profile.sh file

add needed files

install

```bash
. customize-bash.sh newprofile
```

## Changelog

Check the [Changelog](CHANGELOG.md)

## License

[MIT](https://en.wikipedia.org/wiki/MIT_License)
