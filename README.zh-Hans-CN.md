# fhs-install-v2ray

> 欲查閱以繁體中文撰寫的介紹，請訪問：[README.md](README.md)

> Bash script for installing V2Ray in operating systems such as Debian / CentOS / Fedora / openSUSE that support systemd

该脚本安装的文档符合 [Filesystem Hierarchy Standard (FHS)](https://wiki.linuxfoundation.org/lsb/fhs)：

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

## 重要提示

本项目不会为您自动生成配置文件，只能解决用户安装阶段遇到的问题。其他问题在这里是无法得到帮助的。  
请在安装完成后参阅 [文档](https://www.v2fly.org/) 了解配置文件语法，并自己完成适合自己的配置文件。过程中可参阅社区贡献的 [配置文件模板](https://github.com/v2fly/v2ray-examples)  
（**提请您注意这些模板复制下来以后是需要您自己修改调整的，不能直接使用**）

## 使用

* 该脚本在运行时会提供 `info` 和 `error` 等信息，请仔细阅读。

### 安装和更新 V2Ray

```
// 安装可执行文件和 .dat 数据文件
# curl -LROJ https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
# bash install-release.sh
```

### 安装最新发行的 geoip.dat 和 geosite.dat

```
// 只更新 .dat 数据文件
# curl -LROJ https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh
# bash install-dat-release.sh
```

### 移除 V2Ray

```
# bash install-release.sh --remove
```

### 解决问题

* 「[不安装或更新 geoip.dat 和 geosite.dat](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and-geosite.dat-zh-Hans-CN)」。
* 「[使用证书时权限不足](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates-zh-Hans-CN)」。
* 「[从旧脚本迁移至此](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this-zh-Hans-CN)」。
* 「[将 .dat 文档由 lib 目录移动到 share 目录](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share-directory-zh-Hans-CN)」。
* 「[使用 VLESS 协议](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol-zh-Hans-CN)」。

> 若您的问题没有在上方列出，欢迎在 Issue 区提出。

**提问前请先阅读 [Issue #63](https://github.com/v2fly/fhs-install-v2ray/issues/63)，否则可能无法得到解答并被锁定。**

## 贡献

请于 [develop](https://github.com/v2fly/fhs-install-v2ray/tree/develop) 分支进行，以避免对主分支造成破坏。

待确定无误后，两分支将进行合并。
