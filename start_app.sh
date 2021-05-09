#!/bin/bash -eu
if [ -v GOOGLE_APPLICATION_CREDENTIALS ]; then
  echo "GOOGLE_APPLICATION_CREDENTIALS: ${GOOGLE_APPLICATION_CREDENTIALS}"
  gcsfuse prototype-snowboarding-mountain-resort-game ./tmp/aaa
else
  echo "GOOGLE_APPLICATION_CREDENTIALS not defined"
  env
fi

bin/rails server --binding 0.0.0.0
