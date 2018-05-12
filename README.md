[![Gem Version](https://badge.fury.io/rb/panda-motd.svg)](https://badge.fury.io/rb/panda-motd)
[![Build Status](https://travis-ci.com/taylorthurlow/panda-motd.svg?branch=develop)](https://travis-ci.com/taylorthurlow/panda-motd)
[![Code Climate Maintainability](https://img.shields.io/codeclimate/maintainability/taylorthurlow/panda-motd.svg)](https://codeclimate.com/github/taylorthurlow/panda-motd)
[![Code Climate Test Coverage](https://img.shields.io/codeclimate/coverage/taylorthurlow/panda-motd.svg)](https://codeclimate.com/github/taylorthurlow/panda-motd)

`panda-motd` is a utility for generating a more useful [MOTD](https://en.wikipedia.org/wiki/Motd_(Unix)).

### Getting started

#### Prerequisites
* Ruby >= 2.2
* Some flavor of Linux

#### Installing
To install the latest 'stable' release of `panda-motd`:

~~~bash
gem install panda-motd
~~~

To install the latest, even-more-broken-than-stable development version

~~~bash
git clone https://github.com/taylorthurlow/panda-motd.git
cd panda-motd
git checkout develop
gem build panda-motd.gemspec     # this will create a .gem file with the latest version number
gem install panda-motd-x.x.x.gem # where 'x.x.x' represents the version number of the build
~~~

Your mileage may vary with the development branch, particularly regarding your local ruby version, git, etc...

### Development
Due to the fact that this project is very new, things are changing so rapidly that I would recommend against submitting pull requests. I will change this notice as soon as I am comfortable with the state of the gem in the long-term.

#### Running tests
I use `rspec` for testing. If submitting a pull request, always include tests if possible. Please adhere to the testing style in the pre-existing tests, particularly when testing a new component.

### Made Possible By
I'd like to use this section to thank the developers and contributors of the gems that make this gem possible.

* [artii](https://github.com/miketierney/artii): Generate cool ASCII text art
* [colorize](https://github.com/fazibear/colorize): Easily color terminal text
* [ruby-units](https://github.com/olbrich/ruby-units): A comprehensive unit conversion library
* [sysinfo](https://github.com/delano/sysinfo/): An easy, cross-platform way to get system information
