#!/bin/bash

V2RAY="/usr/local/lib/v2ray/"
DOWNLOAD_LINK_GEOIP="https://github.com/v2ray/geoip/releases/latest/download/geoip.dat"
DOWNLOAD_LINK_GEOSITE="https://github.com/v2ray/domain-list-community/releases/latest/download/dlc.dat"

download_geoip() {
    curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geoip.dat.bak" "$DOWNLOAD_LINK_GEOIP" -#
    if [ "$?" -ne '0' ]; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geoip.dat.sha256sum.bak" "$DOWNLOAD_LINK_GEOIP.sha256sum" -#
    if [ "$?" -ne '0' ]; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    SUM="$(sha256sum ${V2RAY}geoip.dat.bak | sed 's/ .*//')"
    CHECKSUM="$(sed 's/ .*//' ${V2RAY}geoip.dat.sha256sum.bak)"
    if [[ "$SUM" != "$CHECKSUM" ]]; then
        echo 'error: Check failed! Please check your network or try again.'
        exit 1
    fi
}

download_geosite() {
    curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geosite.dat.bak" "$DOWNLOAD_LINK_GEOSITE" -#
    if [ "$?" -ne '0' ]; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    curl -L -H 'Cache-Control: no-cache' -o "${V2RAY}geosite.dat.sha256sum.bak" "$DOWNLOAD_LINK_GEOSITE.sha256sum" -#
    if [ "$?" -ne '0' ]; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    SUM="$(sha256sum ${V2RAY}geosite.dat.bak | sed 's/ .*//')"
    CHECKSUM="$(sed 's/ .*//' ${V2RAY}geosite.dat.sha256sum.bak)"
    if [[ "$SUM" != "$CHECKSUM" ]]; then
        echo 'error: Check failed! Please check your network or try again.'
        exit 1
    fi
}

rename_bak() {
    for BAT in 'geoip' 'geosite'; do
        rename '.bak' '' "${V2RAY}$DAT.dat.bak"
        rm "${V2RAY}$DAT.dat.sha256sum.bak"
    done
}

main() {
    download_geoip
    download_geosite
    rename_bak
}

main
