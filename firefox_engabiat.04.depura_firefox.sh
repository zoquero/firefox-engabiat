#!/usr/bin/bash
#
# Script per a executar el contenidor del firefox engabiat en mode depuració
# agalindo@ub.edu 20251129
#

USERNAME_USUARI_NO_PRIVILEGIAT=convidat

if [ "$USERNAME" != "$USERNAME_USUARI_NO_PRIVILEGIAT" ]; then
  echo "Aquest script NOMÉS el pot executar $USERNAME_USUARI_NO_PRIVILEGIAT"
  exit 1
fi

podman exec -it firefox_engabiat /bin/bash

