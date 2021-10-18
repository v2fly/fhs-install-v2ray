#!/usr/bin/env bash
# shellcheck disable=SC2268

# The files installed by the script conform to the Filesystem Hierarchy Standard:
# https://wiki.linuxfoundation.org/lsb/fhs

# The URL of the script project is:
# https://github.com/v2fly/fhs-install-v2ray

# If the script executes incorrectly, go to:
# https://github.com/v2fly/fhs-install-v2ray/issues

# --- Script Version ---
# Name    : for-system-not-using-systemd
# Version : 3c02f0d (1 commit after this ref)
# Author  : IceCodeNew
# Date    : October 2021
# Download: https://cdn.jsdelivr.net/gh/for-system-using-openrc@master/for-system-not-using-systemd
readonly local_script_version='3c02f0d'

# You can set this variable whatever you want in shell session right before running this script by issuing:
# export ROOT_PATH='/usr/local/lib/v2ray'
ROOT_PATH=${ROOT_PATH:-/usr/local/share/v2ray}

# You can set this variable whatever you want in shell session right before running this script by issuing:
# export JSON_PATH='/usr/local/etc/v2ray'
JSON_PATH=${JSON_PATH:-/usr/local/etc/v2ray}

curl_path="$(type -P curl)"
myip_ipip_response="$(curl -sS 'http://myip.ipip.net' | grep -E '来自于：中国' | grep -vE '香港|澳门|台湾')"
echo "$myip_ipip_response" | grep -qE '来自于：中国' && readonly geoip_is_cn='yes' && curl_path="$(type -P curl) --retry-connrefused"
curl() {
  # It is OK for the system which has cURL's version greater than `7.76.0` to use `--fail-with-body` instead of `-f`.
  ## Refer to: https://superuser.com/a/1626376
  $curl_path -LRfq --retry 5 --retry-delay 10 --retry-max-time 60 "$@"
}

################

check_if_running_as_root() {
  # If you want to run as another user, please modify $UID to be owned by this user
  if [[ "$UID" -ne '0' ]]; then
    echo "WARNING: The user currently executing this script is not root. You may encounter the insufficient privilege error."
    read -r -p "Are you sure you want to continue? [y/n] " cont_without_been_root
    if [[ x"${cont_without_been_root:0:1}" = x'y' ]]; then
      echo "Continuing the installation with current user..."
    else
      echo "Not running with root, exiting..."
      exit 1
    fi
  fi
}

identify_the_operating_system_and_architecture() {
  if [[ "$(uname)" == 'Linux' ]]; then
    case "$(uname -m)" in
      'i386' | 'i686')
        MACHINE='32'
        ;;
      'amd64' | 'x86_64')
        MACHINE='64'
        ;;
      'armv5tel')
        MACHINE='arm32-v5'
        ;;
      'armv6l')
        MACHINE='arm32-v6'
        grep Features /proc/cpuinfo | grep -qw 'vfp' || MACHINE='arm32-v5'
        ;;
      'armv7' | 'armv7l')
        MACHINE='arm32-v7a'
        grep Features /proc/cpuinfo | grep -qw 'vfp' || MACHINE='arm32-v5'
        ;;
      'armv8' | 'aarch64')
        MACHINE='arm64-v8a'
        ;;
      'mips')
        MACHINE='mips32'
        ;;
      'mipsle')
        MACHINE='mips32le'
        ;;
      'mips64')
        MACHINE='mips64'
        ;;
      'mips64le')
        MACHINE='mips64le'
        ;;
      'ppc64')
        MACHINE='ppc64'
        ;;
      'ppc64le')
        MACHINE='ppc64le'
        ;;
      'riscv64')
        MACHINE='riscv64'
        ;;
      's390x')
        MACHINE='s390x'
        ;;
      *)
        echo "error: The architecture is not supported."
        exit 1
        ;;
    esac
    # if [[ ! -f '/etc/os-release' ]]; then
    #   echo "error: Don't use outdated Linux distributions."
    #   exit 1
    # fi

    # Do not combine this judgment condition with the following judgment condition.
    ## Be aware of Linux distribution like Gentoo, which kernel supports switch between Systemd and OpenRC.
    ### Refer: https://github.com/v2fly/fhs-install-v2ray/issues/84#issuecomment-688574989
    if [[ "$(type -P systemctl)" ]] || [[ -d /run/systemd/system ]] || grep -q systemd <(ls -l /sbin/init); then
      echo "error: Linux distros using systemd should not run this script."
      exit 1
    elif [[ "$(type -P sv)" ]]; then
      setup_for_runit
    elif [[ "$(type -P rc-update)" ]]; then
      setup_for_openrc
    else
      echo "error: The init implementation may not be supported yet."
      exit 1
    fi
    if [[ "$(type -P apk)" ]]; then
      PACKAGE_MANAGEMENT_INSTALL='apk add'
      PACKAGE_MANAGEMENT_REMOVE='apk delete'
    elif [[ "$(type -P xbps-install)" ]]; then
      PACKAGE_MANAGEMENT_INSTALL='xbps-install -Syu'
      PACKAGE_MANAGEMENT_REMOVE='xbps-remove -foyOR'
    else
      echo "error: The script may not support the package manager in this operating system yet."
      exit 1
    fi
  else
    echo "error: This operating system is not supported."
    exit 1
  fi
}

