#!/bin/bash

# This Bash script to install the latest release of geoip.dat and geosite.dat:

# https://github.com/v2ray/geoip
# https://github.com/v2ray/domain-list-community

# Depends on cURL, please solve it yourself

# You may plan to execute this Bash script regularly:

# install -m 755 install-dat-release.sh /usr/local/bin/install-dat-release

# 0 0 * * * /usr/local/bin/install-dat-release > /dev/null 2>&1

# You can modify it to /usr/local/lib/v2ray
V2RAY="/usr/local/share/v2ray"
DOWNLOAD_LINK_GEOIP="https://github.com/v2fly/geoip/releases/latest/download/geoip.dat"
DOWNLOAD_LINK_GEOSITE="https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat"
file_ip='geoip.dat'
file_dlc='dlc.dat'
file_site='geosite.dat'
dir_tmp="$(mktemp -d)"

check_if_running_as_root() {
    # If you want to run as another user, please modify $UID to be owned by this user
    if [[ "$UID" -ne '0' ]]; then
        echo "error: You must run this script as root!"
        exit 1
    fi
}

download_files() {
    if ! curl -L -H 'Cache-Control: no-cache' -o "${dir_tmp}/${2}" "${1}"; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
    if ! curl -L -H 'Cache-Control: no-cache' -o "${dir_tmp}/${2}.sha256sum" "${1}.sha256sum"; then
        echo 'error: Download failed! Please check your network or try again.'
        exit 1
    fi
}


check_sum() {
    (
        cd "${dir_tmp}" || exit
        for i in "${dir_tmp}"/*.sha256sum; do
            if ! sha256sum -c "${i}"; then
                echo 'error: Check failed! Please check your network or try again.'
                exit 1
            fi
        done
    )
}

install_file() {
    install -m 644 "${dir_tmp}"/${file_dlc} "${V2RAY}"/${file_site}
    install -m 644 "${dir_tmp}"/${file_ip} "${V2RAY}"/${file_ip}
    rm -r "${dir_tmp}"
}

main() {
    check_if_running_as_root
    download_files $DOWNLOAD_LINK_GEOIP $file_ip
    download_files $DOWNLOAD_LINK_GEOSITE $file_dlc
    check_sum
    install_file
}

main "$@"
