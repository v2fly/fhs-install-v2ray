# fhs-install-v2ray

# README अनुवाद / अनुवाद / अनुवाद / Translation

-   [पारंपरिक चीनी-README.md](README.md)
-   [सरलीकृत चीनी-README.zh-CN.md](README.zh-CN.md)
-   [अंग्रेजी-README.en.md](README.en.md)
-   [हिंदी-README.hi.md](README.hi.md)

# अवलोकन

f2-install-v2ray, v2ray के लिए एक स्वचालित इंस्टॉलेशन स्क्रिप्ट है, v2ray नेटवर्क प्रतिबंधों के लिए अपने स्वयं के प्रॉक्सी के निर्माण के लिए एक लोकप्रिय समाधान है

# समर्थित ऑपरेटिंग सिस्टम

प्रणाली:

-   डेबियन
-   Centos
-   फेडोरा
-   खुला हुआ

# ऑफ़लाइन स्थापना

नेटवर्क डाउनलोड प्रतिबंध वाले वातावरण में, हम अनुशंसा करते हैं:
1\. GitHub से ज़िप फ़ाइल के रूप में रिपॉजिटरी डाउनलोड करें।
2\. निम्नलिखित स्थान से v2ray-core ज़िप फ़ाइल डाउनलोड करें:
3\. दोनों ज़िप फ़ाइलों को अपने सर्वर पर अपलोड करें
4\. दो ज़िप फाइलों को अनज़िप करें
5\. स्थापना चलाएँ: ./install.sh --local /path/to/v2ray-core.zip

स्क्रिप्ट द्वारा स्थापित फाइलें इसके अनुरूप हैं[फाइलसिस्टम पदानुक्रम मानक (FHS)](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)：

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

## महत्वपूर्ण संकेत

**डॉकटर में v2ray को स्थापित करने के लिए इस परियोजना का उपयोग करने की अनुशंसा नहीं की गई है, कृपया इसे सीधे उपयोग करें[आधिकारिक छवि](https://github.com/v2fly/docker)。**  
यदि आधिकारिक छवि आपकी कस्टम स्थापना आवश्यकताओं को पूरा नहीं कर सकती है, तो कृपया**प्राप्त करने के लिए अपस्ट्रीम dockerfile को पुन: प्रस्तुत और संशोधित करें**。

इस प्रोजेक्ट**स्वचालित रूप से आपके लिए कॉन्फ़िगरेशन फ़ाइल उत्पन्न नहीं करेगा**；**केवल स्थापना के दौरान उपयोगकर्ताओं द्वारा सामना की जाने वाली समस्याओं का समाधान करें**। अन्य मुद्दों पर यहाँ मदद नहीं की जा सकती।  
स्थापना के बाद कृपया देखें[फ़ाइल](https://www.v2fly.org/)कॉन्फ़िगरेशन फ़ाइल सिंटैक्स को समझें, और अपने लिए उपयुक्त कॉन्फ़िगरेशन फ़ाइल को पूरा करें। आप प्रक्रिया के दौरान सामुदायिक योगदान का उल्लेख कर सकते हैं[कॉन्फ़िगरेशन प्रोफ़ाइल टेम्पलेट](https://github.com/v2fly/v2ray-examples)  
（**कृपया ध्यान दें कि इन टेम्प्लेट को कॉपी किए जाने के बाद स्वयं द्वारा संशोधित और समायोजित करने की आवश्यकता होती है, और सीधे उपयोग नहीं किया जा सकता**）

## उपयोग

-   स्क्रिप्ट प्रदान करेगा`info`साथ में`error`कृपया इसे ध्यान से पढ़ें।

### स्थापित करें और V2Ray को अपडेट करें

    // 安裝執行檔和 .dat 資料檔
    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

### नवीनतम geoip.dat और geosite.dat स्थापित करें

    // 只更新 .dat 資料檔
    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)

### V2Ray निकालें

    # bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove

### समस्या का समाधान

-   「[Geoip.dat और geosite.dat इंस्टॉल या अपडेट न करें](https://github.com/v2fly/fhs-install-v2ray/wiki/Do-not-install-or-update-geoip.dat-and-geosite.dat)」。
-   「[प्रमाण पत्र का उपयोग करते समय अपर्याप्त अनुमति](https://github.com/v2fly/fhs-install-v2ray/wiki/Insufficient-permissions-when-using-certificates)」。
-   「[पुरानी स्क्रिप्ट से इसे माइग्रेट करें](https://github.com/v2fly/fhs-install-v2ray/wiki/Migrate-from-the-old-script-to-this)」。
-   「[निर्देशिका साझा करने के लिए lib निर्देशिका से .dat फ़ाइलों को स्थानांतरित करें](https://github.com/v2fly/fhs-install-v2ray/wiki/Move-.dat-files-from-lib-directory-to-share-directory)」。
-   「[वीएलएसई प्रोटोकॉल का उपयोग करें](https://github.com/v2fly/fhs-install-v2ray/wiki/To-use-the-VLESS-protocol)」。

> यदि आपका प्रश्न ऊपर सूचीबद्ध नहीं है, तो इसे मुद्दे क्षेत्र में बढ़ाने के लिए स्वागत करें।

**कृपया प्रश्न पूछने से पहले पढ़ें[अंक # 63](https://github.com/v2fly/fhs-install-v2ray/issues/63), अन्यथा इसका जवाब नहीं दिया जा सकता है और लॉक नहीं किया जा सकता है।**

## योगदान

कृप्या[विकसित करना](https://github.com/v2fly/fhs-install-v2ray/tree/develop)मुख्य शाखा को नुकसान से बचने के लिए शाखा।

पुष्टि के बाद, दोनों शाखाओं को मिला दिया जाएगा।
