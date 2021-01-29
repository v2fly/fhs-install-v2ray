# fhs-install-v2ray

* * *

## README translation

-   [Traditional Chinese README.md](README.md)
-   [Simplified Chinese README.zh-CN.md](README.zh-CN.md)
-   [English README.en.md](README.en.md)
-   [Hindi README.hi.md](README.hi.md)

## Overview

The fhs-install-v2ray installation script is used to easily deploy v2ray to bypass network restrictions to build your own proxy

## Supported operating system

Requires Linux systemd

-   Debian / Ubuntu
-   CentOS / RHEL
-   Fedora
-   openSUSE

## Installation and configuration

### Install and update V2Ray

Install executable file and .dat data file

    # sudo bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

### V2Ray configuration

1.  Generate configuration file[https://intmainreturn0.com/v2ray-config-gen](https://intmainreturn0.com/v2ray-config-gen/)
2.  Put the configuration file config.json into /usr/local/etc/v2ray/config.json

### Offline installation

In an environment with network download restrictions, we recommend:

1.  Download the fhs-install-v2ray repository as a zip file from GitHub.com.
2.  Download the v2ray-core release zip file from the following location<https://github.com/v2fly/v2ray-core/releases>
3.  Upload both zip files to your server
4.  Unzip the fhs-install-v2ray repository zip file
5.  Run the installation and point it to the local v2ray-core zip file:`sudo bash install-release.sh --local /path/to/v2ray-linux-64.zip`

## Update or delete

### Install the latest geoip.dat and geosite.dat

    # sudo bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)

### Remove V2Ray

    # sudo bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove

## Package Contents

The files installed by the script conform to[Filesystem Hierarchy Standard (FHS)](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)：

    installed: /usr/local/bin/v2ray
    installed: /usr/local/bin/v2ctl
    installed: /usr/local/share/v2ray/geoip.dat
    installed: /usr/local/share/v2ray/geosite.dat
    installed: /usr/local/etc/v2ray/config.json
    installed: /var/log/v2ray/
    installed: /var/log/v2ray/access.log
    installed: /var/log/v2ray/error.log
    installed: /etc/systemd/system/v2ray.service
    installed: /etc/systemd/system/v2ray@.service

## important hint

-   It is not recommended to use this project to install v2ray in docker, please use it directly[Official image](https://github.com/v2fly/docker)。\*\*
-   If the official image cannot meet your custom installation needs, please reproduce and modify the upstream dockerfile to achieve
-   This project will not automatically generate configuration files for you; it only solves the problems encountered by users during the installation phase. Other issues cannot be helped here.
-   Please refer to after installation[文件](https://www.v2fly.org/)Understand the configuration file syntax, and complete the configuration file suitable for yourself. You can refer to community contributions during the process[Configuration profile template](https://github.com/v2fly/v2ray-examples)
-   Please note that these templates need to be modified and adjusted by yourself after they are copied, and cannot be used directly

## In record

-   The script will provide`info`with`error`Please read it carefully.

## Solve the problem

-   [Do not install or update geoip.dat and geosite.dat](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and-geosite.dat)
-   [Insufficient permissions when using certificates](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates)
-   [Migrate from the old script to this](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this)
-   [Move .dat files from lib directory to share directory](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share-directory)
-   [Use VLESS protocol](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol)

> If your question is not listed above, you are welcome to raise it in the Issue area.

**Please read before asking questions[Issue #63](https://github.com/v2fly/fhs-install-v2ray/issues/63), Otherwise it may not be answered and locked.**

## contribution

Please[develop](https://github.com/v2fly/fhs-install-v2ray/tree/develop)Branching is carried out to avoid damage to the main branch.

After confirmation, the two branches will be merged.
