# fhs-install-v2ray

> Bash script for installing V2Ray in operating systems such as Debian / CentOS / Fedora / openSUSE that support systemd

該腳本安裝的文件符合 Filesystem Hierarchy Standard（FHS）：

https://wiki.linuxfoundation.org/lsb/fhs

```
installed: /usr/local/bin/v2ray
installed: /usr/local/bin/v2ctl
installed: /usr/local/lib/v2ray/geoip.dat
installed: /usr/local/lib/v2ray/geosite.dat
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
installed: /etc/systemd/system/v2ray.service
installed: /etc/systemd/system/v2ray@.service
```

## 依賴軟體

### 安裝 cURL

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

## 下載

```
# curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
# curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh
```

## 使用

* 該腳本在執行時會提供 `info` 和 `error` 等信息，請仔細閱讀。

### 安裝和更新 V2Ray

```
# bash install-release.sh
```

### 安裝最新發行的 geoip.dat 和 geosite.dat

```
# bash install-dat-release.sh
```

### 移除 V2Ray

```
# bash install-release.sh --remove
```

### 證書權限問題

假設，這書文件所在的路徑為 `/srv/http/`。

文件分別為 `/srv/http/example.com.key` 和 `/srv/http/example.com.pem`。

方案一：

`/srv/http/` 的默認權限一般為 755；
`/srv/http/example.com.key` 的默認權限一般為 600；
`/srv/http/example.com.pem` 的默認權限一般為 644。

將 `/srv/http/example.com.key` 修改為 644 即可：

```
# chmod 644 /srv/http/example.com.key
```

方案二：

```
# id nobody
```

執行後，显示出来的结果可能是：

```
uid=65534(nobody) gid=65534(nogroup) groups=65534(nogroup)
```

相应的，只需要执行：

```
# chown -R nobody:nogroup /srv/http/
```

不過，显示出来的结果也可能是：

```
uid=65534(nobody) gid=65534(nobody) groups=65534(nobody)
```

相应的，只需要执行：

```
# chown -R nobody:nobody /srv/http/
```

## 參數

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

## 維護

請於 [develop](https://github.com/v2fly/fhs-install-v2ray/tree/develop) 分支進行，以避免對主分支造成破壞。

待確定無誤後，兩分支將進行合併。
