# p4lo - Python for localops

Python 3.9.1 compiled for [Docker Hub most downloaded Linux distributions](https://hub.docker.com/search?q=&type=image&image_filter=store%2Cofficial&category=os). Includes [pip](https://pypi.org/project/pip/) and [Ansible](https://pypi.org/project/ansible/).

This is used to provide uniform, easy to install, Python support across several distros, and is used by another project of mine, [localops](https://github.com/gasrios/localops).

Unless you know me personally, or work with me, you should not trust that the tarballs contained in this project do what I say they do. For all you know, I may not even exist, and the tarballs are trojans someone created to install a rootkit.

Instead, install Python using script `build.sh` (after reviewing it and making sure it does no funny business), or clone this repo and rebuild the contents of directory `repository` using `build-all.sh`.

## build.sh

Identifies the distro it is running on, compiles Python and creates a matching tarball in directory "repository".

## build-all.sh

builds tarballs using the following Docker images:

- TODO: add images list

## Repository

List of tarballs containing Python 3.9.1 for several distros.
