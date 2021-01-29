# fhs-install-v2ray

* * *

## README translation

-   [Traditional Chinese-README.md](README.md)
-   [Simplified Chinese-README.zh-CN.md](README.zh-CN.md)
-   [English-README.en.md](README.en.md)
-   [Hindi-README.hi.md](README.hi.md)

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

    ## 安裝執行檔和 .dat 資料檔
    # sudo bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

### V2Ray configuration

1.  Generate configuration file[https://intmainreturn0.com/v2ray-config-gen](https://intmainreturn0.com/v2ray-config-gen/)
2.  Put the configuration file config.json into /usr/local/etc/v2ray/config.json

### Offline installation

In an environment with network download restrictions, we recommend:
1\. Download the fhs-install-v2ray repository as a zip file from GitHub.com.
2\. Download the v2ray-core release zip file from the following location[https://github.com/v2fly/v2ray-core/releases]\(<https://github.com/v2fly/v2ray-core/releases）>3. Upload both zip files to your server
4\. Unzip the fhz-install-v2ray repository zip file
5\. Run the installation and point it to the local v2ray-core zip file:`sudo bash install-release.sh --local /path/to/v2ray-linux-64.zip`

## Update or delete

### Install the latest geoip.dat and geosite.dat

    ## 只更新 .dat 資料檔
    # sudo bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)

### Remove V2Ray

    # sudo bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove

## Package Contents

The files installed by this script conform to:[Filesystem Hierarchy Standard (FHS)](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)：

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

**It is not recommended to use this project to install v2ray in docker, please use directly:[Official image](https://github.com/v2fly/docker)。**  
If the official image cannot meet your custom installation needs, please**Reproduce and modify the upstream dockerfile to achieve**。

This project**Will not automatically generate configuration files for you**；**Only solve problems encountered by users during installation**. Other issues cannot be helped here.  
Please refer to:[file](https://www.v2fly.org/)Understand the configuration file syntax, and complete the configuration file suitable for yourself. In the process, you can refer to the community contributions:[Configuration profile template](https://github.com/v2fly/v2ray-examples)

(**Please note that these templates need to be modified and adjusted by yourself after they are copied, and cannot be used directly**）

## use

-   The script will provide`info`with`error`Please read it carefully.

## Solve the problem

-   [Do not install or update geoip.dat and geosite.dat](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and-geosite.dat)
-   [Insufficient permissions when using certificates](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates)
-   [Migrate from the old script to this](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this)
-   [Move .dat files from lib directory to share directory](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share-directory)
-   [Use VLESS protocol](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol)

> If your question is not listed above, you are welcome to raise it in the Issue area.

**Please read before asking:[Issue #63](https://github.com/v2fly/fhs-install-v2ray/issues/63), Otherwise it may not be answered and locked.**

## contribution

Please[develop](https://github.com/v2fly/fhs-install-v2ray/tree/develop)Branching is carried out to avoid damage to the main branch.

After confirmation, the two branches will be merged.
