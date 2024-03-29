#!/bin/bash
#source activate pymaap
# Ensure $HOME exists when starting
if [ ! -d "${HOME}" ]; then
  mkdir -p "${HOME}"
fi
whoami
# Add current (arbitrary) user to /etc/passwd and /etc/group
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-user}:x:$(id -u):0:${USER_NAME:-user} user:${HOME}:/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-user}:x:$(id -u):" >> /etc/group
  fi
fi

VERSION=$(jupyter lab --version)
if [[ $VERSION > '2' ]] && [[ $VERSION < '3' ]]; then
    jupyter lab --ip=0.0.0.0 --port=3100 --allow-root --NotebookApp.token='' --NotebookApp.base_url=$PREVIEW_URL --no-browser --debug
elif [[ $VERSION > '3' ]] && [[ $VERSION < '4' ]]; then
    jupyter lab --ip=0.0.0.0 --port=3100 --allow-root --ContentsManager.allow_hidden=True --ServerApp.token='' --no-browser --debug --ServerApp.disable_check_xsrf=True --ResourceUseDisplay.mem_limit=$MEMORY --ResourceUseDisplay.mem_warning_threshold=0.2
else
    echo "Error! Jupyterlab version not supported."
    which python
    echo $PATH
    echo $@
    exec "$@"
fi

