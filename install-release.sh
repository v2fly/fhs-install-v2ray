#!/bin/bash

# The files installed by the script conform to the Filesystem Hierarchy Standard:
# https://wiki.linuxfoundation.org/lsb/fhs

# The URL of the script project is:
# https://github.com/v2fly/fhs-install-v2ray

# The URL of the script is:
# https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh

# If the script executes incorrectly, go to:
# https://github.com/v2fly/fhs-install-v2ray/issues

# You can set this variable whatever you want in shell session right before running this script by issuing:
# export DAT_PATH='/usr/local/share/v2ray'
DAT_PATH=${DAT_PATH:-/usr/local/share/v2ray}

# You can set this variable whatever you want in shell session right before running this script by issuing:
# export JSON_PATH='/usr/local/etc/v2ray'
JSON_PATH=${JSON_PATH:-/usr/local/etc/v2ray}

# Set this variable only if you are starting v2ray with multiple configuration files:
# export JSONS_PATH='/usr/local/etc/v2ray'

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

check_if_running_as_root() {
  # If you want to run as another user, please modify $UID to be owned by this user
  if [[ "$UID" -ne '0' ]]; then
    echo "error: You must run this script as root!"
    exit 1
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
        ;;
      'armv7' | 'armv7l')
        MACHINE='arm32-v7a'
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
    if [[ ! -f '/etc/os-release' ]]; then
      echo "error: Don't use outdated Linux distributions."
      exit 1
    fi
    if [[ -z "$(ls -l /sbin/init | grep systemd)" ]]; then
      echo "error: Only Linux distributions using systemd are supported."
      exit 1
    fi
    if [[ "$(command -v apt)" ]]; then
      PACKAGE_MANAGEMENT_INSTALL='apt install'
      PACKAGE_MANAGEMENT_REMOVE='apt remove'
    elif [[ "$(command -v yum)" ]]; then
      PACKAGE_MANAGEMENT_INSTALL='yum install'
      PACKAGE_MANAGEMENT_REMOVE='yum remove'
      if [[ "$(command -v dnf)" ]]; then
        PACKAGE_MANAGEMENT_INSTALL='dnf install'
        PACKAGE_MANAGEMENT_REMOVE='dnf remove'
      fi
    elif [[ "$(command -v zypper)" ]]; then
      PACKAGE_MANAGEMENT_INSTALL='zypper install'
      PACKAGE_MANAGEMENT_REMOVE='zypper remove'
    else
      echo "error: The script does not support the package manager in this operating system."
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
        if ! echo "${2:?undefine var}" | grep -qEo '^(https?|socks4a?|socks5h?):\/\/'; then
          echo 'error: Please specify the correct proxy server address.'
          exit 1
        fi
        PROXY="-x$2"
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
  COMPONENT="$1"
  command -v "$COMPONENT" >/dev/null 2>&1 && return
  if ${PACKAGE_MANAGEMENT_INSTALL} "$COMPONENT"; then
    echo "info: $COMPONENT is installed."
  else
    echo "error: Installation of $COMPONENT failed, please check your network."
    exit 1
  fi
}

version_number() {
  case "$1" in
    'v'*)
      echo "$1"
      ;;
    *)
      echo "v$1"
      ;;
  esac
}

