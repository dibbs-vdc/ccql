# Ops

## On Gitlab

### Setup variables

DEPLOY_KEY - contents of the private server key for ssh and run through base64
PRODUCTION_ENV - use ops/env.example as a template and run through base64
SSH_CONFIG - use ops/sshconfig as a template and run through base64

### Add the public key from the server as a deploy key

## On the Rutgers Staging Service

### install git

`yum install -y git`

### clone the git repo

`git clone git@gitlab.com:notch8/rutgers-vdc.git`

### install-docker.sh

`cd ~/rutgers-vdc/ops && ./install-docker.sh`

Check docker / compose are installed:
```
docker version
docker-compose
```

## Run the deploy pipeline on Gitlab
