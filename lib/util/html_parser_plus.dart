import 'dart:convert';

import 'package:html/dom.dart';
import 'package:json_path/json_path.dart';
import 'package:xpath_selector/xpath_selector.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

class HtmlParser {
  HtmlParserNode parse(String html) {
    try {
      return HtmlParserNode()..jsonNode = jsonDecode(html);
    } catch (error) {
      return HtmlParserNode()..xpathNode = HtmlXPath.html(html).root;
    }
  }

  String query(HtmlParserNode node, String? rule) {
    String result = '';
    if (rule == null || rule.isEmpty) {
      return result;
    }
    final rules = _generateRules(rule);
    for (var item in rules) {
      if (item.protocol == 'function') {
        result = _pipeFunction(result, item);
      } else {
        result = _pipeRule(node, item);
      }
    }
    return result;
  }

  List<HtmlParserNode> queryNodes(HtmlParserNode node, String? rule) {
    List<HtmlParserNode> results = [];
    if (rule == null || rule.isEmpty) {
      return results;
    }
    final rules = _generateRules(rule);
    for (var item in rules) {
      if (item.protocol == 'function') {
        results = _pipeFunctionForNodes(results, item);
      } else {
        results = _pipeRuleForNodes(node, item);
      }
    }
    return results;
  }

  List<Rule> _generateRules(String rule) {
    var patterns = rule.split('|');
    List<Rule> rules = [];
    for (var item in patterns) {
      rules.add(Rule.from(value: item));
    }
    return rules;
  }

  String _pipeFunction(String string, Rule rule) {
    final function = rule.function;
    if (function.startsWith('substring')) {
      final paramsString = _getParamsString(function);
      final params = paramsString.split(',');
      final start = int.parse(params.first.trim());
      final end = params.length >= 2 ? int.parse(params.last.trim()) : null;
      return string.substring(start, end);
    } else if (function.startsWith('trim')) {
      return string.trim();
    } else if (function.startsWith('replaceRegExp')) {
      final paramsString = _getParamsString(function);
      final params = paramsString.split(',');
      final from = params.getRange(0, params.length - 1).join(',');
      var replace = params.length >= 2 ? params.last : '';
      replace = replace.replaceAll(r'\n', '\n');
      replace = replace.replaceAll(r'\u00A0', '\u00A0');
      replace = replace.replaceAll(r'\u2003', '\u2003');
      return string.replaceAll(RegExp(from), replace);
    } else if (function.startsWith('replaceFirst')) {
      var paramsString = _getParamsString(function);
      paramsString = paramsString.replaceAll(r'\n', '\n');
      paramsString = paramsString.replaceAll(r'\u00A0', '\u00A0');
      paramsString = paramsString.replaceAll(r'\u2003', '\u2003');
      final params = paramsString.split(',');
      final from = params.getRange(0, params.length - 1).join(',');
      final replace = params.length >= 2 ? params.last : '';
      return string.replaceFirst(from, replace);
    } else if (function.startsWith('replace')) {
      var paramsString = _getParamsString(function);
      paramsString = paramsString.replaceAll(r'\n', '\n');
      paramsString = paramsString.replaceAll(r'\u00A0', '\u00A0');
      paramsString = paramsString.replaceAll(r'\u2003', '\u2003');
      final params = paramsString.split(',');
      final from = params.getRange(0, params.length - 1).join(',');
      final replace = params.length >= 2 ? params.last : '';
      return string.replaceAll(from, replace);
    } else if (function.startsWith('interpolate')) {
      var paramsString = _getParamsString(function);
      paramsString = paramsString.replaceAll(r'\n', '\n');
      paramsString = paramsString.replaceAll(r'\u00A0', '\u00A0');
      paramsString = paramsString.replaceAll(r'\u2003', '\u2003');
      return paramsString.replaceAll('{{string}}', string);
    } else if (function.startsWith('match')) {
      final paramsString = _getParamsString(function);
      final regExp = RegExp(paramsString);
      final match = regExp.firstMatch(string);
      if (match != null) {
        return match.group(0) ?? '';
      }
      return '';
    } else {
      return string;
    }
  }

  List<HtmlParserNode> _pipeFunctionForNodes(
    List<HtmlParserNode> nodes,
    Rule rule,
  ) {
    final function = rule.function;
    if (rule.function.startsWith('sublist')) {
      final paramsString = _getParamsString(function);
      final params = paramsString.split(',');
      final start = int.parse(params.first.trim());
      final end = params.length >= 2 ? int.parse(params.last.trim()) : null;
      return nodes.sublist(start, end);
    } else if (rule.function.startsWith('reversed')) {
      return nodes.reversed.toList();
    } else {
      return nodes;
    }
  }

  String _pipeRule(HtmlParserNode node, Rule rule) {
    if (node.xpathNode != null) {
      final nodes = node.xpathNode!.queryXPath(rule.rule).nodes;
      String? result;
      switch (rule.attribute) {
        case 'html':
          result = nodes.map((item) => item.node.parent?.innerHtml).join();
          break;
        case 'text':
          result = nodes.map((item) => item.text).join('\n');
          break;
        default:
          result = nodes.map((item) => item.attributes[rule.attribute]).join();
          break;
      }
      return result;
    } else {
      final match = JsonPath(rule.rule).read(node.jsonNode!);
      if (match.isNotEmpty) {
        return match.first.value.toString();
      } else {
        return '';
      }
    }
  }

  List<HtmlParserNode> _pipeRuleForNodes(HtmlParserNode node, Rule rule) {
    if (node.xpathNode != null) {
      final nodes = node.xpathNode!.queryXPath(rule.rule).nodes;
      return nodes.map((item) => HtmlParserNode()..xpathNode = item).toList();
    } else {
      final match = JsonPath(rule.rule).read(node.jsonNode!);
      if (match.isNotEmpty) {
        final json = match.first.value as List<dynamic>;
        return json.map((e) => HtmlParserNode()..jsonNode = e).toList();
      } else {
        return <HtmlParserNode>[];
      }
    }
  }

  String _getParamsString(String function) {
    final patterns = function.split('(');
    if (patterns.isEmpty) return '';
    final body = patterns.first;
    return function.substring(body.length + 1, function.length - 1);
  }
}

class HtmlParserNode {
  XPathNode<Node>? xpathNode;
  Map<String, dynamic>? jsonNode;
}

class Rule {
  String attribute = 'nodes';
  String function = '';
  String protocol = 'xpath';
  String rule = '';

  Rule.from({required String value}) {
    attribute = value.split('@').last;
    const unsupportedAttribute = ['class', 'id'];
    if (unsupportedAttribute.contains(attribute)) {
      attribute = '';
    }
    if (value.startsWith('function:') || value.startsWith('dart.')) {
      attribute = '';
      protocol = 'function';
      function = value.replaceAll('function:', '').replaceAll('dart.', '');
    } else if (value.startsWith(r'$')) {
      protocol = 'jsonpath';
      rule = value;
    } else {
      rule = value.replaceAll('$protocol:', '').replaceAll('@$attribute', '');
    }
  }

  @override
  String toString() {
    return {
      'attribute': attribute,
      'function': function,
      'protocol': protocol,
      'rule': rule,
    }.toString();
  }
}
