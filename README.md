<h2 align="center">

<p align="center"><img src="https://github.com/CalsRanna/source_parser/blob/main/asset/image/logo.png?raw=true" width="25%"></p>

元夕：定制化的网页内容解析与展示工具

</h2>

<p align="center">
<!-- <a href="https://github.com/CalsRanna/source_parser/actions"><img src="https://github.com/CalsRanna/source_parser/workflows/Flutter/badge.svg" alt="Build Status"></a> -->
<!-- <a href="https://codecov.io/gh/CalsRanna/source_parser"><img src="https://codecov.io/gh/CalsRanna/source_parser/master/graph/badge.svg" alt="codeCov"></a> -->
<a href="https://github.com/CalsRanna/source_parser/blob/main/LICENSE"><img src="https://img.shields.io/github/license/CalsRanna/source_parser" alt="License"></a>
<a href="https://github.com/Solido/awesome-flutter"><img src="https://awesome.re/mentioned-badge.svg" alt="Awesome Flutter"></a>
</p>

---

元夕是一款独特的手机应用，专为那些希望根据自定义规则解析网页内容的用户而设计。不仅如此，元夕还能够按照您设定的规则对解析后的代码进行精美排版，为您提供最佳的阅读体验。

🔍 您可以通过以下的屏幕截图进一步了解元夕。

<div align="center">

|               首页                |               发现                |
| :-------------------------------: | :-------------------------------: |
|    ![](/docs/images/books.png)    |  ![](/docs/images/discover.png)   |
|             书籍详情              |             小说阅读              |
| ![](/docs/images/book-detail.png) | ![](/docs/images/book-reader.png) |

</div>

## 💡 核心功能

✅ **自定义规则解析**：无论您希望如何解析网页，元夕都能满足您的需求。只需简单设置，即可轻松获取您想要的内容。

✅ **精美排版**：元夕不仅仅是一个解析工具，它还能够根据您的喜好对内容进行排版，确保您的阅读体验始终处于最佳状态。

✅ **书源数据库**：元夕内置了一个本地数据库，用于存储用户的自定义规则集合，方便您随时调用和分享。

✅ **阅读记录与进度存储**：无论您阅读到哪里，元夕都能为您保存当前的阅读进度，确保您下次打开时能够继续上次的阅读。

✅ **多设备同步（TODO）**：无论您使用哪台设备，元夕都能确保您的阅读进度和书源规则得到同步，让您的阅读体验更加流畅。

## 👩‍💻 书源编写

提供了两个示例书源： [https://raw.githubusercontent.com/CalsRanna/rule_sample/master/sources.json](https://raw.githubusercontent.com/CalsRanna/rule_sample/master/sources.json)

在 **书源管理——右上角——导入网络书源** 中导入即可，相关教程编写中

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
