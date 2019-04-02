#!/bin/sh -l

set -eu

bundle install

bundle exec gem bump -v $1 --pretend
bundle exec gem tag --pretend
bundle exec gem release --pretend