## Demo function for processing parameters
judgment_parameters() {
  while [[ "$#" -gt '0' ]]; do
    case "$1" in
      '--remove')
        if [[ "$#" -gt '1' ]]; then
          echo 'error: Please enter the correct parameters.'
          exit 1
        fi
        REMOVE='1'
        ;;
      '--version')
        VERSION="${2:?error: Please specify the correct version.}"
        break
        ;;
      '-c' | '--check')
        CHECK='1'
        break
        ;;
      '-f' | '--force')
        FORCE='1'
        break
        ;;
      '-h' | '--help')
        HELP='1'
        break
        ;;
      '-l' | '--local')
        LOCAL_INSTALL='1'
        LOCAL_FILE="${2:?error: Please specify the correct local file.}"
        break
        ;;
      '-p' | '--proxy')
        if [[ -z "${2:?error: Please specify the proxy server address.}" ]]; then
          exit 1
        fi
        PROXY="$2"
        shift
        ;;
      *)
        echo "$0: unknown option -- -"
        exit 1
        ;;
    esac
    shift
  done
}

install_software() {
  package_name="$1"
  file_to_detect="$2"
  type -P "$file_to_detect" > /dev/null 2>&1 && return
  if ${PACKAGE_MANAGEMENT_INSTALL} "$package_name"; then
    echo "info: $package_name is installed."
  else
    echo "error: Installation of $package_name failed, please check your network."
    exit 1
  fi
}

