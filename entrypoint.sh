#!/bin/bash

if [ -z "$NBPORT" ]; then
  NBPORT=8888
fi
if [ -n "$GIT_BRANCH" ]; then
  echo "PULL from $GIT_BRANCH"
  git pull -ff origin $GIT_BRANCH;
fi
make clean
sage setup.py install
case $1 in
    test)
      echo "Docker container running Sage doctests for the hilbertmodgroup package."
      sage -t src
      ;;
    tox)
      echo "Docker container running tox with $TOX_ARGS"
      sage -python -m tox src -e $TOX_ARGS
      ;;
    examples)
      echo "Docker container with Jupyter Notebook interface to run example notebooks."
      echo "NOTE: The Jupyter Notebook server is only accessible using the URL from outside the container."
      sage -n jupyter --no-browser --ip='0.0.0.0' --port=$NBPORT\
                            --notebook-dir=examples\
                            --NotebookApp.custom_display_url=http://127.0.0.1:$NBPORT\
                            --NotebookApp.use_redirect_file=False\
                            --NotebookApp.browser=x-www-browser
      ;;
    run)
      sage
      ;;
    shell)
      /bin/bash
      ;;
    *)
      echo "Unknown command $1. Exiting..."
      ;;
esac
