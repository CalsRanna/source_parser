import 'dart:convert';

import 'package:dio/dio.dart';

import '../database/database.dart';
import '../entity/book_source.dart';
import '../entity/rule.dart';

final dio = Dio();

class SourceImporter {
  Future<int> internet(AppDatabase database, String url) async {
    var response = await dio.get(url);
    var count = 0;

    var sources = const JsonDecoder().convert(response.data);

    for (var i = 0; i < sources.length; i++) {
      String comment = sources[i]['bookSourceComment'];
      bool enabled = sources[i]['enabled'];
      bool exploreEnabled = sources[i]['enabledExplore'];
      String? exploreUrl = sources[i]['exploreUrl'];
      String group = sources[i]['bookSourceGroup'];
      String? header = sources[i]['header'];
      String? loginUrl = sources[i]['loginUrl'];
      String name = sources[i]['bookSourceName'];
      int order = sources[i]['customOrder'];
      int responseTime = sources[i]['respondTime'];
      String? searchUrl = sources[i]['searchUrl'];
      int type = sources[i]['bookSourceType'];
      int updatedAt = sources[i]['lastUpdateTime'];
      String url = sources[i]['bookSourceUrl'];
      String? urlPattern = sources[i]['bookUrlPattern'];
      int weight = sources[i]['weight'];

      var rules = <String, String?>{};

      rules.addAll(_parseCatalogueRules(sources[i]['ruleToc']));
      rules.addAll(_parseContentRules(sources[i]['ruleContent']));
      rules.addAll(_parseExploreRules(sources[i]['ruleExplore']));
      rules.addAll(_parseInformationRules(sources[i]['ruleBookInfo']));
      rules.addAll(_parseSearchRules(sources[i]['ruleSearch']));

      var bookSourceDao = database.bookSourceDao;

      var record = await bookSourceDao.findBookSourceByName(name);

      if (record != null) {
        bookSourceDao.updateBookSource(BookSource(
          null,
          comment,
          enabled,
          exploreEnabled,
          exploreUrl,
          group,
          header,
          record.id,
          loginUrl,
          name,
          order,
          responseTime,
          searchUrl,
          type,
          updatedAt,
          url,
          urlPattern,
          weight,
        ));
      } else {
        await bookSourceDao.insertBookSource(BookSource(
          null,
          comment,
          enabled,
          exploreEnabled,
          exploreUrl,
          group,
          header,
          null,
          loginUrl,
          name,
          order,
          responseTime,
          searchUrl,
          type,
          updatedAt,
          url,
          urlPattern,
          weight,
        ));
        record = await bookSourceDao.findBookSourceByName(name);
      }

      var ruleDao = database.ruleDao;

      var keys = rules.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        var rule = await ruleDao.findRuleById(record!.id!);
        if (rule != null) {
          ruleDao
              .updateRule(Rule(rule.id, keys[i], record.id!, rules[keys[i]]));
        } else {
          ruleDao.insertRule(Rule(null, keys[i], record.id!, rules[keys[i]]));
        }
      }

      count++;
    }
    return count;
  }

  Map<String, String?> _parseSource(Map<String, dynamic> json) {
    var source = <String, String?>{};
    source['charset'] = json['charset'];
    source['comment'] = json['comment'];
    source['enabled'] = json['enabled'];
    source['explore-enabled'] = json['exploreEnabled'];
    source['explore-url'] = json['exploreUrl'];
    source['group'] = json['group'];
    source['header'] = json['header'];
    source['login-url'] = json['loginUrl'];
    source['name'] = json['name'];
    source['order'] = json['order'];
    source['response-time'] = json['responseTime'];
    source['search-url'] = json['searchUrl'];
    source['type'] = json['type'];
    source['updated-at'] = json['updatedAt'];
    source['url'] = json['url'];
    source['url-pattern'] = json['urlPattern'];
    source['weight'] = json['weight'];
    return source;
  }

  Map<String, String?> _parseCatalogueRules(Map<String, dynamic> json) {
    var rules = <String, String?>{};
    rules['catalogue-chapters'] = json['chapterList'];
    rules['catalogue-url'] = json['chapterUrl'];
    rules['catalogue-name'] = json['chapterName'];
    rules['catalogue-pagination'] = json['nextTocUrl'];
    rules['catalogue-updated-at'] = json['updateTime'];
    rules['catalogue-vip'] = json['isVolume'];
    return rules;
  }

  Map<String, String?> _parseContentRules(Map<String, dynamic> json) {
    var rules = <String, String?>{};
    rules['content-url'] = json['chapterUrl'];
    rules['content-image-style'] = json['imageStyle'];
    rules['content-pagination'] = json['nextContentUrl'];
    rules['content-repace'] = json['replaceRegex'];
    rules['content-script'] = json['webJs'];
    rules['content-source'] = json['sourceRegex'];
    return rules;
  }

  Map<String, String?> _parseExploreRules(Map<String, dynamic> json) {
    var rules = <String, String?>{};
    rules['explore-author'] = json['author'];
    rules['explore-books'] = json['bookList'];
    rules['explore-url'] = json['bookUrl'];
    rules['explore-cover'] = json['coverUrl'];
    rules['explore-introduction'] = json['intro'];
    rules['explore-category'] = json['kind'];
    rules['explore-latest-chapter'] = json['lastChapter'];
    rules['explore-name'] = json['name'];
    rules['explore-words'] = json['word-count'];
    return rules;
  }

  Map<String, String?> _parseInformationRules(Map<String, dynamic> json) {
    var rules = <String, String?>{};
    rules['information-author'] = json['author'];
    rules['information-catalogue-url'] = json['tocUrl'];
    rules['information-cover'] = json['coverUrl'];
    rules['information-introduction'] = json['intro'];
    rules['information-category'] = json['kind'];
    rules['information-latest-chapter'] = json['lastChapter'];
    rules['information-name'] = json['name'];
    rules['information-preproccess'] = json['init'];
    rules['information-words'] = json['word-count'];
    return rules;
  }

  Map<String, String?> _parseSearchRules(Map<String, dynamic> json) {
    var rules = <String, String?>{};
    rules['search-author'] = json['author'];
    rules['search-check-key-word'] = json['checkKeyWord'];
    rules['search-books'] = json['bookList'];
    rules['search-url'] = json['bookUrl'];
    rules['search-cover'] = json['coverUrl'];
    rules['search-introduction'] = json['intro'];
    rules['search-category'] = json['kind'];
    rules['search-latest-chapter'] = json['lastChapter'];
    rules['search-name'] = json['name'];
    rules['search-words'] = json['word-count'];
    return rules;
  }
}
