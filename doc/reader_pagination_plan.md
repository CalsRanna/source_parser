# 阅读器分页一致性改造方案

## 1. 目标

本方案用于解决当前阅读器在“已经分页后，正文区域仍可垂直滚动”的问题，并满足以下约束：

- 章节内容必须一次性分页，以便立即得到页数并展示页码。
- 正文展示区域必须严格等于“屏幕减去 header、footer 和正文 padding 后的可用区域”。
- 常规阅读态不允许正文垂直滚动。
- 需要保留文本选择能力。
- 本地阅读器和云端阅读器必须共用同一套分页和渲染机制。

## 2. 当前问题的根因

当前实现存在三类根因，叠加后导致分页和真实显示不一致。

### 2.1 分页引擎和正文渲染引擎不是同一套

当前分页在 `lib/util/splitter.dart` 中通过 `TextPainter` 测量。

当前正文渲染之前使用 `SelectableText.rich`，现在临时改为 `RichText`。

这意味着：

- 分页时走的是 `TextPainter` 布局。
- 渲染时走的是 `SelectableText` 或 `RichText` 对应的渲染路径。
- 如果布局参数、选择系统、内部滚动行为或渲染约束存在差异，就会出现“算出来是一页，渲染出来还有一点点可滚动空间”的问题。

### 2.2 正文区域尺寸是估算值，不是真实约束

当前正文分页尺寸在 `ReaderViewModelMixin.initSize()` 中用公式计算：

- `screenSize`
- 减去正文 padding
- 减去 header padding 和单行高度
- 减去 footer padding 和单行高度

这里的问题是：

- `screenSize` 是全局尺寸，不是阅读器正文容器的真实约束。
- header 当前真实渲染可能换行，而分页时只按单行估算。
- 如果未来有安全区、状态栏、窗口大小变化、系统字体缩放、不同平台字体回退，公式值都可能和真实布局偏离。

### 2.3 当前分页算法不是“整章一次布局，再按行切页”

当前 `Splitter` 是从剩余字符串起点反复执行：

1. 截取剩余文本
2. 重新 layout
3. 累加 line metrics
4. 找到页末 offset
5. 再对子串重复一次

这样的问题是：

- 复杂度偏高，章节越长越慢。
- 每页都基于剩余子串重新 layout，不是同一个完整段落的稳定行结果。
- 第一页标题依赖额外插入换行标记，逻辑不够稳定。

## 3. 业界更常见的分页思路

阅读器的常见做法不是“实时滚动布局”，而是：

1. 确定一个稳定的正文视口矩形。
2. 使用文本布局引擎对整章内容做一次完整 layout。
3. 根据行高和页高计算分页断点。
4. 将每页记录为字符范围或段落范围。
5. 渲染时使用同一套文本样式和同一套布局参数。
6. 选择能力独立于分页能力，不让正文本身变成滚动容器。

落到 Flutter 上，推荐做法是：

- 分页：`TextPainter` 或 `dart:ui.Paragraph`
- 渲染：`RichText`
- 选择：`SelectionArea` / `SelectableRegion`

不推荐把分页正文直接建立在 `SelectableText.rich` 之上，因为它更适合“可选择文本控件”，不适合“固定页框、不可垂直滚动的书页正文”。

## 4. 推荐方案

推荐采用以下架构：

- 一次性分页继续保留
- 分页引擎改为“整章一次 layout，再按行切页”
- 正文渲染统一为 `RichText`
- 选择能力改为 `SelectionArea + RichText`
- 分页尺寸改为“真实正文视口尺寸”

这是当前项目中工程复杂度、稳定性、可维护性最平衡的方案。

## 5. 架构设计

### 5.1 新增核心对象

建议新增以下对象。

#### `ReaderViewport`

表示分页使用的真实正文视口。

建议字段：

- `Size pageSize`
- `double contentWidth`
- `double contentHeight`
- `double headerHeight`
- `double footerHeight`
- `EdgeInsets contentPadding`
- `EdgeInsets headerPadding`
- `EdgeInsets footerPadding`

作用：

- 作为分页输入的唯一尺寸来源。
- 替代当前 `initSize()` 里的公式型全局估算。

#### `ReaderLayoutConfig`

表示会影响文本布局的所有参数。

建议字段：

- `TextDirection textDirection`
- `TextScaler textScaler`
- `Locale? locale`
- `StrutStyle? strutStyle`
- `TextWidthBasis textWidthBasis`
- `TextHeightBehavior? textHeightBehavior`
- 主题相关字体和间距参数
- `bool showChapterTitleOnFirstPage`

作用：

- 保证分页和渲染使用完全一致的布局参数。
- 作为缓存 key 的一部分。

#### `ReaderPageRange`

表示一页正文对应的字符范围。

建议字段：

- `int start`
- `int end`
- `bool isFirstPage`

作用：

- 不再把每页直接存成字符串。
- 分页结果以范围形式保存，更稳定，也便于后续选择、标注、摘录等功能扩展。

