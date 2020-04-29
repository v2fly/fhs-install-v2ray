#!/bin/bash

# This Bash script to install the latest release of geoip.dat and geosite.dat:

# https://github.com/v2ray/geoip
# https://github.com/v2ray/domain-list-community

# Depends on cURL, please solve it yourself

# You may plan to execute this Bash script regularly:

# install -m 755 install-dat-release.sh /usr/local/bin/install-dat-release

# 0 0 * * * /usr/local/bin/install-dat-release > /dev/null 2>&1

V2RAY="/usr/local/lib/v2ray/"
DOWNLOAD_LINK_GEOIP="https://github.com/v2ray/geoip/releases/latest/download/geoip.dat"
DOWNLOAD_LINK_GEOSITE="https://github.com/v2ray/domain-list-community/releases/latest/download/dlc.dat"

download_geoip() {
    curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geoip.dat.new" "$DOWNLOAD_LINK_GEOIP"
    if [ "$?" -ne '0' ]; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geoip.dat.sha256sum.new" "$DOWNLOAD_LINK_GEOIP.sha256sum"
    if [ "$?" -ne '0' ]; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    SUM="$(sha256sum ${V2RAY}geoip.dat.new | sed 's/ .*//')"
    CHECKSUM="$(sed 's/ .*//' ${V2RAY}geoip.dat.sha256sum.new)"
    if [[ "$SUM" != "$CHECKSUM" ]]; then
        echo 'error: Check failed! Please check your network or try again.'
        exit 1
    fi
}

download_geosite() {
    curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geosite.dat.new" "$DOWNLOAD_LINK_GEOSITE"
    if [ "$?" -ne '0' ]; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geosite.dat.sha256sum.new" "$DOWNLOAD_LINK_GEOSITE.sha256sum"
    if [ "$?" -ne '0' ]; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    SUM="$(sha256sum ${V2RAY}geosite.dat.new | sed 's/ .*//')"
    CHECKSUM="$(sed 's/ .*//' ${V2RAY}geosite.dat.sha256sum.new)"
    if [[ "$SUM" != "$CHECKSUM" ]]; then
        echo 'error: Check failed! Please check your network or try again.'
        exit 1
    fi
}

rename_new() {
    for DAT in 'geoip' 'geosite'; do
        mv "${V2RAY}$DAT.dat.new" "${V2RAY}$DAT.dat"
        rm "${V2RAY}$DAT.dat.sha256sum.new"
    done
}

main() {
    download_geoip
    download_geosite
    rename_new
}

main
