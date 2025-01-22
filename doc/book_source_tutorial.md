# 书源编写教程

这份教程将帮助你学习如何编写书源，即使你没有编程基础也能轻松上手。我们会通过实际的例子，一步步地学习如何创建一个完整的书源。

## 什么是书源？

书源就是一组规则的集合，它告诉阅读器如何从网站上获取小说内容。比如：
- 在哪里搜索小说
- 如何获取小说的详细信息
- 如何获取章节列表
- 如何获取章节内容

## 开始之前

在开始编写书源之前，你需要准备：
1. 一个想要添加的小说网站
2. 一个文本编辑器（记事本就可以）
3. 耐心和细心

## 基本结构

一个完整的书源包含以下几个主要部分：

```json
{
    "source_name": "示例书源",           // 书源名称
    "source_url": "http://example.com", // 网站网址
    "source_enabled": true,             // 是否启用
    
    // 搜索相关规则
    "search_books": "规则1",
    "search_name": "规则2",
    
    // 详情页规则
    "information_name": "规则3",
    "information_author": "规则4",
    
    // 目录页规则
    "catalogue_chapters": "规则5",
    "catalogue_name": "规则6",
    
    // 正文规则
    "content_content": "规则7"
}
```

## 实战：创建第一个书源

让我们通过一个实际的例子来学习。以下是创建书源的步骤：

### 1. 基本信息

首先填写书源的基本信息：

```json
{
    "source_name": "3z中文网",
    "source_url": "http://www.530p.com",
    "source_enabled": true
}
```

### 2. 搜索功能

搜索功能需要以下规则：

```json
{
    "search_books": "//div/ul[position()>1]",     // 搜索结果列表
    "search_name": "//li[1]/a@text",            // 书名
    "search_author": "//li[3]@text",            // 作者
    "search_latest_chapter": "//li[2]/a@text",  // 最新章节
    "search_url": "//li[1]/a@href"             // 书籍链接
}
```

这些规则的含义是：
- `search_books`：找到所有搜索结果
- `search_name`：从每个结果中提取书名
- `search_author`：提取作者名
- `search_latest_chapter`：提取最新章节名
- `search_url`：提取书籍详情页链接

### 3. 书籍详情

获取书籍详细信息的规则：

```json
{
    "information_name": "//div[3]/div[3]/a@text",
    "information_author": "//div[3]/table/tbody/tr[1]/td[3]@text",
    "information_category": "//div[3]/table/tbody/tr[1]/td[5]/a@text",
    "information_cover": "//div[3]/table/tbody/tr[1]/td[1]/img@src",
    "information_latest_chapter": "//div[3]/table/tbody/tr[2]/td/a@text",
    "information_introduction": "//div[3]/table/tbody/tr[4]/td/text()@text"
}
```

这些规则分别用来提取：
- 书名
- 作者
- 分类
- 封面图片
- 最新章节
- 简介

### 4. 目录页面

获取章节列表的规则：

```json
{
    "catalogue_chapters": "//div[3]/div[5]/div[position()>1]",
    "catalogue_name": "/a@text",
    "catalogue_url": "/a@href"
}
```

这些规则用来：
- 找到所有章节
- 提取章节名称
- 提取章节链接

### 5. 正文内容

最后是获取章节内容的规则：

```json
{
    "content_content": "//div[1]/div/div[4]@text"
}
```

这条规则用来提取章节的正文内容。

## 规则编写技巧

1. **观察网页结构**：
   - 打开网页
   - 找到你想要获取的内容（比如书名、作者等）
   - 观察这些内容在网页中的位置

2. **使用简单的规则**：
   - 规则越简单越好
   - 确保规则能准确定位到内容

3. **测试和调整**：
   - 添加规则后要测试
   - 如果获取不到内容，可能需要调整规则

## 常见问题

1. **获取不到内容？**
   - 检查网站是否正常访问
   - 检查规则是否正确
   - 网站结构可能发生变化，需要更新规则

2. **内容不完整？**
   - 检查规则是否完整
   - 确认是否遗漏了某些部分

## 进阶内容

如果你想深入了解更多关于解析规则的高级用法，包括：
- XPath 和 JSONPath 的详细用法
- 所有支持的属性提取方法
- 强大的管道函数功能

请查看我们的[解析规则参考文档](parsing_rules_reference.md)。

## 总结

编写书源主要需要：
1. 了解网站结构
2. 编写正确的规则
3. 测试和调整

只要按照这个教程一步步来，相信你很快就能编写出自己的书源了！

记住：实践是最好的学习方式，多尝试、多练习，你会越来越熟练的。