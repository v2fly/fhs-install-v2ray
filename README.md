# fhs-install-v2ray

> 該腳本安裝的文件符合 [Filesystem Hierarchy Standard（FHS）](https://wiki.linuxfoundation.org/lsb/fhs)。

```
installed: /usr/local/bin/v2ray -> ../lib/v2ray/v2ray
installed: /usr/local/bin/v2ctl -> ../lib/v2ray/v2ctl
installed: /usr/local/lib/v2ray/v2ray
installed: /usr/local/lib/v2ray/v2ctl
installed: /usr/local/lib/v2ray/geoip.dat
installed: /usr/local/lib/v2ray/geosite.dat
installed: /usr/local/etc/v2ray/config.json
installed: /var/log/v2ray/
installed: /etc/systemd/system/v2ray.service
installed: /etc/systemd/system/v2ray@.service
```

## 依賴軟體

### 安裝 cURL

```
# apt install curl
```

or

```
# yum install curl
```

or

```
# zypper install curl
```

## 下載

```
# curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
```

## 使用

* 該腳本在執行時會提供 `info` 和 `error` 等信息，請仔細閱讀。

### 安裝和更新 V2Ray

```
# bash install-release.sh
```

### 移除 V2Ray

```
# bash install-release.sh --remove
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
