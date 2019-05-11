[![Gem Version](https://badge.fury.io/rb/panda-motd.svg)](https://badge.fury.io/rb/panda-motd)
[![Build Status](https://travis-ci.com/taylorthurlow/panda-motd.svg?branch=develop)](https://travis-ci.com/taylorthurlow/panda-motd)
[![Code Climate Maintainability](https://img.shields.io/codeclimate/maintainability/taylorthurlow/panda-motd.svg)](https://codeclimate.com/github/taylorthurlow/panda-motd)
[![Code Climate Test Coverage](https://img.shields.io/codeclimate/coverage/taylorthurlow/panda-motd.svg)](https://codeclimate.com/github/taylorthurlow/panda-motd)

<p align="center">
  <img src="https://user-images.githubusercontent.com/761640/39962315-e8bcc6ea-55ff-11e8-9ed1-380410b6102c.png" />
</p>

`panda-motd` is a utility for generating a more useful [MOTD](https://en.wikipedia.org/wiki/Motd_(Unix)).

### Disclaimer

`panda-motd` is under heavy development and while the release versions 'should' work, there's a real chance that things break. Understand that you might have issues. If you run into any, please open an issue, provided nobody has already created one for your particular problem.

### Getting started

#### Prerequisites
* Ruby >= 2.3
* Some flavor of Linux

#### Installing
To install the latest 'stable' release of `panda-motd`:

~~~bash
sudo gem install panda-motd
~~~

At this point, you can run `panda-motd ~/.config/panda-motd.yaml` (without `sudo`) from anywhere, which will generate a configuration file located at `~/.config/panda-motd.yaml`. This file contains a description of each component of the MOTD and how to enable/disable/configure each one. Components are printed in your MOTD in the same order that they are defined in this configuration file.

Actually getting the output of the gem to become your MOTD is going to depend on your Linux distribution. Please find your Linux distribution on [this wiki page](https://github.com/taylorthurlow/panda-motd/wiki/Configuring-Linux-to-use-panda-motd-as-the-MOTD) and follow the instructions.

### Contributing
Please open an issue regarding any changes you wish to make before starting to work on anything. I am always open to providing assistance, so if you need to ask any questions please don't hesitate to do so, whether it be how to approach solving a problem or questions regarding how I might prefer something be implemented.

This project uses [Rufo](https://github.com/ruby-formatter/rufo) to format its source code, and pull requests will not be accepted unless all code has been run through it.

#### Running tests
I use `rspec` for testing. If submitting a pull request, always include tests if possible. Please adhere to the testing style in the pre-existing tests, particularly when testing a new component.

### Made Possible By
I'd like to use this section to thank the developers and contributors of the gems that make this gem possible.

* [artii](https://github.com/miketierney/artii): Generate cool ASCII text art
* [colorize](https://github.com/fazibear/colorize): Easily color terminal text
* [ruby-units](https://github.com/olbrich/ruby-units): A comprehensive unit conversion library
* [sysinfo](https://github.com/delano/sysinfo/): An easy, cross-platform way to get system information

Many of the design cues and the original idea of a highly configurable MOTD are from [/u/LookAtMyKeyboard](https://www.reddit.com/user/LookAtMyKeyboard) on Reddit, from [this thread](https://www.reddit.com/r/unixporn/comments/8gwcti/motd_ubuntu_server_1804_lts_my_motd_scripts_for/) in particular.
