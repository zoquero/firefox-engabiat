#!/usr/bin/bash
#
# Script per a crear una drecera per a executar a Gnome el contenidor amb el firefox engabiat
# agalindo@ub.edu 20251129
#

set -o pipefail
USERNAME_USUARI_NO_PRIVILEGIAT=convidat
LLAR_USUARI_NO_PRIVILEGIAT=$(getent passwd $USERNAME_USUARI_NO_PRIVILEGIAT | awk -F: '{print $6}')
if [ $? -ne 0 -o -z "$LLAR_USUARI_NO_PRIVILEGIAT" -o ! -d "$LLAR_USUARI_NO_PRIVILEGIAT" ]; then
  echo "No s'ha pogut esbrinar la llar de $USERNAME_USUARI_NO_PRIVILEGIAT o no existeix";
  exit 1;
fi
SCRIPT_EXEC_FIREFOX_ENGABIAT="$LLAR_USUARI_NO_PRIVILEGIAT/firefox_engabiat/firefox_engabiat.03.executa_firefox.sh"

mkdir -p ~/.local/share/applications

cat > ~/.local/share/applications/firefox-segur.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox engabiat
Comment=Navegador Firefox aïllat amb Podman (Utilitza perfil persistent)
Exec=$SCRIPT_EXEC_FIREFOX_ENGABIAT
Icon=firefox
Terminal=true
Categories=Network;WebBrowser;
EOF
