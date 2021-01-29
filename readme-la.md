# FHS-install v2ray,

> Ut videre simplicior introductio in Chinese, quaeso vide:[README.zh-Hans-CN.md](README.zh-Hans-CN.md)

> Pagina scriptor operating systems enim installing in V2Ray ut debian / CentOS / Fedora / Quod subsidium openSUSE systemd

Et installed per litteras configurati prioribus files[Latin filesystem Hierarchiae (FHS)](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard);

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

## magna admonitus

**Id non commendatur uti in Docker v2ray institutionem, directe commodo[publica imago](https://github.com/v2fly/docker).**  
Si publica imaginem non vestram in occursum mos postulo installation, obsecro,**Et modify reproductionis qui stabat super aquas fluminis usque ad consequi dockerfile**.

Hoc project**Non enim statim generate configuratione files**;**Tantum users solvere durante installation negotiorum quae sollicitant**. Aliis rebus potest, hic nihil habebis prosperum.  
Post placere ad institutionem[lima](https://www.v2fly.org/)Intelligas file syntaxis figura et figura completa lima apta tibi. Et tunc temporis recurratur ad civitatem processus per contributions[Configurationis profile Template](https://github.com/v2fly/v2ray-examples)  
(**提請您注意這些模板複製下來以後是需要您自己修改調整的，不能直接使用**)

## usus

-   Scriptum providebit`info`apud`error`Placere legit illud diligenter.

### Quod install update V2Ray

    // 安裝執行檔和 .dat 資料檔
    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

### Et tardus ad install geoip.dat geosite.dat

    // 只更新 .dat 資料檔
    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)

### Remove V2Ray

    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove

### Solvere problema

-   「[Et non install vel update geoip.dat geosite.dat](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and-geosite.dat)」.
-   「[Cum satis permissions per literas testimoniales](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates)」.
-   「[Profugus ab antiquissima litera legitur huic](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this)」.
-   「[Movere ad participes .dat files ex lib Directory Directory](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share-directory)」.
-   「[Protocol usus VLESS](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol)」.

> Si vero non supra suscipe eventu excitat elit.

**Placere legit coram interrogantem[# Exitus LXIII](https://github.com/v2fly/fhs-install-v2ray/issues/63), Et clausum Alioquin ut non respondit.**

## conlationem

placere[develop](https://github.com/v2fly/fhs-install-v2ray/tree/develop)Ad vitare damnum est de propagatione diffundi pelagus genere ferri.

Deinde confirmatio, non duo rami confusa sint.
