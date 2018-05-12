[![Gem Version](https://badge.fury.io/rb/panda-motd.svg)](https://badge.fury.io/rb/panda-motd)
[![Build Status](https://travis-ci.com/taylorthurlow/panda-motd.svg?branch=develop)](https://travis-ci.com/taylorthurlow/panda-motd)
[![Code Climate Maintainability](https://img.shields.io/codeclimate/maintainability/taylorthurlow/panda-motd.svg)](https://codeclimate.com/github/taylorthurlow/panda-motd)
[![Code Climate Test Coverage](https://img.shields.io/codeclimate/coverage/taylorthurlow/panda-motd.svg)](https://codeclimate.com/github/taylorthurlow/panda-motd)

`panda-motd` is a utility for generating a more useful [MOTD](https://en.wikipedia.org/wiki/Motd_(Unix)).

### Disclaimer

`panda-motd` is under heavy development and while the release versions 'should' work, there's a real chance that things break. Understand that you might have issues. If you run into any, please open an issue, provided nobody has already created one for your particular problem.

### Getting started

#### Prerequisites
* Ruby >= 2.2
* Some flavor of Linux

#### Installing
To install the latest 'stable' release of `panda-motd`:

~~~bash
gem install panda-motd
~~~

At this point, you can run `sudo panda-motd` from anywhere (running with `sudo` is important), which will generate a configuration file located at `~/.config/panda-motd.yaml`. This file contains a description of each component of the MOTD and how to enable/disable/configure each one. Components are printed in your MOTD in the same order that they are defined in this configuration file.

Actually getting the output of the gem to become your MOTD is going to depend on your Linux distribution. Currently, it is only tested and working on **Ubuntu 16.04 LTS**:
* Go to the `/etc/update-motd.d` folder and inspect its contents. The MOTD is formed by running each of these scripts in numerical order (really alphabetically, but the convection is to start each script with two numbers), as root. The factory MOTD is generated using these scripts.
* If you desire to completely replace all of these scripts with `panda-motd`, it would be wise to make a copy of the `update-motd.d` folder, and then remove all of the factory scripts.
* Create a new file in `update-motd.d` and call it `00-pandamotd`, (or really, whatever you want). Remember, the numbers at the beginning of the filename are what determine the order of execution if you have any other scripts in the folder. In this file, use a text editor to write the contents as follows:

~~~bash
#!/bin/sh

panda-motd
~~~

* Make the new file you created executable, by doing:

~~~bash
sudo chmod +x /etc/update-motd.d/00-pandamotd
~~~

* Finally, run `sudo update-motd`. This will rebuild your MOTD, and will display the MOTD exactly as it will be when you log in. Log in and out to test the MOTD.

**Note:** Instructions for other distributions will become available over time. If you are successful in modifying your MOTD on a distribution which has no instructions yet, please open an issue so we can get the process documented. I will likely be starting a Wiki section for this purpose.

### Contributing
Due to the fact that this project is very new, things are changing very rapidly. Things are now in a state where I am semi-comfortable with people submitting pull requests. Please open an issue regarding any changes you wish to make before starting to work on anything. Additionally, I don't have much experience in the open-source world, so please forgive me as I familiarize myself with the contribution process. This is very much a learning process for me at the moment.

I am always open to providing assistance, so if you need to ask any questions please don't hesitate to do so, whether it be how to approach solving a problem or questions regarding how I might prefer something be implemented.

#### Running tests
I use `rspec` for testing. If submitting a pull request, always include tests if possible. Please adhere to the testing style in the pre-existing tests, particularly when testing a new component.

### Made Possible By
I'd like to use this section to thank the developers and contributors of the gems that make this gem possible.

* [artii](https://github.com/miketierney/artii): Generate cool ASCII text art
* [colorize](https://github.com/fazibear/colorize): Easily color terminal text
* [ruby-units](https://github.com/olbrich/ruby-units): A comprehensive unit conversion library
* [sysinfo](https://github.com/delano/sysinfo/): An easy, cross-platform way to get system information