#### `ChapterLayoutResult`

表示整章分页结果。

建议字段：

- `String fullText`
- `InlineSpan fullSpan`
- `List<ReaderPageRange> pages`
- `ReaderViewport viewport`
- `ReaderLayoutConfig config`

作用：

- 一次完整 layout 后缓存到内存。
- 当前页渲染时按 `pages[index]` 提取子范围生成页面内容。

### 5.2 分页引擎

建议新增：

- `lib/component/reader/layout/chapter_paginator.dart`

职责：

- 输入完整章节文本、布局配置、正文视口
- 输出 `ChapterLayoutResult`

推荐算法：

1. 构建整章统一 `InlineSpan`
2. 用同一个 `TextPainter` 对整章做一次 layout
3. 调用 `computeLineMetrics()` 获取所有行
4. 按行高累加，计算每页能容纳的最后一行
5. 通过 `getPositionForOffset()` 或行边界方法得到该页字符终点
6. 输出每页 `ReaderPageRange`

关键点：

- 不再对子串反复 layout。
- 第一页是否显示章节标题，不再通过字符串前面塞一个哨兵换行来控制，而是通过 `ReaderPageRange.isFirstPage` 和统一 span 构造逻辑控制。

### 5.3 正文渲染

正文统一使用 `RichText`。

建议新增：

- `ReaderPageTextBuilder`

职责：

- 基于 `ChapterLayoutResult` 和 `ReaderPageRange`
- 构造当前页的 `InlineSpan`

要求：

- 生成 span 的规则必须和分页测量使用的规则完全一致。
- 不允许正文内部出现任何 `Scrollable`。
- 不允许用 `SelectableText.rich` 作为书页正文渲染器。

### 5.4 文本选择

推荐使用：

- `SelectionArea`
- `RichText.selectionRegistrar`

建议交互模式改成“两态”。

#### 阅读模式

- 点击区域翻页
- 左右拖拽翻页
- 正文不可滚动
- 不处理文字选择拖动

#### 选择模式

- 通过长按正文进入
- 或通过 overlay 中的“选择文本”按钮进入
- 进入后暂停翻页手势
- 当前页正文使用 `SelectionArea`
- 退出选择模式后恢复翻页手势

这样做的原因是：

- 阅读翻页和文本拖拽选择是天然冲突的手势。
- 业界常见处理也是将“阅读态”和“选择态”区分开，而不是让两者始终抢同一组拖拽事件。

### 5.5 header 和 footer

header、footer 必须和分页尺寸计算策略保持一致。

推荐二选一。

#### 方案 A：固定单行

- header 固定 `maxLines = 1`
- footer 固定单行
- 分页时按单行高度计算

优点：

- 实现最简单
- 稳定

缺点：

- 长章节名会省略

#### 方案 B：真实测量

- 先用与渲染一致的 `TextPainter` 测量 header 和 footer 高度
- 再计算正文真实可用高度

优点：

- 更准确

缺点：

- 实现复杂度更高

当前项目建议先落地方案 A。后续如果对长标题显示有更高要求，再升级到方案 B。

## 6. 为什么不推荐继续使用 `SelectableText.rich`

原因不是样式配不齐，而是角色不对。

`SelectableText.rich` 适合：

- 普通页面中的可复制文本
- 长文详情页
- 文本选择优先的内容展示

它不适合：

- 固定页框分页阅读
- 需要严格禁止纵向滚动
- 需要和自定义翻页手势共存

阅读器书页正文更适合：

- `RichText` 负责绘制
- `SelectionArea` 负责选择

## 7. 实施步骤

### 第一阶段：统一尺寸来源

目标：

- 用真实正文视口替代 `screenSize + 公式估算`

步骤：

1. 在 `ReaderView` 或 `ReaderContentView` 外层加入 `LayoutBuilder`
2. 计算真实页面大小
3. 测量 header/footer 占位
4. 生成 `ReaderViewport`
5. 当 viewport 变化时，触发重新分页

完成标准：

- 旋转屏幕、窗口变化、主题变化时，页数会重新计算
- 分页结果和真实正文区域一致

### 第二阶段：替换分页算法

目标：

- 将当前 `Splitter` 替换为“整章一次 layout，再按行分页”的实现

步骤：

1. 新建 `ChapterPaginator`
2. 用整章 `InlineSpan` 一次 layout
3. 记录页断点为 `ReaderPageRange`
4. 改造 `currentChapterPages` 等数据结构，改为保存 `ChapterLayoutResult`

完成标准：

- 分页速度不低于当前实现
- 长章节分页结果稳定
- 不再依赖字符串哨兵换行

### 第三阶段：接入选择系统

目标：

- 在不引入正文滚动的前提下保留选中文本

步骤：

1. 将正文统一改为 `RichText`
2. 引入 `SelectionArea`
3. 新增“选择模式”状态
4. 在选择模式下禁用翻页手势
5. 在阅读模式下禁用选择拖拽

