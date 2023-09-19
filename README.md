<p align="center">
  <img
    src="https://github.com/CalsRanna/source_parser/blob/main/asset/image/logo.jpg?raw=true"
    width="15%"/>
  <img
    src="https://github.com/CalsRanna/source_parser/blob/main/asset/image/name.jpg?raw=true"
    width="15%"/>
</p>

<h2 align="center">元夕：定制化的网页内容解析与展示工具</h2>

<p align="center">
<!-- <a href="https://github.com/CalsRanna/source_parser/actions"><img src="https://github.com/CalsRanna/source_parser/workflows/Flutter/badge.svg" alt="Build Status"></a> -->
<!-- <a href="https://codecov.io/gh/CalsRanna/source_parser"><img src="https://codecov.io/gh/CalsRanna/source_parser/master/graph/badge.svg" alt="codeCov"></a> -->
<a href="https://github.com/CalsRanna/source_parser/blob/main/LICENSE"><img src="https://img.shields.io/github/license/CalsRanna/source_parser" alt="License"></a>
<a href="https://github.com/Solido/awesome-flutter"><img src="https://awesome.re/mentioned-badge.svg" alt="Awesome Flutter"></a>
</p>

元夕专为希望根据自定义规则解析网页内容的用户而设计。

🌟 非商业性质项目，欢迎提交 issue 及 Pr 一起完善！

🔍 您可以通过以下的屏幕截图进一步了解元夕。

<div align="center">

|               首页                |               发现                |
| :-------------------------------: | :-------------------------------: |
|    ![](/docs/images/books.jpg)    |  ![](/docs/images/discover.jpg)   |
|             书籍详情              |             小说阅读              |
| ![](/docs/images/book-detail.jpg) | ![](/docs/images/book-reader.jpg) |

</div>

## 💡 核心功能

✅ **自定义规则解析**：支持 XPath 和 JSONPath 解析，并提供了一些管道函数。能基本满足大部分网页解析需求。

✅ **阅读设置**：目前支持行间距、字号以及背景主题设置。

✅ **夜间模式**：支持夜间模式，保护眼睛 👀 人人有责。

✅ **书源数据库**：基于 [Isar](https://github.com/isar/isar) 的本地数据库，存储书籍、书源规则及设置项，随时调用和分享。

✅ **缓存与阅读进度**：支持将内容缓存，并自动保存当前阅读进度，确保下次打开时能够继续阅读。

⬜ **多设备云同步**：基于各种第三方同步工具或协议，确保书籍、阅读进度和书源规则等同步到云端，多设备共享。

##  TestFlight

> 仅有**10000**个名额，先到先得

[点击进入 TestFlight 内测](https://testflight.apple.com/join/eVmnwilc)

## 👩‍💻 书源编写

提供了一个示例网络书源： [https://raw.githubusercontent.com/CalsRanna/rule_sample/master/sources.json](https://raw.githubusercontent.com/CalsRanna/rule_sample/master/sources.json)

在 **书源管理——右上角——导入网络书源** 中导入即可（请提前科学上网），相关教程编写中

## 🔗 基础组件

- [CalsRanna/book_reader](https://github.com/CalsRanna/book_reader)： 小说阅读器核心组件
- [CalsRanna/html_parser_plus](https://github.com/CalsRanna/html_parser_plus)： 用于书源解析,支持 xPath 和 jsonPath 语法，通过管道连接自定义函数

## 🔧 Building

### Android

Traditional APK

```bash
flutter build apk
```

AppBundle for Google Play

```bash
flutter build appbundle
```

### iOS

```bash
flutter build ipa
```
