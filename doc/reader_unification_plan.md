# 阅读器统一重构方案

## 1. 目标

将当前“本地阅读器”和“云端阅读器”统一成一个阅读器 Feature，同时满足以下目标：

- 只有一个真正统一的阅读器组件 `ReaderView`
- 只有一套真正统一的阅读器控制器 `ReaderController`
- 阅读器组件内部不直接依赖数据库、云 API、路由、弹窗、GetIt
- 本地和云端的差异只体现在数据来源和外层操作配置
- 分页、渲染、翻页、选择等核心逻辑继续共用
- 保持 Flutter 风格命名，不引入不符合项目语境的架构术语

## 2. 当前现状

当前项目已经共享了阅读核心的一部分，但还没有统一成一个完整的阅读器。

### 2.1 已共享的部分

当前这些能力已经在共享层：

- `lib/component/reader/reader_view.dart`
- `lib/component/reader/reader_content_view.dart`
- `lib/component/reader/reader_view_model_mixin.dart`
- `lib/component/reader/page_turn/*`
- `lib/component/reader/layout/*`

这些代码已经承担了：

- 分页
- 正文渲染
- 翻页控制
- 选择模式
- 页码和章节偏移计算
- 前后章节预加载

### 2.2 仍然分裂的部分

当前本地和云端仍各有一套路由页和外层逻辑：

- 本地
  - `lib/page/reader/reader_page.dart`
  - `lib/page/reader/reader_view_model.dart`
- 云端
  - `lib/page/cloud_reader/cloud_reader_reader_page.dart`
  - `lib/page/cloud_reader/cloud_reader_reader_view_model.dart`

这两套实现里存在明显重复：

- 页面结构高度相似
- `initSignals()` 初始化流程几乎一致
- 目录跳转后的章节切换流程一致
- 切源/刷新/保存进度等外层业务与阅读核心混在一起

### 2.3 当前最大问题

最大问题不是“代码没共用”，而是“边界没划清”。

当前共享层仍然直接或间接依赖外部业务：

- `BookService`
- `CloudBookService`
- `CloudReaderApiClient`
- `DialogUtil`
- `GetIt`
- 路由页面

这导致：

- 阅读器组件看起来共享了，但实际上不能独立复用
- 本地和云端阅读控制逻辑都变得很大
- 业务行为和阅读核心状态强耦合
- 后续如果再加第三种阅读来源，仍会继续复制一套宿主逻辑

## 3. 重构目标结构

建议将阅读器整理为以下结构。

### 3.1 统一后的组件

保留一个真正统一的组件：

- `ReaderView`

职责：

- 承载阅读器 UI
- 接收一个统一的 `ReaderController`
- 接收 overlay/actions 配置
- 不直接区分本地还是云端

路由页不必强行消失。

更符合 Flutter 的做法是：

- 本地仍可保留 `ReaderPage`
- 云端仍可保留 `CloudReaderReaderPage`

但它们最终都只是宿主壳子，只负责：

- 构造 `ReaderController`
- 提供 `ReaderDelegate`
- 提供 `ReaderOverlayConfig`
- 承载统一的 `ReaderView`

### 3.2 统一后的控制器

保留一个真正统一的：

- `ReaderController`

职责：

- 管理阅读器内部状态
- 驱动分页、翻页、选择、预加载
- 与抽象宿主委托通信
- 对 `ReaderView` 暴露统一接口

不再继续让“本地控制逻辑 / 云端控制逻辑”各自持有一份阅读核心。

### 3.3 差异抽象为宿主委托

新增：

- `ReaderDelegate`
- `LocalReaderDelegate`
- `CloudReaderDelegate`

职责：

- 提供章节列表
- 提供章节标题
- 提供章节正文
- 提供阅读进度读写
- 提供切源、刷新、缓存等宿主能力

阅读器核心只认识 `ReaderDelegate`，不认识本地数据库或云 API。

### 3.4 差异抽象为外层操作配置

新增：

- `ReaderOverlayConfig`
- `ReaderAction`

职责：

- 描述阅读器顶部/底部/悬浮操作项
- 将“目录、缓存、换源、替换规则、刷新”等动作配置化
- 允许本地和云端展示不同操作，但阅读器本体不关心动作来源

## 4. 推荐命名

采用符合 Flutter 和当前项目风格的命名：

- `ReaderView`
- `ReaderController`
- `ReaderDelegate`
- `LocalReaderDelegate`
- `CloudReaderDelegate`
- `ReaderOverlayConfig`
- `ReaderAction`
- `ReaderState`（可选，仅在确实需要时引入）

不建议使用：

- `Screen`
- `SessionController`
- `Port`

