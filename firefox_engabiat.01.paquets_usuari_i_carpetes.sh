#!/usr/bin/bash
#
# Script que instal·la paquets, crea l'usuari i les carpetes pel firefox engabiat
# agalindo@ub.edu 20251129
#

if [ "$(id -u)" -ne 0 ]; then
  echo "Aquest script s'ha d'executar com a root."
  exit 1
fi

echo "Instal·lant paquets:"
apt-get install buildah podman
if [ $? -ne 0 ]; then
  echo "No s'han pogut instal·lar els paquets";
  exit 1;
fi

echo "Creant usuari i grup:"
USERNAME_USUARI_NO_PRIVILEGIAT=convidat
GROUPNAME_USUARI_NO_PRIVILEGIAT=$USERNAME_USUARI_NO_PRIVILEGIAT

groupadd $GROUPNAME_USUARI_NO_PRIVILEGIAT
if [ $? -ne 0 ]; then
  echo "No s'ha pogut crear el grup $GROUPNAME_USUARI_NO_PRIVILEGIAT";
  exit 1;
fi

useradd -g $GROUPNAME_USUARI_NO_PRIVILEGIAT -s $(which bash) -m $GROUPNAME_USUARI_NO_PRIVILEGIAT
if [ $? -ne 0 ]; then
  echo "No s'ha pogut crear l'usuari $USERNAME_USUARI_NO_PRIVILEGIAT";
  exit 1;
fi

echo "Estableix una contrasenya per l'usuari $USERNAME_USUARI_NO_PRIVILEGIAT"
passwd "$USERNAME_USUARI_NO_PRIVILEGIAT"

LLAR_USUARI_NO_PRIVILEGIAT=$(getent passwd $USERNAME_USUARI_NO_PRIVILEGIAT | awk -F: '{print $6}')
if [ $? -ne 0 -o -z "$LLAR_USUARI_NO_PRIVILEGIAT" -o ! -d "$LLAR_USUARI_NO_PRIVILEGIAT" ]; then
  echo "No s'ha pogut esbrinar la llar de $USERNAME_USUARI_NO_PRIVILEGIAT o no existeix";
  exit 1;
fi

echo "Creant carpetes:"
HOST_DATA_DIR=$LLAR_USUARI_NO_PRIVILEGIAT/podman_firefox_rootfs

mkdir -p $HOST_DATA_DIR           # Directori principal de dades
# mkdir -p $HOST_DATA_DIR/profile   # perfil de Firefox
# mkdir -p $HOST_DATA_DIR/downloads # Descàrregues

carpeta_dels_scripts=$(dirname "$0")
cp -R "$carpeta_dels_scripts" "$LLAR_USUARI_NO_PRIVILEGIAT"/

# Propietari per l'usuari no privilegiat per a que hi pugui escriure:
chown -R $USERNAME_USUARI_NO_PRIVILEGIAT:$GROUPNAME_USUARI_NO_PRIVILEGIAT $HOST_DATA_DIR
