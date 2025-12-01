#!/usr/bin/bash
#
# Script per a executar el contenidor del firefox engabiat en mode depuració
# agalindo@ub.edu 20251129
#

USERNAME_USUARI_NO_PRIVILEGIAT=convidat
FIREFOX_IMAGE="localhost/firefox-engabiat:latest"

if [ "$USERNAME" != "$USERNAME_USUARI_NO_PRIVILEGIAT" ]; then
  echo "Aquest script NOMÉS el pot executar $USERNAME_USUARI_NO_PRIVILEGIAT"
  exit 1
fi

# podman run --rm -it --name depuracio_firefox --userns=keep-id "$FIREFOX_IMAGE" /bin/bash
# podman exec -it firefox_secure /bin/bash
podman exec -it firefox_engabiat /bin/bash

