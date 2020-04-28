#!/bin/bash

V2RAY="/usr/local/lib/v2ray/"
DOWNLOAD_LINK_GEOIP="https://github.com/v2ray/v2ray-core/releases/latest/download/geoip.dat"
DOWNLOAD_LINK_GEOSITE="https://github.com/v2ray/v2ray-core/releases/latest/download/dlc.dat"

download_dat() {
    for DAT in 'geoip' 'geosite'; do
        curl -L -H 'Cache-Control: no-cache' -o "$V2RAY/$DAT.dat.bak" "$DOWNLOAD_LINK_${DAT^^}" -#
        if [ "$?" -ne '0' ]; then
            echo 'error: Download failed! Please check your network or try again.'
            exit 1
        fi
        curl -L -H 'Cache-Control: no-cache' -o "$V2RAY/$DAT.dat.sha256sum.bak" "$DOWNLOAD_LINK_${DAT^^}.sha256sum" -#
        if [ "$?" -ne '0' ]; then
            echo 'error: Download failed! Please check your network or try again.'
            exit 1
        fi
        SUM="$(sha256sum $V2RAY/$DAT.dat.bak | sed 's/ .*//')"
        CHECKSUM="$(sed 's/ .*//' $V2RAY/$DAT.dat.sha256sum.bak)"
        if [[ "$SUM" != "$CHECKSUM" ]]; then
            echo 'error: Check failed! Please check your network or try again.'
            exit 1
        fi
    done
}

rename_bak() {
    rename '.bak' '' "$V2RAY/$DAT.dat.bak"
    rm "$V2RAY/$DAT.dat.sha256sum.bak"
}

main() {
    download_dat
    rename_bak
}

main