这些命名不符合当前项目语境，也不符合 Flutter 项目里最自然的命名习惯。

## 5. 职责划分

### 5.1 `ReaderView`

保留在组件层，职责是：

- `LayoutBuilder` 获取真实约束
- 渲染正文和翻页容器
- 接收并展示 overlay 配置
- 将用户交互事件转发给 `ReaderController`

不负责：

- 数据库访问
- API 请求
- 章节内容拼装
- 进度保存细节
- 路由跳转
- 页面级生命周期管理

### 5.2 `ReaderController`

负责：

- 当前章节索引
- 当前页索引
- 当前章/前一章/后一章 layout
- 选择模式
- overlay 显示状态
- 翻页和章节轮转
- 分页缓存
- 视口变更后的重排

只依赖：

- `ReaderDelegate`
- `PageTurnController`
- 共享的分页与渲染组件

不直接依赖：

- `GetIt`
- `DialogUtil`
- `BookService`
- `CloudBookService`
- `CloudReaderApiClient`
- 路由类

### 5.3 路由宿主页

本地和云端的路由页可以继续存在：

- `ReaderPage`
- `CloudReaderReaderPage`

但它们应该只承担宿主职责：

- 从外部依赖中创建 `ReaderDelegate`
- 构造 `ReaderController`
- 传入本地或云端各自的 `ReaderOverlayConfig`
- 处理必要的页面级生命周期

它们不应该再承载大量阅读核心状态。

### 5.4 `ReaderDelegate`

`ReaderDelegate` 的职责应该是“向阅读器提供宿主能力”，而不是把阅读器自己的状态也塞回宿主。

因此最终目标接口不建议继续暴露：

- `currentChapterIndex`
- `currentPageIndex`
- `totalChapterCount`

这些状态应该由 `ReaderController` 在初始化后自行持有。

更合理的方向是让 delegate 提供：

- 初始阅读位置
- 章节列表
- 章节名称
- 章节正文
- 进度保存
- 宿主特有能力

建议目标接口如下：

```dart
class ReaderInitialState<TChapter> {
  final String bookName;
  final List<TChapter> chapters;
  final int initialChapterIndex;
  final int initialPageIndex;

  const ReaderInitialState({
    required this.bookName,
    required this.chapters,
    required this.initialChapterIndex,
    required this.initialPageIndex,
  });
}

abstract class ReaderDelegate<TChapter> {
  Future<ReaderInitialState<TChapter>> loadInitialState();

  String getChapterName(int index);

  Future<String> fetchContent(int chapterIndex, {bool reacquire = false});

  Future<void> saveProgress({
    required int chapterIndex,
    required int pageIndex,
  });
}
```

如果为了降低第一阶段迁移成本，也可以暂时保留更接近当前项目的接口，然后在第二阶段统一 `ReaderController` 时再收敛成上面这套目标接口。

如果宿主能力较多，可以继续按职责拆小：

- `ReaderContentDelegate`
- `ReaderProgressDelegate`
- `ReaderCatalogueDelegate`

但第一阶段不必拆得太细，先保证整体结构清晰。

### 5.5 `ReaderOverlayConfig`

建议结构：

```dart
class ReaderOverlayConfig {
  final List<ReaderAction> topActions;
  final List<ReaderAction> bottomActions;
  final ReaderAction? floatingAction;

  const ReaderOverlayConfig({
    this.topActions = const [],
    this.bottomActions = const [],
    this.floatingAction,
  });
}

class ReaderAction {
  final String id;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ReaderAction({
    required this.id,
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
```

本地阅读器和云端阅读器只负责传不同配置：

- 本地可有：缓存、替换规则、可用书源
- 云端可有：目录、刷新、换源

阅读器本体只负责展示这些操作，不负责解释这些业务。

## 6. 建议目录结构

建议整理为：

```text
lib/component/reader/
  reader_view.dart
  reader_controller.dart
  reader_content_view.dart
  reader_overlay.dart
  reader_overlay_config.dart
  reader_state.dart
  reader_delegate.dart
  page_turn/
  layout/

lib/page/reader/
  reader_page.dart
  local_reader_delegate.dart
  local_reader_overlay_builder.dart

lib/page/cloud_reader/
  cloud_reader_reader_page.dart
  cloud_reader_delegate.dart
  cloud_reader_overlay_builder.dart
```

如果不想移动太多文件，也可以先保持原路径，只先抽接口和统一组件，再逐步整理目录。

## 7. 迁移方案

推荐按四步做，不要一次性大改。

### 第一阶段：抽 `ReaderDelegate`

目标：

- 不改页面结构
- 先把本地和云端 VM 中“获取正文、目录、保存进度”抽成宿主委托

