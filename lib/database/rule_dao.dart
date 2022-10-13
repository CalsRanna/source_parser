import 'package:floor/floor.dart';

import '../entity/rule.dart';

@dao
abstract class RuleDao {
  @Query('select * from rules where id=:id')
  Future<Rule?> findRuleById(int id);
  @Query('select * from rules where source_id=:sourceId order by name')
  Future<List<Rule>> getRulesBySourceId(int sourceId);
  @Query('select * from rules where name=:name and source_id=:sourceId')
  Future<Rule?> getRuleByNameAndSourceId(String name, int sourceId);
  @Query('select * from rules')
  Future<List<Rule>> getAllRules();
  @insert
  Future<void> insertRule(Rule rule);
  @update
  Future<void> updateRule(Rule rule);
  @Query(
      'delete from rules;update sqlite_sequence set seq=0 where name="rules";')
  Future<void> emptyRules();
}
