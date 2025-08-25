# 目录页规则

目录页规则用于从书籍目录页面提取章节列表信息，包括章节名称和链接。这是获取书籍完整内容的关键步骤。

## 目录页功能结构

目录页功能包含以下关键组件：

1. **HTTP配置**: 请求方法和处理方式
2. **章节列表**: 定位和提取章节信息
3. **分页处理**: 处理多页章节列表
4. **预设值**: 处理动态生成的链接

## 核心配置字段

### HTTP配置
- `catalogueMethod`: HTTP请求方法（GET/POST）

### 章节列表字段
- `catalogueChapters`: 定位章节列表的选择器
- `catalogueName`: 提取章节名称的选择器
- `catalogueUrl`: 提取章节链接的选择器

### 分页处理字段
- `cataloguePagination`: 下一页链接选择器
- `cataloguePaginationValidation`: 分页验证选择器

### 预设值字段
- `cataloguePreset`: 预设值选择器

## 实际示例

让我们通过笔趣阁的目录页规则来学习：

```json
{
  "catalogueMethod": "GET",
  "catalogueChapters": "//div[@id='list']/dl/dd[position()>9]",
  "catalogueName": "a@text|dart.trim()",
  "catalogueUrl": "a@href|dart.trim()",
  "cataloguePagination": "//div[@class='page_chapter']/ul/li/a[text()='下一页']@href",
  "cataloguePaginationValidation": "//div[@class='page_chapter']/ul/li/a[text()='下一页']@text"
}
```

## 规则解析

### 1. 章节列表 (`catalogueChapters`)
```xpath
//div[@id='list']/dl/dd[position()>9]
```
- 定位到id为`list`的div元素
- 进入dl/dd元素层级
- 使用`[position()>9]`跳过前9个元素（通常是标题和说明）

### 2. 章节名称 (`catalogueName`)
```xpath
a@text|dart.trim()
```
- 在每个章节容器中查找a标签
- 提取链接文本作为章节名称
- 清理首尾空白字符

### 3. 章节链接 (`catalogueUrl`)
```xpath
a@href|dart.trim()
```
- 提取a标签的`href`属性值作为章节链接
- 清理文本

### 4. 分页链接 (`cataloguePagination`)
```xpath
//div[@class='page_chapter']/ul/li/a[text()='下一页']@href
```
- 定位到分页导航容器
- 查找文本为"下一页"的链接元素
- 提取`href`属性值

### 5. 分页验证 (`cataloguePaginationValidation`)
```xpath
//div[@class='page_chapter']/ul/li/a[text()='下一页']@text
```
- 提取"下一页"链接的文本内容
- 用于验证是否还有下一页（如果包含"下一页"文本则继续）

## 编写技巧

### 1. 章节列表定位
- **跳过无效元素**: 使用`[position()>n]`跳过标题、说明等非章节元素
- **精确选择**: 使用具体的class或id属性定位容器
- **相对路径**: 在章节容器内使用相对路径定位名称和链接

### 2. 分页处理
- **验证机制**: 使用分页验证确保不会无限循环
- **链接提取**: 准确提取下一页链接
- **自动补全**: 系统会自动处理相对链接

### 3. 特殊情况处理
- **预设值**: 使用`cataloguePreset`处理动态生成的链接
- **章节排序**: 确保章节按正确顺序排列
- **重复章节**: 注意处理重复或异常章节

## 高级用法

### 1. 复杂章节列表
```xpath
//div[@class='chapter-list']//ul[contains(@class, 'volume')]//li
```

### 2. 带卷名的章节处理
```xpath
//div[@class='volume'][position()>1]//li
```

### 3. 预设值使用
```xpath
//div[@class='preset']@data-base|dart.trim()
```
然后在`catalogueUrl`中使用`{{preset}}`占位符：
```xpath
{{preset}}/chapter/{{string}}
```

## 分页处理详解

### 分页工作原理
1. 提取当前页所有章节
2. 检查是否存在下一页（通过`cataloguePaginationValidation`）
3. 如果存在下一页，则请求下一页URL
4. 重复上述过程直到没有下一页

### 分页验证技巧
- **文本验证**: 检查是否包含"下一页"、"下章"等文本
- **属性验证**: 检查特定属性值
- **元素存在性**: 检查下一页元素是否存在

### 示例验证规则
```xpath
//div[@class='pagination']//a[contains(text(), '下一页')]
//div[@class='pager']//span[@class='current']/following-sibling::a
//div[@class='page']/a[last()]
```

## 常见问题解决

### 1. 章节列表不完整
**问题**: 只获取了部分章节
**解决方案**:
- 检查选择器是否正确跳过了非章节元素
- 验证分页规则是否正常工作
- 确认没有遗漏的章节容器

### 2. 章节顺序错误
**问题**: 章节没有按正确顺序排列
**解决方案**:
- 检查选择器是否按文档顺序提取元素
- 考虑使用`dart.reversed()`反转顺序（如果需要）
- 验证网页结构是否按预期排列章节

### 3. 分页处理异常
**问题**: 分页功能无法正常工作
**解决方案**:
- 验证分页链接选择器是否正确
- 检查分页验证规则是否准确
- 确认下一页链接是否需要特殊处理

## 调试建议

1. **逐步验证**: 先测试章节列表选择器
2. **单页测试**: 确保单页章节提取正确
3. **分页测试**: 验证分页功能是否正常
4. **完整性检查**: 确认所有章节都被正确提取

通过掌握目录页规则的编写方法，您可以完整地获取书籍的所有章节信息。