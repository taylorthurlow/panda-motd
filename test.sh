#!/bin/sh

set -e

rm -f *.gem
gem build panda-motd.gemspec
scp panda-motd*.gem taylor@home.thurlow.io:~/temp/pandamotd.gem
ssh -t taylor@home.thurlow.io "cd ~/temp && \
                               sudo gem uninstall -x panda-motd && \
                               sudo gem install ./*.gem && \
                               echo '---------------------' && \
                               sudo panda-motd /home/taylor/.config/panda-motd.yaml && \
                               echo '---------------------'"
