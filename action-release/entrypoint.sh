#!/bin/bash -l

set -eu

apt update -qq
apt install -y jq

VERSION_FROM_TAG=$(cat $GITHUB_EVENT_PATH | jq .release.tag_name)
VERSION_FROM_TAG=$(echo $VERSION_FROM_TAG | sed 's/^"//' | sed 's/"$//')
VERSION_FROM_TAG=$(echo $VERSION_FROM_TAG | sed 's/^v//')

bundle install

bundle exec gem bump -v $VERSION_FROM_TAG --pretend
bundle exec gem tag --pretend
bundle exec gem release --pretend
