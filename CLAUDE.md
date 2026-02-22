# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

元夕（source_parser）是一个 Flutter 多平台小说阅读应用，支持通过自定义 XPath/JSONPath 规则解析网页内容。支持 Android、iOS、macOS、Linux、Windows。

## 常用命令

```bash
# 运行应用
flutter run

# 构建
flutter build apk          # Android APK
flutter build appbundle     # Android AppBundle
flutter build ipa           # iOS
flutter build macos         # macOS
flutter build windows       # Windows

# 代码生成（路由等）
dart run build_runner build
dart run build_runner build --delete-conflicting-outputs  # 有冲突时使用

# 静态分析
flutter analyze

# 运行测试
flutter test
flutter test test/path/to/specific_test.dart  # 单个测试文件

# 获取依赖
flutter pub get
```

## 架构

### 分层结构

```
lib/
├── main.dart              # 入口：初始化 DI → 初始化数据库 → 运行应用
├── di.dart                # GetIt 依赖注入配置（所有 ViewModel 注册）
├── router/                # auto_route 路由（router.gr.dart 自动生成，勿手动编辑）
├── model/                 # 纯数据实体（*_entity.dart）
├── schema/                # 数据库持久化 schema
├── database/              # 数据访问层
│   ├── service.dart       # DatabaseService 单例，管理初始化和迁移
│   ├── migration/         # 增量迁移脚本
│   └── *_service.dart     # 各功能的 CRUD 服务
├── view_model/            # 全局 ViewModel（GetIt 单例）
├── page/                  # 按功能组织的页面模块
│   └── feature_name/
│       ├── feature_page.dart
│       └── feature_view_model.dart
├── component/             # 可复用 UI 组件
├── service/               # 业务服务（如 API 客户端）
└── util/                  # 工具函数（解析器、缓存、扩展等）
```

### 状态管理：GetIt + Signals

- **GetIt** 管理依赖注入，所有注册在 `lib/di.dart`
- **Signals** (`signal()`, `computed()`) 管理响应式状态
- 页面中使用 `Watch` widget 监听 signal 变化并重建 UI
- 全局 ViewModel（如 `AppBooksViewModel`、`AppThemeViewModel`）注册为 `LazySingleton`
- 页面级 ViewModel 注册为 `Factory`（每次获取新实例）或 `CachedFactory`

### 路由：auto_route

- 路由定义在 `lib/router/router.dart`，页面使用 `@RoutePage()` 注解
- `router.gr.dart` 由 build_runner 自动生成
- 新增页面后需运行 `dart run build_runner build`

### 数据库：SQLite + Laconic ORM

- `DatabaseService`（`lib/database/service.dart`）管理数据库生命周期
- 使用 `SqliteDriver` 显式初始化
- 迁移脚本在 `lib/database/migration/`，通过迁移表管理版本
- Schema 定义在 `lib/schema/`，数据操作在各 `*_service.dart`

### 核心解析引擎

- `lib/util/parser.dart` — 使用 Isolate 后台执行网页解析
- 支持 XPath（`xpath_selector`）和 JSONPath（`json_path`）
- `lib/util/html_parser_plus.dart` — HTML 解析增强
- `lib/util/cache_network.dart` — 网络请求缓存

### 页面模块约定

每个功能模块在 `lib/page/` 下有独立目录，包含：
- `*_page.dart` — UI 页面（StatefulWidget/StatelessWidget）
- `*_view_model.dart` — 页面 ViewModel（包含 signal 状态和业务逻辑）

### 关键依赖

| 库 | 用途 |
|---|---|
| signals | 响应式状态管理 |
| get_it | 依赖注入 |
| auto_route | 声明式路由 |
| laconic / laconic_sqlite | SQLite ORM |
| dio | HTTP 客户端 |
| xpath_selector / json_path | 网页内容解析 |
| cached_network_image | 图片缓存加载 |

## 注意事项

- `router.gr.dart` 是自动生成文件，不要手动修改
- 应用支持电子墨水屏模式（E-Ink），涉及禁用动画和涟漪效果的特殊处理
- 使用 Material 3 设计规范
