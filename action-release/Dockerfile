FROM ruby:2.6.0

LABEL "com.github.actions.name"="Release"
LABEL "com.github.actions.description"="Release new version on RubyGems"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/taylorthurlow/panda-motd"
LABEL "homepage"="https://github.com/taylorthurlow/panda-motd"
LABEL "maintainer"="Taylor Thurlow <taylorthurlow8@gmail.com>"

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["patch"]