get_version() {
  # 0: Install or update V2Ray.
  # 1: Installed or no new version of V2Ray.
  # 2: Install the specified version of V2Ray.
  if [[ -n "$VERSION" ]]; then
    RELEASE_VERSION="v${VERSION#v}"
    return 2
  fi
  # Determine the version number for V2Ray installed from a local file
  if [[ -f '/usr/local/bin/v2ray' ]]; then
    VERSION="$(/usr/local/bin/v2ray -version | awk 'NR==1 {print $2}')"
    CURRENT_VERSION="v${VERSION#v}"
    if [[ "$LOCAL_INSTALL" -eq '1' ]]; then
      RELEASE_VERSION="$CURRENT_VERSION"
      return
    fi
  fi
  # Get V2Ray release version number
  TMP_FILE="$(mktemp)"
  if ! curl -x "${PROXY}" -sS -H "Accept: application/vnd.github.v3+json" -o "$TMP_FILE" 'https://api.github.com/repos/v2fly/v2ray-core/releases/latest'; then
    "rm" "$TMP_FILE"
    echo 'error: Failed to get release list, please check your network.'
    exit 1
  fi
  RELEASE_LATEST="$(sed 'y/,/\n/' "$TMP_FILE" | grep 'tag_name' | awk -F '"' '{print $4}')"
  "rm" "$TMP_FILE"
  RELEASE_VERSION="v${RELEASE_LATEST#v}"
  # Compare V2Ray version numbers
  if [[ "$RELEASE_VERSION" != "$CURRENT_VERSION" ]]; then
    RELEASE_VERSIONSION_NUMBER="${RELEASE_VERSION#v}"
    RELEASE_MAJOR_VERSION_NUMBER="${RELEASE_VERSIONSION_NUMBER%%.*}"
    RELEASE_MINOR_VERSION_NUMBER="$(echo "$RELEASE_VERSIONSION_NUMBER" | awk -F '.' '{print $2}')"
    RELEASE_MINIMUM_VERSION_NUMBER="${RELEASE_VERSIONSION_NUMBER##*.}"
    # shellcheck disable=SC2001
    CURRENT_VERSIONSION_NUMBER="$(echo "${CURRENT_VERSION#v}" | sed 's/-.*//')"
    CURRENT_MAJOR_VERSION_NUMBER="${CURRENT_VERSIONSION_NUMBER%%.*}"
    CURRENT_MINOR_VERSION_NUMBER="$(echo "$CURRENT_VERSIONSION_NUMBER" | awk -F '.' '{print $2}')"
    CURRENT_MINIMUM_VERSION_NUMBER="${CURRENT_VERSIONSION_NUMBER##*.}"
    if [[ "$RELEASE_MAJOR_VERSION_NUMBER" -gt "$CURRENT_MAJOR_VERSION_NUMBER" ]]; then
      return 0
    elif [[ "$RELEASE_MAJOR_VERSION_NUMBER" -eq "$CURRENT_MAJOR_VERSION_NUMBER" ]]; then
      if [[ "$RELEASE_MINOR_VERSION_NUMBER" -gt "$CURRENT_MINOR_VERSION_NUMBER" ]]; then
        return 0
      elif [[ "$RELEASE_MINOR_VERSION_NUMBER" -eq "$CURRENT_MINOR_VERSION_NUMBER" ]]; then
        if [[ "$RELEASE_MINIMUM_VERSION_NUMBER" -gt "$CURRENT_MINIMUM_VERSION_NUMBER" ]]; then
          return 0
        else
          return 1
        fi
      else
        return 1
      fi
    else
      return 1
    fi
  elif [[ "$RELEASE_VERSION" == "$CURRENT_VERSION" ]]; then
    return 1
  fi
}

download_v2ray() {
  DOWNLOAD_LINK="https://github.com/v2fly/v2ray-core/releases/download/$RELEASE_VERSION/v2ray-linux-$MACHINE.zip"
  echo "Downloading V2Ray archive: $DOWNLOAD_LINK"
  if ! curl -x "${PROXY}" -R -H 'Cache-Control: no-cache' -o "$ZIP_FILE" "$DOWNLOAD_LINK"; then
    echo 'error: Download failed! Please check your network or try again.'
    return 1
  fi
  echo "Downloading verification file for V2Ray archive: $DOWNLOAD_LINK.dgst"
  if ! curl -x "${PROXY}" -sSR -H 'Cache-Control: no-cache' -o "$ZIP_FILE.dgst" "$DOWNLOAD_LINK.dgst"; then
    echo 'error: Download failed! Please check your network or try again.'
    return 1
  fi
  if [[ "$(cat "$ZIP_FILE".dgst)" == 'Not Found' ]]; then
    echo 'error: This version does not support verification. Please replace with another version.'
    return 1
  fi

  # Verification of V2Ray archive
  for LISTSUM in 'md5' 'sha1' 'sha256' 'sha512'; do
    SUM="$(${LISTSUM}sum "$ZIP_FILE" | sed 's/ .*//')"
    CHECKSUM="$(grep ${LISTSUM^^} "$ZIP_FILE".dgst | grep "$SUM" -o -a | uniq)"
    if [[ "$SUM" != "$CHECKSUM" ]]; then
      echo 'error: Check failed! Please check your network or try again.'
      return 1
    fi
  done
}

decompression() {
  if ! unzip -q "$1" -d "$TMP_DIRECTORY"; then
    echo 'error: V2Ray decompression failed.'
    "rm" -r "$TMP_DIRECTORY"
    echo "removed: $TMP_DIRECTORY"
    exit 1
  fi
  echo "info: Extract the V2Ray package to $TMP_DIRECTORY and prepare it for installation."
}

install_file() {
  NAME="$1"
  if [[ "$NAME" == 'v2ray' ]] || [[ "$NAME" == 'v2ctl' ]]; then
    install -pvD -m 755 "${TMP_DIRECTORY}/$NAME" "/usr/local/bin/$NAME"
  elif [[ "$NAME" == 'geoip.dat' ]] || [[ "$NAME" == 'geosite.dat' ]]; then
    install -pvD -m 644 "${TMP_DIRECTORY}/$NAME" "${DAT_PATH}/$NAME"
  fi
  setcap 'CAP_NET_ADMIN=+ep CAP_NET_BIND_SERVICE=+ep' '/usr/local/bin/v2ray'
}

install_v2ray() {
  # Install V2Ray binary to /usr/local/bin/ and $DAT_PATH
  install_file v2ray
  install_file v2ctl
  install -pvd "$DAT_PATH"
  # If the file exists, geoip.dat and geosite.dat will not be installed or updated
  if [[ ! -f "${DAT_PATH}/.undat" ]]; then
    install_file geoip.dat
    install_file geosite.dat
  fi

  # Install V2Ray configuration file to $JSON_PATH
  # shellcheck disable=SC2153
  if [[ -z "$JSONS_PATH" ]] && [[ ! -d "$JSON_PATH" ]]; then
    install -pvd "$JSON_PATH"
    echo "{}" > "${JSON_PATH}/config.json"
    CONFIG_NEW='1'
  fi

  # Install V2Ray configuration file to $JSONS_PATH
  if [[ -n "$JSONS_PATH" ]] && [[ ! -d "$JSONS_PATH" ]]; then
    install -pvd "$JSONS_PATH"
    for BASE in 00_log 01_api 02_dns 03_routing 04_policy 05_inbounds 06_outbounds 07_transport 08_stats 09_reverse; do
      echo '{}' > "${JSONS_PATH}/${BASE}.json"
    done
    CONFDIR='1'
  fi

  # Used to store V2Ray log files
  if [[ ! -d '/var/log/v2ray/' ]]; then
    if id nobody | grep -qw 'nogroup'; then
      install -pvd -m 700 -o nobody -g nogroup /var/log/v2ray/
      install -pvD -m 600 -o nobody -g nogroup /dev/null /var/log/v2ray/access.log
      install -pvD -m 600 -o nobody -g nogroup /dev/null /var/log/v2ray/error.log
    else
      install -pvd -m 700 -o nobody -g nobody /var/log/v2ray/
      install -pvD -m 600 -o nobody -g nobody /dev/null /var/log/v2ray/access.log
      install -pvD -m 600 -o nobody -g nobody /dev/null /var/log/v2ray/error.log
    fi
    LOG='1'
  fi
}

################

self_update() {
  remote_script_version="$(curl -sSL -H 'Accept: application/vnd.github.v3+json' \
    'https://api.github.com/repos/for-system-using-openrc/commits?per_page=2&path=for-system-not-using-systemd' |
      jq .[1] | grep -Fm1 'sha' | cut -d'"' -f4 | head -c7)"
  readonly remote_script_version
  # Should any error occured during quering `api.github.com`, do not execute this script.
  [[ x"${geoip_is_cn:0:1}" = x'y' ]] &&
    sed -i -E -e 's!(https://github.com/.+/download/)!https://gh.api.99988866.xyz/\1!g' "${ROOT_PATH}/for-system-not-using-systemd" &&
    git config --global url."https://hub.fastgit.org".insteadOf https://github.com
  [[ x"$local_script_version" = x"$remote_script_version" ]] &&
    install_binaries
  # else, self update if script_version does not match.
  sleep $(( ( RANDOM % 10 ) + 1 ))s && curl -i "https://purge.jsdelivr.net/gh/for-system-using-openrc@master/for-system-not-using-systemd"
  if [[ x"${geoip_is_cn:0:1}" = x'y' ]]; then
    curl -o "${ROOT_PATH}/for-system-not-using-systemd.tmp" -- 'https://cdn.jsdelivr.net/gh/for-system-using-openrc@master/for-system-not-using-systemd'
    sed -i -E -e 's!(https://github.com/.+/download/)!https://gh.api.99988866.xyz/\1!g' "${ROOT_PATH}/for-system-not-using-systemd.tmp"
  else
    curl -o "${ROOT_PATH}/for-system-not-using-systemd.tmp" -- 'https://cdn.jsdelivr.net/gh/for-system-using-openrc@master/for-system-not-using-systemd'
  fi
  dos2unix "${ROOT_PATH}/for-system-not-using-systemd.tmp" && mv -f "${ROOT_PATH}/for-system-not-using-systemd.tmp" "${ROOT_PATH}/for-system-not-using-systemd" &&
  echo 'Upgrade successful!' && exit 1
}

