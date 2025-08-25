# 实战案例

通过前面的学习，我们已经掌握了网页解析规则的各种技巧。现在让我们通过几个完整的实战案例，来学习如何为不同类型的网站编写书源规则。

## 案例一：笔趣阁类型网站

### 网站特征
- 传统的HTML网页结构
- 章节分页显示
- 包含大量广告文本
- 支持搜索功能

### 完整书源配置

```json
{
  "name": "笔趣阁小说网",
  "url": "https://www.biqugeu.net",
  "charset": "utf-8",
  "enabled": true,
  
  "searchUrl": "https://www.biqugeu.net/search.php?q={{credential}}",
  "searchMethod": "GET",
  "searchBooks": "//div[@class='result-item result-game-item']",
  "searchName": "//div[@class='result-game-item-detail']/h3/a@text|dart.trim()",
  "searchAuthor": "//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[1]/span[2]@text|dart.trim()",
  "searchCategory": "//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[2]/span[2]@text|dart.trim()",
  "searchCover": "//div[@class='result-game-item-pic']/a/img@src|dart.trim()",
  "searchIntroduction": "//div[@class='result-game-item-detail']/p[@class='result-game-item-desc']@text|dart.trim()",
  "searchInformationUrl": "//div[@class='result-game-item-detail']/h3/a@href|dart.trim()",
  "searchLatestChapter": "//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[3]/a@text|dart.trim()",
  "searchWords": "//div[@class='result-game-item-detail']/div[@class='result-game-item-info']/p[2]/span[4]@text|dart.replaceRegExp([万字],)|dart.trim()",
  
  "informationMethod": "GET",
  "informationName": "//div[@id='info']/h1@text|dart.trim()",
  "informationAuthor": "//div[@id='info']/p[1]@text|dart.replace(作    者：,)|dart.trim()",
  "informationCategory": "//div[@class='con_top']@text|dart.match(\\[(.*?)\\])|dart.replace([,)|dart.replace(],)|dart.trim()",
  "informationCover": "//div[@id='sidebar']/div[@id='fmimg']/img@src|dart.trim()",
  "informationIntroduction": "//div[@id='intro']@text|dart.trim()",
  "informationLatestChapter": "//div[@id='info']/p[4]/a@text|dart.trim()",
  "informationCatalogueUrl": "//div[@class='con_top']//a[3]@href|dart.trim()",
  
  "catalogueMethod": "GET",
  "catalogueChapters": "//div[@id='list']/dl/dd[position()>9]",
  "catalogueName": "a@text|dart.trim()",
  "catalogueUrl": "a@href|dart.trim()",
  "cataloguePagination": "//div[@class='page_chapter']/ul/li/a[text()='下一页']@href",
  "cataloguePaginationValidation": "//div[@class='page_chapter']/ul/li/a[text()='下一页']@text",
  
  "contentMethod": "GET",
  "contentContent": "//div[@id='content']@text|dart.replace(笔趣阁 www.biqugeu.net，最快更新.*最新章节！,)|dart.replace(本章未完，点击下一页继续阅读,)|dart.trim()",
  "contentPagination": "//div[@class='bottem2']/a[text()='下一页']@href",
  "contentPaginationValidation": "//div[@class='bottem2']/a[text()='下一页']@text",
  
  "exploreJson": "[{\"exploreUrl\":\"https://www.biqugeu.net\",\"list\":\"//div[@class='item']\",\"name\":\"//span[@class='s2']/a@text|dart.trim()\",\"author\":\"//span[@class='s4']@text|dart.trim()\",\"category\":\"//span[@class='s5']@text|dart.trim()\",\"cover\":\"//img@src|dart.trim()\",\"introduction\":\"//div[@class='review']@text|dart.trim()\",\"url\":\"//span[@class='s2']/a@href|dart.trim()\",\"layout\":\"list\",\"title\":\"热门推荐\"}]"
}
```

### 关键技巧解析

