# fhs-install-v2ray

# README Translation/Translation/Translation/अनुवाद

-   [Traditional Chinese-README.md](README.md)
-   [Simplified Chinese-README.zh-CN.md]\(README.zh-CN.md)
-   [English-README.en.md]\(README.en.md)
-   [Hindi-README.hi.md]\(README.hi.md)

# Overview

fhs-install-v2ray is an automatic installation script for v2ray, v2ray is a popular solution for building your own proxy to bypass network restrictions

# Supported operating system

System:

-   Debian
-   CentOS
-   Fedora
-   openSUSE

# Offline installation

In an environment with network download restrictions, we recommend:
1\. Download the repository as a zip file from GitHub.
2\. Download the v2ray-core zip file from the following location:
3\. Upload both zip files to your server
4\. Unzip the two zip files
5\. Run the installation: ./install.sh --local /path/to/v2ray-core.zip

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

**It is not recommended to use this project to install v2ray in docker, please use it directly[Official image](https://github.com/v2fly/docker)。**  
If the official image cannot meet your custom installation needs, please**Reproduce and modify the upstream dockerfile to achieve**。

This project**Will not automatically generate configuration files for you**；**Only solve problems encountered by users during installation**. Other issues cannot be helped here.  
Please refer to after installation[file](https://www.v2fly.org/)Understand the configuration file syntax, and complete the configuration file suitable for yourself. You can refer to community contributions during the process[Configuration profile template](https://github.com/v2fly/v2ray-examples)  
（**Please note that these templates need to be modified and adjusted by yourself after they are copied, and cannot be used directly**）

## use

-   The script will provide`info`with`error`Please read it carefully.

### Install and update V2Ray

    // 安裝執行檔和 .dat 資料檔
    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

### Install the latest geoip.dat and geosite.dat

    // 只更新 .dat 資料檔
    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)

### Remove V2Ray

    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove

### Solve the problem

-   「[Do not install or update geoip.dat and geosite.dat](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and-geosite.dat)」。
-   「[Insufficient permissions when using certificates](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates)」。
-   「[Migrate from the old script to this](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this)」。
-   「[Move .dat files from lib directory to share directory](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share-directory)」。
-   「[Use VLESS protocol](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol)」。

> If your question is not listed above, welcome to raise it in the Issue area.

**Please read before asking questions[Issue #63](https://github.com/v2fly/fhs-install-v2ray/issues/63), Otherwise it may not be answered and locked.**

## contribution

Please[develop](https://github.com/v2fly/fhs-install-v2ray/tree/develop)Branching to avoid damage to the main branch.

After confirmation, the two branches will be merged.
