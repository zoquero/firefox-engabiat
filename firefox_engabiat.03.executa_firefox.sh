#!/usr/bin/bash
#
# Script per a executar el contenidor amb el firefox engabiat
# agalindo@ub.edu 20251129
#

set -o pipefail

# Imatge creada amb Buildah
FIREFOX_IMAGE="localhost/firefox-engabiat:latest"
USERNAME_USUARI_NO_PRIVILEGIAT=convidat
UID_USUARI_NO_PRIVILEGIAT=$(id -u $USERNAME_USUARI_NO_PRIVILEGIAT)
GROUPNAME_USUARI_NO_PRIVILEGIAT=$(groups $USERNAME_USUARI_NO_PRIVILEGIAT | cut -d: -f2 | awk '{print $1}')
LLAR_USUARI_NO_PRIVILEGIAT=$(getent passwd $USERNAME_USUARI_NO_PRIVILEGIAT | awk -F: '{print $6}')

if [ $? -ne 0 -o -z "$LLAR_USUARI_NO_PRIVILEGIAT" -o ! -d "$LLAR_USUARI_NO_PRIVILEGIAT" ]; then
  echo "No s'ha pogut esbrinar la llar de $USERNAME_USUARI_NO_PRIVILEGIAT o no existeix";
  exit 1;
fi

if [ -z "$GROUPNAME_USUARI_NO_PRIVILEGIAT" ]; then
  echo "No s'ha pogut esbrinar el grup de $USERNAME_USUARI_NO_PRIVILEGIAT";
  exit 1;
fi

# Carpeta pel firefox engabiat al host
HOST_DATA_DIR="$LLAR_USUARI_NO_PRIVILEGIAT/firefox_engabiat.dades"
# Carpeta llar de l'usuari dins del contenidor
CONTAINER_ROOT_DIR="/$USERNAME_USUARI_NO_PRIVILEGIAT"

UID_ACTUAL=$(id --user)
if [ "$UID_ACTUAL" != "$UID_USUARI_NO_PRIVILEGIAT" ]; then
  echo "Aquest script NOMÉS el pot executar $USERNAME_USUARI_NO_PRIVILEGIAT"
  exit 1
fi

# Concedim permís de visualització al sistema X de l'usuari local.
xhost +local:$(id -un) > /dev/null

echo "Iniciant Firefox aïllat amb Podman..."

# L'opció --userns=keep-id assegura que l'usuari dins del contenidor (root)
# tingui el mateix UID/GID que l'usuari de l'host (visitant), permetent l'escriptura.

# Executem el contenidor:
podman run --rm \
    --name firefox_engabiat \
    --userns=keep-id \
    -e DISPLAY=$DISPLAY \
    -e HOME=$CONTAINER_ROOT_DIR \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$HOST_DATA_DIR:$CONTAINER_ROOT_DIR" \
    $FIREFOX_IMAGE \
    /usr/bin/firefox-esr

echo "Firefox ha finalitzat."
