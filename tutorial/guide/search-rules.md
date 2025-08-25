# 搜索规则

搜索功能是书源的核心功能之一，它允许用户通过关键词搜索书籍。搜索规则定义了如何从搜索结果页面提取书籍信息。

## 搜索功能结构

搜索功能包含以下几个关键组件：

1. **搜索URL配置**: 定义搜索请求的URL模板
2. **搜索结果列表**: 定位搜索结果的容器元素
3. **书籍信息提取**: 从每个搜索结果中提取书籍详细信息

## 搜索URL配置

### 基础配置字段

- `searchUrl`: 搜索URL模板，使用 `{{credential}}` 作为搜索关键词占位符
- `searchMethod`: HTTP请求方法（GET/POST）
- `header`: 自定义请求头（JSON格式）

**示例配置**:
```json
{
  "searchUrl": "https://www.example.com/search?q={{credential}}",
  "searchMethod": "GET",
  "header": "{\"User-Agent\": \"Mozilla/5.0\"}"
}
```

## 搜索结果列表规则

### 核心字段

- `searchBooks`: 定位搜索结果列表的XPath选择器
- `searchName`: 提取书籍名称的选择器
- `searchAuthor`: 提取作者名称的选择器
- `searchCategory`: 提取分类信息的选择器
- `searchCover`: 提取封面图片URL的选择器
- `searchIntroduction`: 提取简介内容的选择器
- `searchInformationUrl`: 提取详情页链接的选择器
- `searchLatestChapter`: 提取最新章节名称的选择器
- `searchWordCount`: 提取字数信息的选择器

## 实际示例

让我们通过笔趣阁的搜索规则来学习：

```json
{
  "searchBooks": "//div[@class='result-item result-game-item']",
  "searchName": "//div[@class='result-game-item-detail']/h3/a@text|dart.trim()",
  "searchAuthor": "//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[1]/span[2]@text|dart.trim()",
  "searchCategory": "//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[2]/span[2]@text|dart.trim()",
  "searchCover": "//div[@class='result-game-item-pic']/a/img@src|dart.trim()",
  "searchIntroduction": "//div[@class='result-game-item-detail']/p[@class='result-game-item-desc']@text|dart.trim()",
  "searchInformationUrl": "//div[@class='result-game-item-detail']/h3/a@href|dart.trim()",
  "searchLatestChapter": "//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[3]/a@text|dart.trim()",
  "searchWords": "//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[2]/span[4]@text|dart.replaceRegExp([万字],)|dart.trim()"
}
```

## 规则解析

### 1. 搜索结果列表 (`searchBooks`)
```xpath
//div[@class='result-item result-game-item']
```
这个规则定位到所有搜索结果项的容器元素。

### 2. 书籍名称 (`searchName`)
```xpath
//div[@class='result-game-item-detail']/h3/a@text|dart.trim()
```
- 定位到书籍名称链接元素
- 提取文本内容
- 使用 `dart.trim()` 去除首尾空白字符

### 3. 作者信息 (`searchAuthor`)
```xpath
//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[1]/span[2]@text|dart.trim()
```
- 精确定位到作者信息元素
- 提取文本内容并清理

### 4. 封面图片 (`searchCover`)
```xpath
//div[@class='result-game-item-pic']/a/img@src|dart.trim()
```
- 定位到封面图片元素
- 提取 `src` 属性值（图片URL）

### 5. 详情页链接 (`searchInformationUrl`)
```xpath
//div[@class='result-game-item-detail']/h3/a@href|dart.trim()
```
- 定位到书籍链接元素
- 提取 `href` 属性值（详情页URL）

## 编写技巧

### 1. 选择器编写
- 使用具体的class或id属性定位元素
- 避免使用过于宽泛的选择器
- 考虑网站结构的稳定性

### 2. 数据处理
- 使用 `dart.trim()` 清理文本
- 使用 `dart.replace()` 处理不需要的前缀或后缀
- 使用正则表达式处理复杂格式

### 3. 错误处理
- 考虑字段可能为空的情况
- 使用默认值处理异常情况
- 测试不同搜索关键词的结果

## 高级用法

### 1. 复杂选择器
```xpath
//div[contains(@class, 'result') and @data-type='book']
```

### 2. 正则表达式处理
```xpath
//div[@class='info']@text|dart.match(作者：(.*?))|dart.replace(作者：,)
```

### 3. 多步骤处理
```xpath
//div[@class='count']@text|dart.replace(字,)|dart.replace(,,)|dart.trim()
```

## 调试建议

1. **逐步验证**: 先测试 `searchBooks` 选择器是否能正确获取结果列表
2. **单字段测试**: 逐个测试每个字段的提取规则
3. **边界情况**: 测试空结果、异常格式等情况
4. **实际搜索**: 使用不同关键词测试搜索功能

通过掌握搜索规则的编写方法，您可以为任何支持搜索功能的网站创建书源。