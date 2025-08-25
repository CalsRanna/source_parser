# 内容页规则

内容页规则用于从章节页面提取正文内容，这是用户阅读体验的核心部分。内容页规则需要处理正文文本、分页链接和各种干扰信息。

## 内容页功能结构

内容页功能包含以下关键组件：

1. **HTTP配置**: 请求方法和处理方式
2. **正文提取**: 定位和提取正文内容
3. **分页处理**: 处理多页章节内容
4. **内容清理**: 移除广告、导航等干扰信息

## 核心配置字段

### HTTP配置
- `contentMethod`: HTTP请求方法（GET/POST）

### 正文提取字段
- `contentContent`: 提取正文内容的选择器

### 分页处理字段
- `contentPagination`: 下一页链接选择器
- `contentPaginationValidation`: 分页验证选择器

## 实际示例

让我们通过笔趣阁的内容页规则来学习：

```json
{
  "contentMethod": "GET",
  "contentContent": "//div[@id='content']@text|dart.replace(笔趣阁 www.biqugeu.net，最快更新.*最新章节！,)|dart.replace(本章未完，点击下一页继续阅读,)|dart.trim()",
  "contentPagination": "//div[@class='bottem2']/a[text()='下一页']@href",
  "contentPaginationValidation": "//div[@class='bottem2']/a[text()='下一页']@text"
}
```

## 规则解析

### 1. 正文内容 (`contentContent`)
```xpath
//div[@id='content']@text|dart.replace(笔趣阁 www.biqugeu.net，最快更新.*最新章节！,)|dart.replace(本章未完，点击下一页继续阅读,)|dart.trim()
```
- 定位到id为`content`的div元素
- 提取文本内容
- 使用多个`dart.replace()`移除广告和导航文本
- 清理首尾空白字符

### 2. 分页链接 (`contentPagination`)
```xpath
//div[@class='bottem2']/a[text()='下一页']@href
```
- 定位到底部导航容器
- 查找文本为"下一页"的链接元素
- 提取`href`属性值

### 3. 分页验证 (`contentPaginationValidation`)
```xpath
//div[@class='bottem2']/a[text()='下一页']@text
```
- 提取"下一页"链接的文本内容
- 用于验证是否还有下一页内容

## 编写技巧

### 1. 正文定位策略
- **ID定位**: 优先使用唯一的id属性定位正文容器
- **Class定位**: 使用具有语义的class属性
- **文本特征**: 利用正文内容的特征定位

### 2. 内容清理技巧
- **广告移除**: 使用`dart.replace()`移除常见的广告文本
- **导航清理**: 移除上下章链接、返回目录等导航信息
- **格式优化**: 清理多余的空白字符和换行符

### 3. 分页处理
- **验证机制**: 确保分页验证准确可靠
- **内容合并**: 系统会自动合并多页内容
- **链接处理**: 相对链接会自动补全

## 高级用法

### 1. 复杂内容清理
```xpath
//div[@class='content']@text|dart.replaceRegExp(\\(.*?\\),)|dart.replace(\n\s*\n,\n)|dart.trim()
```

### 2. 多步骤处理
```xpath
//div[@id='chapter']@text|dart.substring(0, -10)|dart.replace(点击下一页继续阅读,)|dart.trim()
```

### 3. 条件替换
```xpath
//div[@class='main']@text|dart.replace(本文地址：.*,\n)|dart.replace(请记住本书域名.*,\n)
```

## 分页处理详解

### 分页工作原理
1. 提取当前页正文内容
2. 检查是否存在下一页（通过`contentPaginationValidation`）
3. 如果存在下一页，则请求下一页URL
4. 重复上述过程直到没有下一页
5. 合并所有页面的内容

### 分页验证技巧
- **文本验证**: 检查是否包含"下一页"、"继续阅读"等文本
- **属性验证**: 检查特定属性值
- **元素存在性**: 检查下一页元素是否存在

### 示例验证规则
```xpath
//div[@class='pagination']//a[contains(text(), '下一页')]
//div[@class='nav']//span[contains(text(), '下一页')]
//div[@class='page']/a[last()]
```

## 常见问题解决

### 1. 内容提取不完整
**问题**: 只获取了部分内容
**解决方案**:
- 检查分页规则是否正常工作
- 验证正文选择器是否准确定位
- 确认没有遗漏的页面

### 2. 广告清理不彻底
**问题**: 正文中仍包含广告信息
**解决方案**:
- 添加更多的`dart.replace()`规则
- 使用正则表达式处理复杂广告
- 考虑使用`dart.substring()`截取核心内容

### 3. 格式异常
**问题**: 提取的内容格式混乱
**解决方案**:
- 使用`dart.replace()`清理多余换行符
- 使用正则表达式规范化空白字符
- 考虑保留必要的段落结构

## 调试建议

1. **单页测试**: 先测试单页内容提取
2. **分页验证**: 确认分页功能正常
3. **内容检查**: 验证内容完整性和格式
4. **广告清理**: 检查广告是否清理干净

## 最佳实践

### 1. 选择器优化
```xpath
//div[@id='content' or @class='chapter-content']@text
```

### 2. 内容清理
```xpath
//div[@class='content']@text|dart.replaceRegExp(\s*本文地址：.*,\n)|dart.replaceRegExp(\s*请记住本书首发域名.*,\n)|dart.replace(\n\s*\n,\n\n)|dart.trim()
```

### 3. 分页处理
```xpath
//div[contains(@class, 'pager')]//a[contains(text(), '下一页')]/@href
```

通过掌握内容页规则的编写方法，您可以为用户提供干净、完整的阅读体验。