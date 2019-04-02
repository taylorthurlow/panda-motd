FROM ruby:2.6.0

LABEL "com.github.actions.name"="Run Tests"
LABEL "com.github.actions.description"="Run all RSpec tests"
LABEL "com.github.actions.icon"="check-circle"
LABEL "com.github.actions.color"="red"

LABEL "repository"="https://github.com/taylorthurlow/panda-motd"
LABEL "homepage"="https://github.com/taylorthurlow/panda-motd"
LABEL "maintainer"="Taylor Thurlow <taylorthurlow8@gmail.com>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
