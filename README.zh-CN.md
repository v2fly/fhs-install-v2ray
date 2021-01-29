# fhs-install-v2ray

> 欲查阅以简体中文撰写的介绍，请访问：[readme.这-Hans-cn.面对](README.zh-Hans-CN.md)

> 用于在支持systemd的Debian / CentOS / Fedora / openSUSE等操作系统中安装V2Ray的Bash脚本

该脚本安装的文件符合[文件系统层次结构标准（FHS）](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)：

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

## 重要提示

**不推荐在 docker 中使用本专案安装 v2ray，请直接使用[官方映象](https://github.com/v2fly/docker)。**  
如果官方映象不能满足您自定义安装的需要，请以**复刻并修改上游 dockerfile 的方式来实现**。

本專案**不会为您自动生成配置档案**；**只解决使用者安装阶段遇到的问题**。其他问题在这里是无法得到帮助的。  
请在安装完成后参阅[文件](https://www.v2fly.org/)了解配置档案语法，并自己完成适合自己的配置档案。过程中可参阅社群贡献的[配置档案模板](https://github.com/v2fly/v2ray-examples)  
（**提请您注意这些模板复制下来以后是需要您自己修改调整的，不能直接使用**）

## 使用

-   该脚本在执行时会提供`info`和`error`等信息，请仔细阅读。

### 安装和更新 V2Ray

    // 安裝執行檔和 .dat 資料檔
    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

### 安装最新发行的 geoip.dat 和 geosite.dat

    // 只更新 .dat 資料檔
    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)

### 移除 V2Ray

    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove

### 解决问题

-   「[不安装或更新 geoip.dat 和 geosite.dat](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and-geosite.dat)」。
-   「[使用证书时权限不足](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates)」。
-   「[从旧脚本迁移至此](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this)」。
-   「[将 .dat 文档由 lib 目录移动到 share 目录](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share-directory)」。
-   「[使用 VLESS 协议](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol)」。

> 若您的问题没有在上方列出，欢迎在 Issue 区提出。

**提问前请先阅读[问题63](https://github.com/v2fly/fhs-install-v2ray/issues/63)，否则可能无法得到解答并被锁定。**

## 贡献

请于[开发](https://github.com/v2fly/fhs-install-v2ray/tree/develop)分支进行，以避免对主分支造成破坏。

待确定无误后，两分支将进行合并。
