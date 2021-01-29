# fhs-install-v2ray

# README 翻譯/翻译/Translation/अनुवाद
- [繁體中文 - README.md](README.md)
- [簡體中文 - README.zh-CN.md](README.zh-CN.md)
- [英語 - README.en.md](README.en.md)
- [印地語 - README.hi.md](README.hi.md)

# 總覽
fhs-install-v2ray是v2ray的自動安裝腳本，v2ray是一種流行的解決方案，用於構建您自己的代理以繞過網絡限制

# 支持的操作系統
Systemd:
- Debian
- CentOS
- Fedora
- openSUSE 

# 離線安裝
在具有網絡下載限制的環境中，我們建議：
1.從GitHub下載該存儲庫作為zip文件。
2.從以下位置下載v2ray-core zip文件：
3.將兩個zip文件都上傳到您的服務器
4.解壓縮兩個zip文件
5.運行安裝：./install.sh --local /path/to/v2ray-core.zip

該腳本安裝的文件符合 [Filesystem Hierarchy Standard (FHS)](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)：

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

**不推薦在 docker 中使用本專案安裝 v2ray，請直接使用 [官方映象](https://github.com/v2fly/docker)。**  
如果官方映象不能滿足您自定義安裝的需要，請以**復刻並修改上游 dockerfile 的方式來實現**。  

本專案**不會為您自動生成配置檔案**；**只解決使用者安裝階段遇到的問題**。其他問題在這裡是無法得到幫助的。  
請在安裝完成後參閱 [文件](https://www.v2fly.org/) 瞭解配置檔案語法，並自己完成適合自己的配置檔案。過程中可參閱社群貢獻的 [配置檔案模板](https://github.com/v2fly/v2ray-examples)  
（**提請您注意這些模板複製下來以後是需要您自己修改調整的，不能直接使用**）

## 使用

* 該腳本在執行時會提供 `info` 和 `error` 等信息，請仔細閱讀。

### 安裝和更新 V2Ray

```
// 安裝執行檔和 .dat 資料檔
# bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)
```

### 安裝最新發行的 geoip.dat 和 geosite.dat

```
// 只更新 .dat 資料檔
# bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)
```

### 移除 V2Ray

```
# bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove
```

### 解決問題

* 「[不安裝或更新 geoip.dat 和 geosite.dat](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and-geosite.dat)」。
* 「[使用證書時權限不足](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates)」。
* 「[從舊腳本遷移至此](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this)」。
* 「[將 .dat 文檔由 lib 目錄移動到 share 目錄](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share-directory)」。
* 「[使用 VLESS 協議](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol)」。

> 若您的問題沒有在上方列出，歡迎在 Issue 區提出。

**提問前請先閱讀 [Issue #63](https://github.com/v2fly/fhs-install-v2ray/issues/63)，否則可能無法得到解答並被鎖定。**

## 貢獻

請於 [develop](https://github.com/v2fly/fhs-install-v2ray/tree/develop) 分支進行，以避免對主分支造成破壞。

待確定無誤後，兩分支將進行合併。