setup_for_runit() {
  if ! [[ -f /etc/sv/v2ray/run ]]; then
    rm -rf /etc/sv/v2ray && mkdir -p /etc/sv/v2ray && mkdir -p /var/log/v2ray &&
    cat > /etc/sv/v2ray/run << 'END_TEXT'
#!/bin/sh
ulimit -n ${MAX_OPEN_FILES:-65535}

# exec chpst -u nobody:nogroup v2ray -confdir /usr/local/etc/v2ray/conf.d
exec chpst -u nobody:nogroup v2ray -config /usr/local/etc/v2ray/config.json
END_TEXT

    chmod +x /etc/sv/v2ray/run &&
    ln -s /etc/sv/v2ray /var/service/
  fi
}

setup_for_openrc() {
  if ! [[ -f /etc/init.d/v2ray ]]; then
    cat > /etc/init.d/v2ray << 'END_TEXT'
#!/sbin/openrc-run

name="v2ray"

command=/usr/local/bin/v2ray
# command_args="-confdir /usr/local/etc/v2ray/conf.d"
command_args="-config /usr/local/etc/v2ray/config.json"

depend() {
        need net
        after firewall
        use dns logger
}
END_TEXT

    chmod +x /etc/init.d/v2ray &&
    rc-update add haproxy
  fi
}

  ################

