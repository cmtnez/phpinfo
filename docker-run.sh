#!/bin/sh

git clone https://github.com/cmtnez/phpinfo
cd phpinfo
git checkout 2021-09-santander-cmr

# Esto construye la imagen
docker image build \
  --file ./Dockerfile \
  --no-cache \
  --tag local/phpinfo:test \
  ./

# Esto despliega la imagen
docker network create phpinfo
docker container run \
  --cpus '0.1' \
  --detach \
  --entrypoint /usr/bin/php \
  --env author=CarlosMartinez \
  --label app=phpinfo \
  --memory 100M \
  --name phpinfo \
  --network phpinfo \
  --publish 80:8080 \
  --read-only \
  --restart always \
  --user nobody \
  --volume ${PWD}/src/index.php:/app/index.php/:ro \
  --workdir /app/ \
  local/phpinfo:test \
  -f /src/index.php \
  -S 0.0.0.0:8080 \
  