产物：

- `ReaderDelegate`
- `LocalReaderDelegate`
- `CloudReaderDelegate`

结果：

- 阅读器核心不再直接碰本地数据库和云 API

### 第二阶段：抽统一 `ReaderController`

目标：

- 将 `ReaderViewModelMixin` 升级为真正的 `ReaderController`
- 本地和云端的阅读核心逻辑不再分别挂在两个宿主 VM 上

做法：

- 新的 `ReaderController` 构造时注入 `ReaderDelegate`
- 将当前 mixin 中共享逻辑搬进去
- 原本地/云端 VM 只保留宿主特有行为，逐步缩薄

结果：

- 阅读核心只有一套状态管理

### 第三阶段：统一 `ReaderView`

目标：

- 路由页继续保留，但内部都改成承载同一个 `ReaderView`

做法：

- 组件接收 `ReaderController`
- 组件接收 `ReaderOverlayConfig`
- 本地和云端只提供不同的 `delegate + overlayConfig`

结果：

- 阅读器组件结构只保留一套
- 宿主页面只负责装配，不再承载阅读核心逻辑

### 第四阶段：裁剪旧宿主 VM

目标：

- 清掉旧的重复 VM
- 本地和云端只保留宿主委托和宿主动作构造

做法：

- 将原 `ReaderViewModel` / `CloudReaderReaderViewModel` 中仍然属于阅读核心的逻辑继续迁出
- 将只属于宿主的行为保留在 delegate 或 overlay builder

结果：

- 本地和云端只剩差异
- 阅读器本体成为独立 feature

## 8. 第一版可以接受的妥协

为了控制重构风险，第一版允许保留以下妥协：

- `ReaderController` 仍暂时通过 `GetIt` 获取少量全局对象，例如主题或系统状态
- overlay 的动作回调先直接从宿主传入
- 本地和云端路由仍然各自存在，但最终都只是构造同一个 `ReaderView`

也就是说，第一版的目标不是“绝对纯净”，而是：

- 先把阅读器从本地/云端业务里解耦出来
- 先把数据来源和 UI 壳子统一

## 9. 验收标准

完成重构后，至少应满足：

- 本地和云端都使用同一个 `ReaderView`
- 本地和云端都使用同一个 `ReaderController`
- 阅读器核心不直接依赖本地数据库或云 API
- 分页、翻页、选择逻辑只有一份实现
- overlay 支持宿主差异配置
- 进度保存、目录跳转、刷新、切源仍然工作正常

## 10. 当前文件的建议去留

### 保留并继续复用

- `lib/component/reader/reader_view.dart`
- `lib/component/reader/reader_content_view.dart`
- `lib/component/reader/page_turn/*`
- `lib/component/reader/layout/*`

### 应重构或重命名

- `lib/component/reader/reader_view_model_mixin.dart`
  - 建议演进为统一的 `ReaderController`

### 最终应被吸收或删除

- `lib/page/reader/reader_view_model.dart`
- `lib/page/cloud_reader/cloud_reader_reader_view_model.dart`

它们应当被吸收到统一的 `ReaderController` 或宿主委托中。

### 最终应被缩薄并继续保留

- `lib/page/reader/reader_page.dart`
- `lib/page/cloud_reader/cloud_reader_reader_page.dart`

这两个路由页不一定需要删除。更合理的目标是把它们缩成宿主壳子，只负责装配：

- `ReaderDelegate`
- `ReaderOverlayConfig`
- `ReaderView`

## 11. 推荐实施顺序

最稳妥的顺序是：

1. 先抽 `ReaderDelegate`
2. 再把 mixin 收成统一 `ReaderController`
3. 再统一 `ReaderView`
4. 最后清理旧 VM 和旧页面

这样可以保证：

- 每一步都可运行
- 每一步都容易回滚
- 不会在一个提交里同时改页面、状态、宿主委托、路由

## 12. 结论

当前项目完全可以统一为一个阅读器，而且应该统一。

真正需要重构的不是分页组件，而是阅读器与宿主业务的边界。

本地和云端的差异，本质上只是：

- 数据从哪里来
- 进度写到哪里
- overlay 上显示哪些动作

这些差异都不应该继续长在阅读器核心内部。

统一后的正确形态应当是：

- 一个 `ReaderView`
- 一个 `ReaderController`
- 多个 `ReaderDelegate`
- 多套 `ReaderOverlayConfig`

其中：

- `ReaderView` 负责组件渲染和交互分发
- `ReaderController` 负责阅读核心状态
- `ReaderDelegate` 负责宿主能力
- 路由页只负责装配

这样阅读器才会真正具备高内聚、低耦合和后续可维护性。