get_version() {
  # 0: Install or update V2Ray.
  # 1: Installed or no new version of V2Ray.
  # 2: Install the specified version of V2Ray.
  if [[ -n "$VERSION" ]]; then
    RELEASE_VERSION="$(version_number "$VERSION")"
    return 2
  fi
  # Determine the version number for V2Ray installed from a local file
  if [[ -f '/usr/local/bin/v2ray' ]]; then
    VERSION="$(/usr/local/bin/v2ray -version)"
    CURRENT_VERSION="$(version_number "$(echo "$VERSION" | awk 'NR==1 {print $2}')")"
    if [[ "$LOCAL_INSTALL" -eq '1' ]]; then
      RELEASE_VERSION="$CURRENT_VERSION"
      return
    fi
  fi
  # Get V2Ray release version number
  TMP_FILE="$(mktemp)"
  install_software curl
  # DO NOT QUOTE THESE `${PROXY}` VARIABLES!
  if ! "curl" ${PROXY} -sSL -H "Accept: application/vnd.github.v3+json" -o "$TMP_FILE" 'https://api.github.com/repos/v2fly/v2ray-core/releases/latest'; then
    "rm" "$TMP_FILE"
    echo 'error: Failed to get release list, please check your network.'
    exit 1
  fi
  RELEASE_LATEST="$(sed 'y/,/\n/' "$TMP_FILE" | grep 'tag_name' | awk -F '"' '{print $4}')"
  "rm" "$TMP_FILE"
  RELEASE_VERSION="$(version_number "$RELEASE_LATEST")"
  # Compare V2Ray version numbers
  if [[ "$RELEASE_VERSION" != "$CURRENT_VERSION" ]]; then
    RELEASE_VERSIONSION_NUMBER="${RELEASE_VERSION#v}"
    RELEASE_MAJOR_VERSION_NUMBER="${RELEASE_VERSIONSION_NUMBER%%.*}"
    RELEASE_MINOR_VERSION_NUMBER="$(echo "$RELEASE_VERSIONSION_NUMBER" | awk -F '.' '{print $2}')"
    RELEASE_MINIMUM_VERSION_NUMBER="${RELEASE_VERSIONSION_NUMBER##*.}"
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
  if ! "curl" ${PROXY} -sSLR -H "Accept: application/vnd.github.v3+json" -H 'Cache-Control: no-cache' -o "$ZIP_FILE" "$DOWNLOAD_LINK"; then
    echo 'error: Download failed! Please check your network or try again.'
    return 1
  fi
  echo "Downloading verification file for V2Ray archive: $DOWNLOAD_LINK.dgst"
  if ! "curl" ${PROXY} -L -H 'Cache-Control: no-cache' -o "$ZIP_FILE.dgst" "$DOWNLOAD_LINK.dgst"; then
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
    install -m 755 "${TMP_DIRECTORY}/$NAME" "/usr/local/bin/$NAME"
  elif [[ "$NAME" == 'geoip.dat' ]] || [[ "$NAME" == 'geosite.dat' ]]; then
    install -m 644 "${TMP_DIRECTORY}/$NAME" "${DAT_PATH}/$NAME"
  fi
}

install_v2ray() {
  # Install V2Ray binary to /usr/local/bin/ and $DAT_PATH
  install_file v2ray
  install_file v2ctl
  install -d "$DAT_PATH"
  # If the file exists, geoip.dat and geosite.dat will not be installed or updated
  if [[ ! -f "${DAT_PATH}/.undat" ]]; then
    install_file geoip.dat
    install_file geosite.dat
  fi

  # Install V2Ray configuration file to $JSON_PATH
  if [[ -z "$JSONS_PATH" ]] && [[ ! -d "$JSON_PATH" ]]; then
    install -d "$JSON_PATH"
    echo "{}" >"${JSON_PATH}/config.json"
    CONFIG_NEW='1'
  fi

  # Install V2Ray configuration file to $JSONS_PATH
  if [[ -n "$JSONS_PATH" ]] && [[ ! -d "$JSONS_PATH" ]]; then
    install -d "$JSONS_PATH"
    for BASE in 00_log 01_api 02_dns 03_routing 04_policy 05_inbounds 06_outbounds 07_transport 08_stats 09_reverse; do
      echo '{}' >"${JSONS_PATH}$BASE.json"
    done
    CONFDIR='1'
  fi

  # Used to store V2Ray log files
  if [[ ! -d '/var/log/v2ray/' ]]; then
    if [[ -n "$(id nobody | grep nogroup)" ]]; then
      install -d -m 700 -o nobody -g nogroup /var/log/v2ray/
      install -m 600 -o nobody -g nogroup /dev/null /var/log/v2ray/access.log
      install -m 600 -o nobody -g nogroup /dev/null /var/log/v2ray/error.log
    else
      install -d -m 700 -o nobody -g nobody /var/log/v2ray/
      install -m 600 -o nobody -g nobody /dev/null /var/log/v2ray/access.log
      install -m 600 -o nobody -g nobody /dev/null /var/log/v2ray/error.log
    fi
    LOG='1'
  fi
}

