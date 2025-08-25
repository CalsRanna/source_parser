# 高级技巧

通过前面的学习，您已经掌握了基本的规则编写方法。现在让我们学习一些高级技巧，帮助您编写更强大、更灵活的解析规则。

## 复杂XPath选择器

### 1. 条件选择
```xpath
//div[@class='content' and not(@style)]
//a[contains(@href, 'chapter') and string-length(@href) > 10]
//p[position() > 1 and position() < last()]
```

### 2. 轴导航
```xpath
//div/following-sibling::p              # 选择 div 后面的兄弟 p 元素
//div/preceding-sibling::h2             # 选择 div 前面的兄弟 h2 元素
//div/ancestor::div[@class='container'] # 选择 div 的祖先元素
//div/descendant::span[@class='text']   # 选择 div 的后代 span 元素
```

### 3. 函数组合
```xpath
//div[contains(@class, 'chapter') and (contains(@class, 'list') or contains(@class, 'catalog'))]
//*[starts-with(local-name(), 'h') and number(substring-after(local-name(), 'h')) <= 6]
```

## 高级管道函数

### 1. 复杂文本处理
```xpath
//div/text()|dart.replaceRegExp(第\s*([一二三四五六七八九十\d]+)\s*章,第$1章)
//div/text()|dart.replace(\u00A0,,)|dart.replace(\u2003,,)
```

### 2. 字符串操作
```xpath
//div/text()|dart.substring(0,100)|dart.interpolate(摘要：{{string}}...)
//div/text()|dart.match(作者：(.*?))|dart.substring(3)
```

### 3. 条件处理
```xpath
//div[@class='title']@text|dart.trim()|dart.replace(,,默认标题)
//div/text()|dart.substring(0,500)|dart.interpolate({{string}}...)
```

## 动态内容处理

### 1. AJAX加载内容
对于通过AJAX加载的内容，可以分析网络请求：
```json
{
  "catalogueChapters": "json:$.data.chapters[*]",
  "catalogueName": "$.title",
  "catalogueUrl": "$.url"
}
```

### 2. JavaScript渲染内容
对于JavaScript渲染的内容，可能需要特殊处理：
```xpath
//script[contains(text(), 'chapterList')]/text()|dart.match(chapterList\s*=\s*(\[[\s\S]*?\]);)|dart.substring(15)
```

### 3. 预设值处理
```xpath
//div[@class='preset']@data-base|dart.trim()
```
然后在其他规则中使用`{{preset}}`占位符：
```xpath
{{preset}}/chapter/{{string}}
```

## 分页处理优化

### 1. 多级分页
```json
{
  "cataloguePagination": "//div[@class='pagination']//a[contains(text(), '下一页')]/@href",
  "cataloguePaginationValidation": "//div[@class='pagination']//a[contains(text(), '下一页')]",
  "contentPagination": "//div[@class='page-nav']//a[contains(text(), '下一页')]/@href",
  "contentPaginationValidation": "//div[@class='page-nav']//a[contains(text(), '下一页')]"
}
```

### 2. 无限滚动处理
```xpath
//div[@class='load-more' and @data-has-more='true']/@data-next-url
```

### 3. 分页验证优化
```xpath
//div[@class='pager']//a[contains(text(), '下一页') and not(contains(@class, 'disabled'))]
```

## 错误处理与容错

### 1. 备用选择器
```xpath
//div[@class='content']|//div[@class='main-content']|//div[@id='content']
```

### 2. 默认值处理
```xpath
//div[@class='title']@text|dart.trim()|dart.replace(,默认标题)
```

### 3. 空值检查
```xpath
//div[@class='content' and string-length(text()) > 0]
```

## 性能优化

### 1. 选择器优化
```xpath
// 避免低效选择器
//*[@id='content']//p

// 推荐高效选择器
//div[@id='content']/p
```

### 2. 减少不必要的处理
```xpath
// 避免过度处理
//div[@class='content']@text|dart.trim()|dart.replace(\n,)|dart.replace(\s+,)

// 按需处理
//div[@class='content']@text|dart.trim()
```

### 3. 批量处理
```xpath
//div[@class='chapter-list']/ul/li|dart.sublist(0,50)  // 限制数量
```

## 调试技巧

### 1. 分步调试
```xpath
// 先测试基本选择器
//div[@class='content']

// 再测试属性提取
//div[@class='content']@text

// 最后添加管道函数
//div[@class='content']@text|dart.trim()
```

### 2. 使用浏览器工具
在浏览器控制台中测试XPath：
```javascript
$x("//div[@class='content']")
```

### 3. 日志调试
```xpath
//div[@class='debug']@text|dart.trim()|dart.interpolate(调试信息：{{string}})
```

## 安全考虑

### 1. 避免注入攻击
```xpath
// 对用户输入进行适当编码
//div[@id='content']//p[contains(text(), '{{encoded_keyword}}')]
```

### 2. 限制请求频率
```json
{
  "request_delay": 1000,
  "max_concurrent": 3
}
```

## 跨域和认证处理

### 1. 处理登录状态
```json
{
  "header": "{\"Cookie\": \"sessionid=abc123\"}",
  "loginUrl": "https://example.com/login"
}
```

### 2. 处理CSRF令牌
```xpath
//meta[@name='csrf-token']/@content
```

## 国际化支持

### 1. 字符编码处理
```json
{
  "charset": "gbk",
  "charset": "utf-8",
  "charset": "big5"
}
```

### 2. 多语言支持
```xpath
//div[@class='title' or @class='titre' or @class='titulo']@text
```

## 最佳实践总结

### 1. 选择器设计原则
- **具体性**: 使用具体的选择器避免误匹配
- **稳定性**: 避免使用可能变化的属性
- **简洁性**: 保持选择器尽可能简单

### 2. 数据处理原则
- **渐进式**: 从简单规则开始，逐步增加复杂度
- **容错性**: 考虑数据异常情况
- **一致性**: 保持处理逻辑的一致性

### 3. 性能原则
- **最小化**: 只提取必要的数据
- **缓存**: 合理使用缓存机制
- **并发**: 控制并发请求数量

### 4. 维护原则
- **文档化**: 为复杂规则添加注释
- **模块化**: 将相关规则组织在一起
- **版本控制**: 使用版本控制管理规则变更

## 常见陷阱避免

### 1. 过度依赖绝对路径
```xpath
// 避免
/html/body/div[3]/div[2]/ul/li[5]/a

// 推荐
//div[@class='chapter-list']/ul/li/a
```

### 2. 忽略数据清洗
```xpath
// 避免直接使用原始数据
//div[@class='content']@text

// 推荐进行适当清洗
//div[@class='content']@text|dart.trim()|dart.replace(\n\n,\n)
```

### 3. 不考虑异常情况
```xpath
// 考虑空值和异常情况
//div[@class='title']@text|dart.trim()|dart.replace(,,默认标题)
```

通过掌握这些高级技巧，您可以编写出更加稳定、高效和功能强大的解析规则。