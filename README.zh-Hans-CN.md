# fhs-install-v2ray

> 欲查閱以繁體中文撰寫的介紹，請訪問：[README.md](README.md)

> Bash script for installing V2Ray in operating systems such as Debian / CentOS / Fedora / openSUSE that support systemd

该脚本安装的文档符合 Filesystem Hierarchy Standard（FHS）：

https://wiki.linuxfoundation.org/lsb/fhs

```
installed: /usr/local/bin/v2ray
installed: /usr/local/bin/v2ctl
installed: /usr/local/share/v2ray/geoip.dat
installed: /usr/local/share/v2ray/geosite.dat
installed: /usr/local/etc/v2ray/00_log.json
installed: /usr/local/etc/v2ray/01_api.json
installed: /usr/local/etc/v2ray/02_dns.json
installed: /usr/local/etc/v2ray/03_routing.json
installed: /usr/local/etc/v2ray/04_policy.json
installed: /usr/local/etc/v2ray/05_inbounds.json
installed: /usr/local/etc/v2ray/06_outbounds.json
installed: /usr/local/etc/v2ray/07_transport.json
installed: /usr/local/etc/v2ray/08_stats.json
installed: /usr/local/etc/v2ray/09_reverse.json
installed: /var/log/v2ray/
installed: /var/log/v2ray/access.log
installed: /var/log/v2ray/error.log
installed: /etc/systemd/system/v2ray.service
installed: /etc/systemd/system/v2ray@.service
```

## 依赖软件

### 安装 cURL

```
# apt update
# apt install curl
```

or

```
# yum makecache
# yum install curl
```

or

```
# dnf makecache
# dnf install curl
```

or

```
# zypper refresh
# zypper install curl
```

## 下载

```
# curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
# curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh
```

## 使用

* 该脚本在运行时会提供 `info` 和 `error` 等信息，请仔细阅读。

### 安装和更新 V2Ray

```
# bash install-release.sh
```

### 安装最新发行的 geoip.dat 和 geosite.dat

```
# bash install-dat-release.sh
```

### 移除 V2Ray

```
# bash install-release.sh --remove
```

### 解决问题

* 「[不安装或更新 geoip.dat 和 geosite.dat](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and-geosite.dat-zh-CN)」。
* 「[使用证书时权限不足](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates-zh-CN)」。
* 「[从旧脚本迁移至此](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this-zh-CN)」。
* 「[将 .dat 文档由 lib 目录移动到 share 目录](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share-directory-zh-CN)」。
* 「[使用 VLESS 协议](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol-zh-CN)」。

## 参数

```
usage: install-release.sh [--remove | --version number | -c | -f | -h | -l | -p]
  [-p address] [--version number | -c | -f]
  --remove        Remove V2Ray
  --version       Install the specified version of V2Ray, e.g., --version v4.18.0
  -c, --check     Check if V2Ray can be updated
  -f, --force     Force installation of the latest version of V2Ray
  -h, --help      Show help
  -l, --local     Install V2Ray from a local file
  -p, --proxy     Download through a proxy server, e.g., -p http://127.0.0.1:8118 or -p socks5://127.0.0.1:1080
```

## 维护

请于 [develop](https://github.com/v2fly/fhs-install-v2ray/tree/develop) 分支进行，以避免对主分支造成破坏。

待确定无误后，两分支将进行合并。