check_update() {
  if [[ -f '/etc/systemd/system/v2ray.service' ]]; then
    get_version
    local get_ver_exit_code=$?
    if [[ "$get_ver_exit_code" -eq '0' ]]; then
      echo "info: Found the latest release of V2Ray $RELEASE_VERSION . (Current release: $CURRENT_VERSION)"
    elif [[ "$get_ver_exit_code" -eq '1' ]]; then
      echo "info: No new version. The current version of V2Ray is $CURRENT_VERSION ."
    fi
    exit 0
  else
    echo 'error: V2Ray is not installed.'
    exit 1
  fi
}

remove_v2ray() {
  sv down v2ray && "rm" -f '/var/service/v2ray' '/etc/sv/v2ray'
  rc-service v2ray stop && rc-update del v2ray && "rm" -f '/etc/init.d/v2ray'
  pkill v2ray
  "rm" -rf '/usr/local/bin/v2ray' \
    '/usr/local/bin/v2ctl' \
    "$DAT_PATH"
    echo "You may need to execute a command to remove dependent software: $PACKAGE_MANAGEMENT_REMOVE curl unzip"
    echo 'info: V2Ray has been removed.'
    echo 'info: If necessary, manually delete the configuration and log files.'
    if [[ -n "$JSONS_PATH" ]]; then
      echo "info: e.g., $JSONS_PATH and /var/log/v2ray/ ..."
    else
      echo "info: e.g., $JSON_PATH and /var/log/v2ray/ ..."
    fi
    exit 0
}

# Explanation of parameters in the script
show_help() {
  echo "usage: $0 [--remove | --version number | -c | -f | -h | -l | -p]"
  echo '  [-p address] [--version number | -c | -f]'
  echo '  --remove        Remove V2Ray'
  echo '  --version       Install the specified version of V2Ray, e.g., --version v4.18.0'
  echo '  -c, --check     Check if V2Ray can be updated'
  echo '  -f, --force     Force installation of the latest version of V2Ray'
  echo '  -h, --help      Show help'
  echo '  -l, --local     Install V2Ray from a local file'
  echo '  -p, --proxy     Download through a proxy server, e.g., -p http://127.0.0.1:8118 or -p socks5://127.0.0.1:1080'
  exit 0
}