完成标准：

- 阅读态没有纵向滚动
- 选择态可选中、复制文本
- 选择态和翻页态手势互不冲突

### 第四阶段：缓存和性能优化

目标：

- 保证分页结果可缓存，减少重复计算

缓存 key 建议包含：

- `chapterId`
- `chapterContentHash`
- `viewport`
- `theme typography config`
- `textScaler`
- `locale`

完成标准：

- 同一章节在无配置变化时不重复分页
- 前后章节预加载仍然可用

## 8. 对当前项目的具体改造点

### 8.1 需要保留的现有结构

- `ReaderViewModelMixin` 中的当前章、上一章、下一章预加载机制
- `PageTurnController`
- 本地和云端共享 `component/reader`

### 8.2 需要替换或重构的部分

#### 当前 `Splitter`

文件：

- `lib/util/splitter.dart`

改造方向：

- 废弃“每页对子串反复 layout”的逻辑
- 替换为整章 layout 分页器

#### 当前尺寸初始化

文件：

- `lib/component/reader/reader_view_model_mixin.dart`

改造方向：

- `initSize()` 不再作为正文分页的唯一尺寸来源
- 改为使用阅读器页面内真实约束

#### 当前正文视图

文件：

- `lib/component/reader/reader_content_view.dart`

改造方向：

- 正文固定为 `RichText`
- 文本选择由 `SelectionArea` 提供
- header 改为固定单行，或后续升级为真实测量

## 9. 验收标准

以下条件全部满足，视为问题解决。

- 本地阅读器分页后，正文区域不能垂直滚动。
- 云端阅读器分页后，正文区域不能垂直滚动。
- 同一章节在相同主题、字号、窗口尺寸下，重新进入阅读器时页数稳定。
- header 为长章节名时，不会再因为换行侵占正文导致页面可滚动。
- 进入选择模式后，可以在当前页选中文本并复制。
- 退出选择模式后，点击和手势翻页恢复正常。
- 主题、字号、窗口尺寸变化后，章节会重新分页，页数更新正确。

## 10. 风险和取舍

### 风险 1：选择模式与翻页手势冲突

解决：

- 分离阅读态和选择态

### 风险 2：页内选择可以做到，但跨页连续选择较难

说明：

- 这是分页阅读器的常见限制
- 先支持单页选择，再决定是否引入“滚动摘录模式”

### 风险 3：不同平台字体回退可能导致页数有轻微差异

解决：

- 将 `locale`、`textScaler`、排版参数纳入缓存 key
- 保证同一设备、同一配置下页数稳定

## 11. 最终推荐决策

最终建议采用以下路线，不建议继续围绕 `SelectableText.rich` 修补。

- 分页方式：一次性分页
- 分页引擎：整章一次 layout，再按行切页
- 正文绘制：`RichText`
- 文本选择：`SelectionArea`
- 尺寸来源：正文真实视口
- 手势策略：阅读态与选择态分离

这是当前项目里最接近阅读器常规实现、且最适合继续编码落地的方案。

## 12. 参考

官方 API 和文档，供后续编码时对照：

- https://api.flutter.dev/flutter/widgets/RichText-class.html
- https://api.flutter.dev/flutter/material/SelectionArea-class.html
- https://api.flutter.dev/flutter/widgets/SelectableRegion-class.html
- https://api.flutter.dev/flutter/material/SelectableText-class.html
- https://api.flutter.dev/flutter/painting/TextPainter-class.html
- https://api.flutter.dev/flutter/dart-ui/Paragraph-class.html
- https://api.flutter.dev/flutter/dart-ui/ParagraphBuilder-class.html

## 13. 当前实现状态

截至当前代码版本，以下内容已经落地：

- 已使用真实正文视口替代 `screenSize + 公式估算`
- 已将分页器替换为“整章一次 layout，再按行切页”
- 已引入 `ChapterLayoutResult` 和 `ReaderPageRange`
- 已将正文统一为 `RichText`
- 已接入 `SelectionArea`，并通过“阅读态 / 选择态”分离避免手势冲突
- 已将 `locale`、`textDirection`、`textHeightBehavior`、`textScaler` 等布局参数统一到 `ReaderLayoutConfig`
- 已为章节分页结果加入基于章节内容、正文尺寸、布局参数和主题排版参数的内存缓存
- 已补充 overlay 的“选择文本”入口，不再只依赖长按

本次落地没有包含：

- 自动化测试
- 新一轮真机回归验证

## 14. 当前剩余的可选优化

以下项目不再属于主问题修复必需项，但后续可以继续增强：

- 将 `ReaderPageRange` 进一步扩展为直接记录 paragraph 偏移，减少页内容截取时的映射成本
- 继续优化页尾断点策略，处理极端超长段落或特殊字符组合时的边界稳定性
- 将分页缓存从当前内存级 LRU 扩展为更细粒度的章节生命周期管理
- 为分页稳定性补充自动化测试和真机回归用例
