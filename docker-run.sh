#!/bin/sh

# Esto hace...
git clone https://github.com/cmtnez/phpinfo
cd phpinfo
git checkout 2021-09-santander-cmr

# Esto hace...
docker image build \
  --file ./Dockerfile \
  --no-cache \
  --tag local/phpinfo:test \
  ./

# Esto hace...
docker network create phpinfo
docker container run \
  --detach \
  --name phpinfo \
  --network phpinfo \
  --read-only \
  --restart always \
  --user nobody \
  --volume ./src/index.php:/app/index.php/:ro \
  --workdir /app/ \
  local/phpinfo:test
  
