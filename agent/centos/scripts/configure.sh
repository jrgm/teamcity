#!/usr/bin/env sh

set -e 
set -x

dbus-uuidgen --ensure

pip install supervisor

useradd xvfb
useradd teamcity

set -o errexit # exit on first command with non-zero status

function install_firefox {
  local FX_VERSION=$1
  local SUBDIR=$2
  local MD5SUM=$3

  local FX_SITE=https://download-installer.cdn.mozilla.net/pub/firefox/releases
  local FX_IMAGE=${FX_SITE}/${FX_VERSION}/linux-x86_64/en-US/firefox-${FX_VERSION}.tar.bz2
    
  wget --no-verbose -O /tmp/firefox-${FX_VERSION}.tar.bz2 "${FX_IMAGE}"
  echo "${MD5SUM}  /tmp/firefox-${FX_VERSION}.tar.bz2" > MD5SUM
  md5sum -c MD5SUM

  su - teamcity -c "mkdir -p /home/teamcity/firefox-channels/${SUBDIR}/en-US"
  su - teamcity -c "tar xjf /tmp/firefox-${FX_VERSION}.tar.bz2 -C /home/teamcity/firefox-channels/${SUBDIR}/en-US"
  /home/teamcity/firefox-channels/${SUBDIR}/en-US/firefox/firefox-bin --version
}

install_firefox 18.0.2    fx18        29903172f6fd788f04dbeb27b9193fe6
install_firefox 52.4.0esr latest-esr  815dd7a014aa8587f8cf1b084dc3d448
install_firefox 53.0.2    latest      e5c86d6ce90356848244c839722d4892
install_firefox 57.0b4    latest-beta dd739d95e4128ff747d70c3372b0a02a
