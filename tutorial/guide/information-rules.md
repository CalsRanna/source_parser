# 详情页规则

详情页规则用于从书籍详情页面提取完整的书籍信息，包括作者、分类、简介、封面、最新章节等详细信息。

## 详情页功能结构

详情页功能包含以下关键字段：

1. **HTTP配置**: 请求方法和处理方式
2. **基本信息**: 书籍名称、作者、分类等
3. **媒体信息**: 封面图片、字数统计等
4. **内容信息**: 简介、最新章节、目录链接等

## 核心配置字段

### HTTP配置
- `informationMethod`: HTTP请求方法（GET/POST）

### 基本信息字段
- `informationName`: 书籍名称选择器
- `informationAuthor`: 作者名称选择器
- `informationCategory`: 分类信息选择器

### 媒体信息字段
- `informationCover`: 封面图片URL选择器
- `informationWordCount`: 字数信息选择器

### 内容信息字段
- `informationIntroduction`: 简介内容选择器
- `informationLatestChapter`: 最新章节名称选择器
- `informationCatalogueUrl`: 目录页链接选择器

## 实际示例

让我们通过笔趣阁的详情页规则来学习：

```json
{
  "informationMethod": "GET",
  "informationName": "//div[@id='info']/h1@text|dart.trim()",
  "informationAuthor": "//div[@id='info']/p[1]@text|dart.replace(作    者：,)|dart.trim()",
  "informationCategory": "//div[@class='con_top']@text|dart.match(\\[(.*?)\\])|dart.replace([,)|dart.replace(],)|dart.trim()",
  "informationCover": "//div[@id='sidebar']/div[@id='fmimg']/img@src|dart.trim()",
  "informationIntroduction": "//div[@id='intro']@text|dart.trim()",
  "informationLatestChapter": "//div[@id='info']/p[4]/a@text|dart.trim()",
  "informationCatalogueUrl": "//div[@class='con_top']//a[3]@href|dart.trim()"
}
```

## 规则解析

### 1. 书籍名称 (`informationName`)
```xpath
//div[@id='info']/h1@text|dart.trim()
```
- 通过id定位到书籍信息容器
- 提取h1标题元素的文本内容
- 清理首尾空白字符

### 2. 作者信息 (`informationAuthor`)
```xpath
//div[@id='info']/p[1]@text|dart.replace(作    者：,)|dart.trim()
```
- 定位到第一个段落元素（通常包含作者信息）
- 使用 `dart.replace()` 移除"作者："前缀
- 清理文本

### 3. 分类信息 (`informationCategory`)
```xpath
//div[@class='con_top']@text|dart.match(\\[(.*?)\\])|dart.replace([,)|dart.replace(],)|dart.trim()
```
- 定位到顶部导航元素
- 使用正则表达式 `\\[(.*?)\\]` 匹配方括号内的内容
- 移除方括号符号
- 清理文本

### 4. 封面图片 (`informationCover`)
```xpath
//div[@id='sidebar']/div[@id='fmimg']/img@src|dart.trim()
```
- 精确定位到封面图片容器
- 提取图片的 `src` 属性值

### 5. 简介内容 (`informationIntroduction`)
```xpath
//div[@id='intro']@text|dart.trim()
```
- 定位到简介内容容器
- 提取文本内容并清理

### 6. 最新章节 (`informationLatestChapter`)
```xpath
//div[@id='info']/p[4]/a@text|dart.trim()
```
- 定位到第四个段落中的链接元素
- 提取章节名称

### 7. 目录链接 (`informationCatalogueUrl`)
```xpath
//div[@class='con_top']//a[3]@href|dart.trim()
```
- 在顶部导航中查找第三个链接
- 提取 `href` 属性值作为目录页URL

## 编写技巧

### 1. 元素定位策略
- **ID定位**: 优先使用 `@id` 属性定位元素
- **Class定位**: 使用 `@class` 属性定位具有特定样式的元素
- **位置定位**: 使用 `[index]` 按位置定位元素
- **文本定位**: 使用 `contains(text(), '关键词')` 按文本内容定位

### 2. 数据处理技巧
- **前缀处理**: 使用 `dart.replace()` 移除不需要的前缀
- **格式提取**: 使用 `dart.match()` 配合正则表达式提取特定格式
- **文本清理**: 使用 `dart.trim()` 和 `dart.replace()` 清理文本

### 3. 复杂场景处理
- **相对路径**: 使用相对路径 `./` 或 `../` 定位相关元素
- **条件选择**: 使用 `[condition]` 添加定位条件
- **多步处理**: 组合多个管道函数处理复杂数据

## 高级用法

### 1. 复杂正则表达式
```xpath
//div[@class='info']@text|dart.match(更新时间：(\\d{4}-\\d{2}-\\d{2}))|dart.trim()
```

### 2. 多步骤数据处理
```xpath
//div[@class='category']@text|dart.replace(分类：,)|dart.trim()|dart.interpolate(分类：{{string}})
```

### 3. 默认值处理
```xpath
//div[@class='status']@text|dart.trim()|dart.replace(,,连载中)
```

## 常见问题解决

### 1. 元素定位失败
**问题**: 选择器无法定位到目标元素
**解决方案**: 
- 检查网页源码中的实际结构
- 使用浏览器开发者工具验证XPath
- 考虑使用更通用的选择器

### 2. 数据提取不完整
**问题**: 提取的文本内容缺失或格式不正确
**解决方案**:
- 使用 `@text` 而不是 `text()` 函数
- 添加适当的管道函数处理文本
- 检查是否需要合并多个元素的内容

### 3. URL处理问题
**问题**: 提取的链接是相对路径
**解决方案**:
- 系统会自动处理相对路径，补全为基础URL
- 确保 `source.url` 配置正确

## 调试建议

1. **分步测试**: 逐个字段测试提取规则
2. **浏览器验证**: 使用浏览器开发者工具验证选择器
3. **边界测试**: 测试不同格式的数据
4. **错误处理**: 考虑字段为空的情况

通过掌握详情页规则的编写方法，您可以完整地提取书籍的所有详细信息。