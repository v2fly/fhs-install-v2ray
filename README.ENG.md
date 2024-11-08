#fhs-install-v2ray

> For an introduction in Simplified Chinese, please visit: [README.md](README.md)

> Bash script for installing V2Ray in operating systems such as Debian / CentOS / Fedora / openSUSE that support systemd

The files installed by this script conform to the [Filesystem Hierarchy Standard (FHS)](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard):

```
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
```

## important hint

**It is not recommended to use this project to install v2ray in docker, please use the [official image](https://github.com/v2fly/docker) directly. **
If the official image cannot meet your custom installation needs, please **fork and modify the upstream dockerfile to achieve**.

This project **does not automatically generate configuration files for you**; **only solves problems encountered by users during installation**. Other questions cannot be helped here.
Please refer to [documentation](https://www.v2fly.org/) to understand the syntax of the configuration file after the installation is complete, and complete the configuration file that suits you. During the process, you can refer to the [configuration file template](https://github.com/v2fly/v2ray-examples) contributed by the community
(**Please note that these templates need to be modified and adjusted by yourself after copying, and cannot be used directly**)

## use

* The script will provide information such as `info` and `error` when it is executed, please read it carefully.

### Install and update V2Ray

```
// Install executable and .dat data files
# bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
```

### Install the latest release of geoip.dat and geosite.dat

```
// only update the .dat data file
# bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
```

### Remove V2Ray

```
# bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove
```

### Solve the problem

* "[Do not install or update geoip.dat and geosite.dat](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and- geosite.dat)".
* "[Insufficient permissions when using certificates](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates)".
* "[Migrate from the old script to this](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this)".
* "[Move .dat files from lib directory to share directory](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share -directory)".
* "[To use the VLESS protocol](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol)".

> If your question is not listed above, welcome to ask in the Issue area.

**Please read [Issue #63](https://github.com/v2fly/fhs-install-v2ray/issues/63) before asking questions, otherwise it may not be answered and locked. **

## contribute

Please do it on the [develop](https://github.com/v2fly/fhs-install-v2ray/tree/develop) branch to avoid damage to the main branch.

After confirmation, the two branches will be merged.
