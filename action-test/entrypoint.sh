#!/bin/sh -l

set -eu

bundle install
bundle exec rspec
