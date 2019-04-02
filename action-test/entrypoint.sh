#!/bin/sh -l

set -eu

apt update -qq
apt install -y curl

bundle install

curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
chmod +x ./cc-test-reporter
./cc-test-reporter before-build

bundle exec rspec

./cc-test-reporter after-build --exit-code $? --coverage-input-type simplecov