install_startup_service_file() {
  install -m 644 "${TMP_DIRECTORY}/systemd/system/v2ray.service" /etc/systemd/system/v2ray.service
  install -m 644 "${TMP_DIRECTORY}/systemd/system/v2ray@.service" /etc/systemd/system/v2ray@.service
  mkdir -p '/etc/systemd/system/v2ray.service.d'
  mkdir -p '/etc/systemd/system/v2ray@.service.d/'
  if [[ -n "$JSONS_PATH" ]]; then
    echo "# Duplicate this file in the same directory and make your customizes there. Or all changes you made will be lost!
## Refer: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
[Service]
ExecStart=
ExecStart=/usr/local/bin/v2ray -confdir $JSONS_PATH" |
      tee '/etc/systemd/system/v2ray.service.d/10-donot_touch_multi_conf.conf' > \
        '/etc/systemd/system/v2ray@.service.d/10-donot_touch_multi_conf.conf'
  else
    echo "${red}~~~~~~~~~~~~~~~~ ${green}/etc/systemd/system/v2ray.service.d/10-donot_touch_single_conf ${red}~~~~~~~~~~~~~~~~${reset}"
    echo 'info: The following are the actual parameters for the v2ray service startup.'
    echo 'info: Please make sure the configuration file path is correctly set.'
    echo "# Duplicate this file in the same directory and make your customizes there. Or all changes you made will be lost!
## Refer: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
[Service]
ExecStart=
ExecStart=/usr/local/bin/v2ray -config ${JSON_PATH}/config.json" |
      tee '/etc/systemd/system/v2ray.service.d/10-donot_touch_single_conf.conf'
    echo
    echo

    echo "${red}~~~~~~~~~~~~~~~~ ${green}/etc/systemd/system/v2ray@.service.d/10-donot_touch_single_conf ${red}~~~~~~~~~~~~~~~~${reset}"
    echo 'info: The following are the actual parameters for the v2ray service startup.'
    echo 'info: Please make sure the configuration file path is correctly set.'
    echo "# Duplicate this file in the same directory and make your customizes there. Or all changes you made will be lost!
## Refer: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
[Service]
ExecStart=
ExecStart=/usr/local/bin/v2ray -config ${JSON_PATH}/%i.json" |
      tee '/etc/systemd/system/v2ray@.service.d/10-donot_touch_single_conf.conf'
    echo
    echo
  fi
  systemctl daemon-reload
  SYSTEMD='1'
}

start_v2ray() {
  if [[ -f '/etc/systemd/system/v2ray.service' ]]; then
    if systemctl start "${V2RAY_CUSTOMIZE:-v2ray}"; then
      echo 'info: Start the V2Ray service.'
    else
      echo 'error: Failed to start V2Ray service.'
      exit 1
    fi
  fi
}

stop_v2ray() {
  V2RAY_CUSTOMIZE="$(systemctl list-units | grep 'v2ray@' | awk -F ' ' '{print $1}')"
  if [[ -z "$V2RAY_CUSTOMIZE" ]]; then
    systemctl stop v2ray
  else
    systemctl stop "$V2RAY_CUSTOMIZE"
  fi
  if [[ "$?" -ne '0' ]]; then
    echo 'error: Stopping the V2Ray service failed.'
    exit 1
  fi
  echo 'info: Stop the V2Ray service.'
}

check_update() {
  if [[ -f '/etc/systemd/system/v2ray.service' ]]; then
    get_version
    if [[ "$?" -eq '0' ]]; then
      echo "info: Found the latest release of V2Ray $RELEASE_VERSION . (Current release: $CURRENT_VERSION)"
    elif [[ "$?" -eq '1' ]]; then
      echo "info: No new version. The current version of V2Ray is $CURRENT_VERSION ."
    fi
    exit 0
  else
    echo 'error: V2Ray is not installed.'
    exit 1
  fi
}