1. **搜索结果处理**: 使用`[position()>n]`跳过无效元素
2. **内容清理**: 多重`dart.replace()`移除广告文本
3. **分页验证**: 准确的分页文本验证
4. **URL处理**: 系统自动处理相对链接

## 案例二：现代响应式网站

### 网站特征
- 响应式设计
- AJAX动态加载
- JSON API接口
- 现代化的CSS类名

### 完整书源配置

```json
{
  "name": "现代小说网",
  "url": "https://www.modern-novel.com",
  "charset": "utf-8",
  "enabled": true,
  
  "searchUrl": "https://www.modern-novel.com/api/search?keyword={{credential}}",
  "searchMethod": "GET",
  "searchBooks": "json:$.data.books[*]",
  "searchName": "$.name",
  "searchAuthor": "$.author",
  "searchCategory": "$.category",
  "searchCover": "$.cover",
  "searchIntroduction": "$.introduction",
  "searchInformationUrl": "$.url",
  "searchLatestChapter": "$.latestChapter",
  
  "informationMethod": "GET",
  "informationName": "//header/h1@text|dart.trim()",
  "informationAuthor": "//div[@class='book-meta']//span[contains(text(), '作者')]/following-sibling::span@text|dart.trim()",
  "informationCategory": "//div[@class='book-meta']//span[contains(text(), '分类')]/following-sibling::span@text|dart.trim()",
  "informationCover": "//div[@class='book-cover']/img@src|dart.trim()",
  "informationIntroduction": "//div[@class='book-intro']//p@text|dart.trim()",
  "informationLatestChapter": "//div[@class='latest-chapter']/a@text|dart.trim()",
  "informationCatalogueUrl": "//div[@class='actions']//a[contains(text(), '目录')]/@href|dart.trim()",
  
  "catalogueMethod": "GET",
  "catalogueChapters": "//div[@class='chapter-list']//li",
  "catalogueName": "a@text|dart.trim()",
  "catalogueUrl": "a@href|dart.trim()",
  "cataloguePagination": "//nav[@class='pagination']//a[contains(text(), '下一页')]/@href",
  "cataloguePaginationValidation": "//nav[@class='pagination']//a[contains(text(), '下一页')]/@text",
  
  "contentMethod": "GET",
  "contentContent": "//div[@class='chapter-content']@text|dart.replaceRegExp(\\s*本文地址：.*,\n)|dart.replace(\n\\s*\n,\n\n)|dart.trim()",
  "contentPagination": "//div[@class='chapter-nav']//a[contains(text(), '下一页')]/@href",
  "contentPaginationValidation": "//div[@class='chapter-nav']//a[contains(text(), '下一页')]/@text"
}
```

### 关键技巧解析

1. **JSON API**: 直接使用JSONPath处理API响应
2. **现代选择器**: 使用`contains(text(), '关键词')`定位元素
3. **响应式处理**: 适应现代网站的结构
4. **内容优化**: 使用正则表达式清理复杂格式

## 案例三：需要登录的网站

### 网站特征
- 需要用户登录
- Cookie认证
- CSRF令牌保护
- 会员专享内容

### 完整书源配置

```json
{
  "name": "会员小说网",
  "url": "https://www.vip-novel.com",
  "charset": "utf-8",
  "enabled": true,
  "header": "{\"Cookie\": \"sessionid=your_session_id; csrftoken=your_csrf_token\"}",
  
  "searchUrl": "https://www.vip-novel.com/search/?q={{credential}}",
  "searchMethod": "GET",
  "searchBooks": "//div[@class='search-results']//div[@class='book-item']",
  "searchName": "//h3/a@text|dart.trim()",
  "searchAuthor": "//div[@class='author']@text|dart.replace(作者：,)|dart.trim()",
  "searchCover": "//div[@class='cover']/img@src|dart.trim()",
  "searchInformationUrl": "//h3/a@href|dart.trim()",
  
  "informationMethod": "GET",
  "informationName": "//div[@class='book-title']/h1@text|dart.trim()",
  "informationAuthor": "//div[@class='book-author']@text|dart.replace(作者：,)|dart.trim()",
  "informationCover": "//div[@class='book-cover']/img@src|dart.trim()",
  "informationIntroduction": "//div[@class='book-intro']@text|dart.trim()",
  "informationCatalogueUrl": "//div[@class='book-actions']//a[contains(@href, 'catalog')]/@href|dart.trim()",
  
  "catalogueMethod": "GET",
  "catalogueChapters": "//div[@class='chapter-list']//li[not(contains(@class, 'vip'))]",
  "catalogueName": "a@text|dart.trim()",
  "catalogueUrl": "a@href|dart.trim()",
  
  "contentMethod": "GET",
  "contentContent": "//div[@class='chapter-content']@text|dart.trim()"
}
```

