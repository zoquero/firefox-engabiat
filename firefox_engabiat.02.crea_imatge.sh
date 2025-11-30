#!/usr/bin/bash
#
# Script que construeix el contenidor pel firefox engabiat
# agalindo@ub.edu 20251129
#

NOM_IMATGE=firefox-engabiat:latest

# Nota: Utlitzem Debian com a imatge base, doncs Ubuntu utilitza snapd
# per a executar firefox i sembla incompatible amb rootless podman.
IMATGE_BASE=debian:bookworm-slim
UID_USUARI_NO_PRIVILEGIAT=1002
USERNAME_USUARI_NO_PRIVILEGIAT=convidat

UID_ACTUAL=$(id --user)
if [ "$UID_ACTUAL" != "$UID_USUARI_NO_PRIVILEGIAT" ]; then
  echo "Aquest script NOMÉS el pot executar $USERNAME_USUARI_NO_PRIVILEGIAT"
  exit 1
fi

# 1. Inicia un nou contenidor basat en Debian
BUILD_CONTAINER=$(buildah from $IMATGE_BASE)

# 2. Configura la TZ, l'idioma i instal·la els paquets
buildah run $BUILD_CONTAINER -- bash -c " \
  # Fixa la zona horària i desactiva la interactivitat
  export DEBIAN_FRONTEND=noninteractive; \
  export TZ='Europe/Madrid'; \

  apt update && \

  # Paquets de sistema, Firefox i locale
  apt install -y tzdata locales wget xauth libdbus-1-3 libnss3 libasound2 libglib2.0-0 libcanberra-gtk-module dbus-x11 firefox-esr firefox-esr-l10n-ca && \

  # Zona horària
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive --force tzdata && \

  # Locales en català
  sed -i 's/^# *ca_ES.UTF-8/ca_ES.UTF-8/' /etc/locale.gen && \
  locale-gen ca_ES.UTF-8 && \
  update-locale LANG=ca_ES.UTF-8 LANGUAGE=ca:es LC_ALL=ca_ES.UTF-8 && \

  # Política per forçar català a Firefox (opcional)
  mkdir -p /usr/lib/firefox-esr/distribution && \
  cat > /usr/lib/firefox-esr/distribution/policies.json <<'EOF'
{
  \"policies\": {
    \"RequestedLocales\": [\"ca\"],
    \"AppLocale\": \"ca\"
  }
}
EOF

  # Comprovació final del binari (utilitza firefox-esr a Debian)
  which /usr/bin/firefox-esr || { echo 'ERROR: Binari de Firefox no trobat.' >&2; exit 1; } && \

  rm -rf /var/lib/apt/lists/*"

buildah config \
  --env LANG=ca_ES.UTF-8 \
  --env LANGUAGE=ca:es \
  --env LC_ALL=ca_ES.UTF-8 \
  $BUILD_CONTAINER

# 3. Defineix la configuració de l'inici amb la RUTA COMPLETA (Shell Form)
# ATENCIÓ: El binari a Debian és 'firefox-esr'
buildah config --cmd "/usr/bin/firefox-esr" $BUILD_CONTAINER

# 4. Guarda la imatge, sobreescrivint l'antiga
buildah commit $BUILD_CONTAINER $NOM_IMATGE

# 5. Neteja
buildah rm $BUILD_CONTAINER