remove_v2ray() {
  if [[ -n "$(systemctl list-unit-files | grep 'v2ray')" ]]; then
    if [[ -n "$(pidof v2ray)" ]]; then
      stop_v2ray
    fi
    NAME="$1"
    "rm" /usr/local/bin/v2ray
    "rm" /usr/local/bin/v2ctl
    "rm" -r "$DAT_PATH"
    "rm" /etc/systemd/system/v2ray.service
    "rm" /etc/systemd/system/v2ray@.service
    if [[ "$?" -ne '0' ]]; then
      echo 'error: Failed to remove V2Ray.'
      exit 1
    else
      echo 'removed: /usr/local/bin/v2ray'
      echo 'removed: /usr/local/bin/v2ctl'
      echo "removed: $DAT_PATH"
      echo 'removed: /etc/systemd/system/v2ray.service'
      echo 'removed: /etc/systemd/system/v2ray@.service'
      echo 'Please execute the command: systemctl disable v2ray'
      echo "You may need to execute a command to remove dependent software: $PACKAGE_MANAGEMENT_REMOVE curl unzip"
      echo 'info: V2Ray has been removed.'
      echo 'info: If necessary, manually delete the configuration and log files.'
      echo "info: e.g., $JSON_PATH and /var/log/v2ray/ ..."
      exit 0
    fi
  else
    echo 'error: V2Ray is not installed.'
    exit 1
  fi
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
    read
    install_software unzip
    decompression "$LOCAL_FILE"
  else
    # Normal way
    get_version
    NUMBER="$?"
    if [[ "$NUMBER" -eq '0' ]] || [[ "$FORCE" -eq '1' ]] || [[ "$NUMBER" -eq 2 ]]; then
      echo "info: Installing V2Ray $RELEASE_VERSION for $(uname -m)"
      download_v2ray
      if [[ "$?" -eq '1' ]]; then
        "rm" -r "$TMP_DIRECTORY"
        echo "removed: $TMP_DIRECTORY"
        exit 0
      fi
      install_software unzip
      decompression "$ZIP_FILE"
    elif [[ "$NUMBER" -eq '1' ]]; then
      echo "info: No new version. The current version of V2Ray is $CURRENT_VERSION ."
      exit 0
    fi
  fi

  # Determine if V2Ray is running
  if [[ -n "$(systemctl list-unit-files | grep 'v2ray')" ]]; then
    if [[ -n "$(pidof v2ray)" ]]; then
      stop_v2ray
      V2RAY_RUNNING='1'
    fi
  fi
  install_v2ray
  install_startup_service_file
  echo 'installed: /usr/local/bin/v2ray'
  echo 'installed: /usr/local/bin/v2ctl'
  # If the file exists, the content output of installing or updating geoip.dat and geosite.dat will not be displayed
  if [[ ! -f "${DAT_PATH}/.undat" ]]; then
    echo "installed: ${DAT_PATH}/geoip.dat"
    echo "installed: ${DAT_PATH}/geosite.dat"
  fi
  if [[ "$CONFIG_NEW" -eq '1' ]]; then
    echo "installed: ${JSON_PATH}config.json"
  fi
  if [[ "$CONFDIR" -eq '1' ]]; then
    echo "installed: ${JSON_PATH}00_log.json"
    echo "installed: ${JSON_PATH}01_api.json"
    echo "installed: ${JSON_PATH}02_dns.json"
    echo "installed: ${JSON_PATH}03_routing.json"
    echo "installed: ${JSON_PATH}04_policy.json"
    echo "installed: ${JSON_PATH}05_inbounds.json"
    echo "installed: ${JSON_PATH}06_outbounds.json"
    echo "installed: ${JSON_PATH}07_transport.json"
    echo "installed: ${JSON_PATH}08_stats.json"
    echo "installed: ${JSON_PATH}09_reverse.json"
  fi
  if [[ "$LOG" -eq '1' ]]; then
    echo 'installed: /var/log/v2ray/'
    echo 'installed: /var/log/v2ray/access.log'
    echo 'installed: /var/log/v2ray/error.log'
  fi
  if [[ "$SYSTEMD" -eq '1' ]]; then
    echo 'installed: /etc/systemd/system/v2ray.service'
    echo 'installed: /etc/systemd/system/v2ray@.service'
  fi
  "rm" -r "$TMP_DIRECTORY"
  echo "removed: $TMP_DIRECTORY"
  if [[ "$LOCAL_INSTALL" -eq '1' ]]; then
    get_version
  fi
  echo "info: V2Ray $RELEASE_VERSION is installed."
  echo "You may need to execute a command to remove dependent software: $PACKAGE_MANAGEMENT_REMOVE curl unzip"
  if [[ "$V2RAY_RUNNING" -eq '1' ]]; then
    start_v2ray
  else
    echo 'Please execute the command: systemctl enable v2ray; systemctl start v2ray'
  fi
}

main "$@"