### 关键技巧解析

1. **认证处理**: 通过`header`字段设置Cookie
2. **权限控制**: 使用`not(contains(@class, 'vip'))`过滤VIP章节
3. **安全考虑**: 注意保护个人认证信息
4. **会话管理**: 处理CSRF令牌和会话过期

## 案例四：多语言网站

### 网站特征
- 支持多种语言
- 不同的字符编码
- 国际化内容
- 多地区版本

### 完整书源配置

```json
{
  "name": "国际小说网",
  "url": "https://www.international-novel.com",
  "charset": "utf-8",
  "enabled": true,
  
  "searchUrl": "https://www.international-novel.com/search?q={{credential}}",
  "searchMethod": "GET",
  "searchBooks": "//div[contains(@class, 'search-result')]//article",
  "searchName": "//h2/a@text|dart.trim()",
  "searchAuthor": "//div[@class='meta']//span[contains(@data-label, 'Author')]/@data-value|dart.trim()",
  "searchCover": "//figure/img@src|dart.trim()",
  "searchInformationUrl": "//h2/a@href|dart.trim()",
  
  "informationMethod": "GET",
  "informationName": "//header/h1@text|dart.trim()",
  "informationAuthor": "//div[@class='book-details']//dt[contains(text(), 'Author')]/following-sibling::dd@text|dart.trim()",
  "informationCover": "//div[@class='book-cover']/img@src|dart.trim()",
  "informationIntroduction": "//div[@class='synopsis']//p@text|dart.trim()",
  "informationCatalogueUrl": "//nav//a[contains(text(), 'Chapters') or contains(text(), '章节')]/@href|dart.trim()",
  
  "catalogueMethod": "GET",
  "catalogueChapters": "//div[@class='chapter-list']//li",
  "catalogueName": "a@text|dart.trim()",
  "catalogueUrl": "a@href|dart.trim()",
  
  "contentMethod": "GET",
  "contentContent": "//div[@class='chapter-content']@text|dart.replace(\u00A0, )|dart.trim()"
}
```

### 关键技巧解析

1. **国际化处理**: 使用`contains(text(), '关键词')`支持多语言
2. **字符编码**: 正确设置字符编码处理特殊字符
3. **数据属性**: 利用`@data-*`属性提取信息
4. **特殊字符**: 处理不间断空格等特殊字符

## 调试和优化建议

### 1. 逐步测试
```bash
# 1. 测试搜索功能
# 2. 验证详情页规则
# 3. 检查目录页提取
# 4. 测试内容页解析
# 5. 验证探索功能
```

### 2. 性能优化
- 使用具体的选择器避免全局搜索
- 限制章节列表数量避免性能问题
- 合理设置缓存时间
- 控制并发请求数量

### 3. 错误处理
- 为关键字段提供默认值
- 使用备用选择器处理结构变化
- 考虑网络异常情况
- 记录调试日志便于问题排查

### 4. 维护建议
- 定期检查规则有效性
- 关注网站结构变化
- 保持规则文档更新
- 建立版本控制机制

通过这些实战案例，您应该能够为各种类型的网站编写有效的书源规则。记住，编写规则是一个迭代的过程，需要不断测试和优化。