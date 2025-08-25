# 探索页规则

探索页规则用于从网站的推荐或排行榜页面提取书籍信息，为用户提供发现新书籍的途径。探索功能通过JSON配置支持多个不同的探索页面。

## 探索页功能结构

探索页功能包含以下关键组件：

1. **JSON配置**: 定义多个探索页面的规则
2. **页面规则**: 每个探索页面的具体提取规则
3. **数据合并**: 系统自动合并多个页面的结果

## 核心配置字段

### JSON配置字段
- `exploreJson`: 包含所有探索页面规则的JSON数组

### 页面规则字段
每个探索页面包含以下字段：
- `exploreUrl`: 探索页面URL
- `list`: 定位书籍列表的选择器
- `name`: 提取书籍名称的选择器
- `author`: 提取作者名称的选择器
- `category`: 提取分类信息的选择器
- `cover`: 提取封面图片URL的选择器
- `introduction`: 提取简介内容的选择器
- `url`: 提取详情页链接的选择器
- `layout`: 页面布局类型
- `title`: 页面标题

## 实际示例

让我们通过一个探索页配置示例来学习：

```json
{
  "exploreJson": "[{\"exploreUrl\":\"https://www.example.com/rank\",\"list\":\"//div[@class='book-list']/div[@class='book-item']\",\"name\":\"//h3/a@text|dart.trim()\",\"author\":\"//p[@class='author']@text|dart.replace(作者：,)|dart.trim()\",\"category\":\"//span[@class='category']@text|dart.trim()\",\"cover\":\"//img@src|dart.trim()\",\"introduction\":\"//p[@class='intro']@text|dart.trim()\",\"url\":\"//h3/a@href|dart.trim()\",\"layout\":\"list\",\"title\":\"热门排行\"}]"
}
```

解析后的JSON结构：
```json
[
  {
    "exploreUrl": "https://www.example.com/rank",
    "list": "//div[@class='book-list']/div[@class='book-item']",
    "name": "//h3/a@text|dart.trim()",
    "author": "//p[@class='author']@text|dart.replace(作者：,)|dart.trim()",
    "category": "//span[@class='category']@text|dart.trim()",
    "cover": "//img@src|dart.trim()",
    "introduction": "//p[@class='intro']@text|dart.trim()",
    "url": "//h3/a@href|dart.trim()",
    "layout": "list",
    "title": "热门排行"
  }
]
```

## 规则解析

### 1. 探索页面URL (`exploreUrl`)
```url
https://www.example.com/rank
```
定义要请求的探索页面地址。

### 2. 书籍列表 (`list`)
```xpath
//div[@class='book-list']/div[@class='book-item']
```
定位到书籍列表容器，每个`book-item`代表一本书籍。

### 3. 书籍名称 (`name`)
```xpath
//h3/a@text|dart.trim()
```
在每个书籍容器中提取书名链接的文本内容。

### 4. 作者信息 (`author`)
```xpath
//p[@class='author']@text|dart.replace(作者：,)|dart.trim()
```
提取作者信息并移除"作者："前缀。

### 5. 分类信息 (`category`)
```xpath
//span[@class='category']@text|dart.trim()
```
提取书籍分类信息。

### 6. 封面图片 (`cover`)
```xpath
//img@src|dart.trim()
```
提取封面图片URL。

### 7. 简介内容 (`introduction`)
```xpath
//p[@class='intro']@text|dart.trim()
```
提取书籍简介内容。

### 8. 详情页链接 (`url`)
```xpath
//h3/a@href|dart.trim()
```
提取书籍详情页链接。

### 9. 页面布局 (`layout`)
```text
list
```
定义页面布局类型，影响显示方式。

### 10. 页面标题 (`title`)
```text
热门排行
```
显示在探索页面顶部的标题。

## 多页面配置

探索功能支持配置多个不同的探索页面：

```json
[
  {
    "exploreUrl": "https://www.example.com/rank",
    "title": "热门排行",
    "layout": "list",
    "...": "其他字段"
  },
  {
    "exploreUrl": "https://www.example.com/new",
    "title": "新书推荐",
    "layout": "grid",
    "...": "其他字段"
  },
  {
    "exploreUrl": "https://www.example.com/complete",
    "title": "完本佳作",
    "layout": "list",
    "...": "其他字段"
  }
]
```

## 编写技巧

### 1. JSON格式化
- 确保JSON格式正确，注意转义字符
- 使用在线JSON验证工具检查格式
- 保持配置的可读性

### 2. 页面选择
- 选择具有代表性的探索页面
- 考虑不同类型的书籍推荐
- 平衡页面数量和性能

### 3. 数据提取
- 使用与搜索功能相似的提取规则
- 注意处理不同的页面结构
- 确保数据完整性和准确性

## 高级用法

### 1. 复杂JSON配置
```json
[
  {
    "exploreUrl": "https://www.example.com/rank?category=玄幻&period=week",
    "title": "周榜-玄幻",
    "layout": "list",
    "charset": "utf-8",
    "...": "其他字段"
  }
]
```

### 2. 多级分类
```json
[
  {
    "exploreUrl": "https://www.example.com/rank/fantasy",
    "title": "玄幻小说",
    "layout": "grid",
    "...": "其他字段"
  },
  {
    "exploreUrl": "https://www.example.com/rank/xianxia",
    "title": "仙侠小说",
    "layout": "grid",
    "...": "其他字段"
  }
]
```

## 常见问题解决

### 1. JSON格式错误
**问题**: 探索功能无法正常工作
**解决方案**:
- 检查JSON格式是否正确
- 确认所有引号和括号匹配
- 使用JSON验证工具检查

### 2. 页面数据为空
**问题**: 探索页面没有显示数据
**解决方案**:
- 验证`exploreUrl`是否正确
- 检查各字段选择器是否准确
- 确认页面是否需要特殊请求头

### 3. 数据重复
**问题**: 不同探索页面显示相同数据
**解决方案**:
- 确认各页面URL不同
- 检查选择器是否过于宽泛
- 验证页面内容是否确实不同

## 调试建议

1. **单页面测试**: 先测试单个探索页面配置
2. **字段验证**: 逐个验证各字段提取规则
3. **多页面测试**: 确认多个页面能正常显示
4. **性能检查**: 监控多页面加载性能

## 最佳实践

### 1. 页面选择
```json
[
  {
    "exploreUrl": "https://www.example.com/rank",
    "title": "热门排行",
    "layout": "list"
  },
  {
    "exploreUrl": "https://www.example.com/recommend",
    "title": "编辑推荐",
    "layout": "grid"
  }
]
```

### 2. 规则优化
```xpath
//div[@class='book-item' and position()<=20]  // 限制数量
//h3/a[contains(@class, 'title')]@text|dart.trim()  // 精确定位
```

### 3. 错误处理
```xpath
//img[@src]|dart.trim()|dart.replace(,,/default-cover.jpg)  // 默认封面
```

通过掌握探索页规则的编写方法，您可以为用户提供丰富多样的书籍发现体验。