main() {
  check_if_running_as_root
  mkdir -p "$ROOT_PATH"
  self_update

  identify_the_operating_system_and_architecture
  judgment_parameters "$@"

  # Parameter information
  [[ "$HELP" -eq '1' ]] && show_help
  [[ "$CHECK" -eq '1' ]] && check_update
  [[ "$REMOVE" -eq '1' ]] && remove_v2ray

  # Two very important variables
  TMP_DIRECTORY="$(mktemp -d)"
  ZIP_FILE="${TMP_DIRECTORY}/v2ray-linux-$MACHINE.zip"

  # Install V2Ray from a local file, but still need to make sure the network is available
  if [[ "$LOCAL_INSTALL" -eq '1' ]]; then
    echo 'warn: Install V2Ray from a local file, but still need to make sure the network is available.'
    echo -n 'warn: Please make sure the file is valid because we cannot confirm it. (Press any key) ...'
    read -r
    install_software 'unzip' 'unzip'
    decompression "$LOCAL_FILE"
  else
    # Normal way
    install_software 'curl' 'curl'
    get_version
    NUMBER="$?"
    if [[ "$NUMBER" -eq '0' ]] || [[ "$FORCE" -eq '1' ]] || [[ "$NUMBER" -eq 2 ]]; then
      echo "info: Installing V2Ray $RELEASE_VERSION for $(uname -m)"
      download_v2ray
      if [[ "$?" -eq '1' ]]; then
        "rm" -r "$TMP_DIRECTORY"
        echo "removed: $TMP_DIRECTORY"
        echo "Downloading has just failed, please check the network connection!"
        exit 1
      fi
      install_software 'unzip' 'unzip'
      decompression "$ZIP_FILE"
    elif [[ "$NUMBER" -eq '1' ]]; then
      echo "info: No new version. The current version of V2Ray is $CURRENT_VERSION ."
      exit 0
    fi
  fi

  install_v2ray
  echo 'installed: /usr/local/bin/v2ray'
  echo 'installed: /usr/local/bin/v2ctl'
  # If the file exists, the content output of installing or updating geoip.dat and geosite.dat will not be displayed
  if [[ ! -f "${DAT_PATH}/.undat" ]]; then
    echo "installed: ${DAT_PATH}/geoip.dat"
    echo "installed: ${DAT_PATH}/geosite.dat"
  fi
  if [[ "$CONFIG_NEW" -eq '1' ]]; then
    echo "installed: ${JSON_PATH}/config.json"
  fi
  if [[ "$CONFDIR" -eq '1' ]]; then
    echo "installed: ${JSON_PATH}/00_log.json"
    echo "installed: ${JSON_PATH}/01_api.json"
    echo "installed: ${JSON_PATH}/02_dns.json"
    echo "installed: ${JSON_PATH}/03_routing.json"
    echo "installed: ${JSON_PATH}/04_policy.json"
    echo "installed: ${JSON_PATH}/05_inbounds.json"
    echo "installed: ${JSON_PATH}/06_outbounds.json"
    echo "installed: ${JSON_PATH}/07_transport.json"
    echo "installed: ${JSON_PATH}/08_stats.json"
    echo "installed: ${JSON_PATH}/09_reverse.json"
  fi
  if [[ "$LOG" -eq '1' ]]; then
    echo 'installed: /var/log/v2ray/'
    echo 'installed: /var/log/v2ray/access.log'
    echo 'installed: /var/log/v2ray/error.log'
  fi
  "rm" -r "$TMP_DIRECTORY"
  echo "removed: $TMP_DIRECTORY"
  if [[ "$LOCAL_INSTALL" -eq '1' ]]; then
    get_version
  fi
  echo "info: V2Ray $RELEASE_VERSION is installed."
  echo "You may need to execute a command to remove dependent software: $PACKAGE_MANAGEMENT_REMOVE curl unzip"

  git config --global --unset url.https://hub.fastgit.org.insteadof
  exit 0
}

main "$@"
