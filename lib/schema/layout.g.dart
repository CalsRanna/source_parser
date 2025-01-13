// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLayoutCollection on Isar {
  IsarCollection<Layout> get layouts => this.collection();
}

const LayoutSchema = CollectionSchema(
  name: r'layouts',
  id: 1755418280096907717,
  properties: {
    r'slot_0': PropertySchema(
      id: 0,
      name: r'slot_0',
      type: IsarType.string,
    ),
    r'slot_1': PropertySchema(
      id: 1,
      name: r'slot_1',
      type: IsarType.string,
    ),
    r'slot_2': PropertySchema(
      id: 2,
      name: r'slot_2',
      type: IsarType.string,
    ),
    r'slot_3': PropertySchema(
      id: 3,
      name: r'slot_3',
      type: IsarType.string,
    ),
    r'slot_4': PropertySchema(
      id: 4,
      name: r'slot_4',
      type: IsarType.string,
    ),
    r'slot_5': PropertySchema(
      id: 5,
      name: r'slot_5',
      type: IsarType.string,
    ),
    r'slot_6': PropertySchema(
      id: 6,
      name: r'slot_6',
      type: IsarType.string,
    )
  },
  estimateSize: _layoutEstimateSize,
  serialize: _layoutSerialize,
  deserialize: _layoutDeserialize,
  deserializeProp: _layoutDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _layoutGetId,
  getLinks: _layoutGetLinks,
  attach: _layoutAttach,
  version: '3.1.8',
);

int _layoutEstimateSize(
  Layout object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.slot0.length * 3;
  bytesCount += 3 + object.slot1.length * 3;
  bytesCount += 3 + object.slot2.length * 3;
  bytesCount += 3 + object.slot3.length * 3;
  bytesCount += 3 + object.slot4.length * 3;
  bytesCount += 3 + object.slot5.length * 3;
  bytesCount += 3 + object.slot6.length * 3;
  return bytesCount;
}

void _layoutSerialize(
  Layout object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.slot0);
  writer.writeString(offsets[1], object.slot1);
  writer.writeString(offsets[2], object.slot2);
  writer.writeString(offsets[3], object.slot3);
  writer.writeString(offsets[4], object.slot4);
  writer.writeString(offsets[5], object.slot5);
  writer.writeString(offsets[6], object.slot6);
}

Layout _layoutDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Layout(
    slot0: reader.readStringOrNull(offsets[0]) ?? '',
    slot1: reader.readStringOrNull(offsets[1]) ?? '',
    slot2: reader.readStringOrNull(offsets[2]) ?? '',
    slot3: reader.readStringOrNull(offsets[3]) ?? '',
    slot4: reader.readStringOrNull(offsets[4]) ?? '',
    slot5: reader.readStringOrNull(offsets[5]) ?? '',
    slot6: reader.readStringOrNull(offsets[6]) ?? '',
  );
  object.id = id;
  return object;
}

P _layoutDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 1:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 2:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 3:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 4:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 5:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 6:
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _layoutGetId(Layout object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _layoutGetLinks(Layout object) {
  return [];
}

void _layoutAttach(IsarCollection<dynamic> col, Id id, Layout object) {
  object.id = id;
}

extension LayoutQueryWhereSort on QueryBuilder<Layout, Layout, QWhere> {
  QueryBuilder<Layout, Layout, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LayoutQueryWhere on QueryBuilder<Layout, Layout, QWhereClause> {
  QueryBuilder<Layout, Layout, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Layout, Layout, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LayoutQueryFilter on QueryBuilder<Layout, Layout, QFilterCondition> {
  QueryBuilder<Layout, Layout, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_0',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slot_0',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slot_0',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slot_0',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slot_0',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slot_0',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slot_0',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slot_0',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_0',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot0IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slot_0',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slot_1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slot_1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slot_1',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slot_1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slot_1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slot_1',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slot_1',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_1',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot1IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slot_1',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slot_2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slot_2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slot_2',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slot_2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slot_2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slot_2',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slot_2',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_2',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot2IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slot_2',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slot_3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slot_3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slot_3',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slot_3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slot_3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slot_3',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slot_3',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_3',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot3IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slot_3',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_4',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slot_4',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slot_4',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slot_4',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slot_4',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slot_4',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slot_4',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slot_4',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_4',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot4IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slot_4',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slot_5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slot_5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slot_5',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slot_5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slot_5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slot_5',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slot_5',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_5',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot5IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slot_5',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6EqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_6',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6GreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slot_6',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6LessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slot_6',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6Between(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slot_6',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6StartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slot_6',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6EndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slot_6',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6Contains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slot_6',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6Matches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slot_6',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6IsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slot_6',
        value: '',
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> slot6IsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slot_6',
        value: '',
      ));
    });
  }
}

extension LayoutQueryObject on QueryBuilder<Layout, Layout, QFilterCondition> {}

extension LayoutQueryLinks on QueryBuilder<Layout, Layout, QFilterCondition> {}

extension LayoutQuerySortBy on QueryBuilder<Layout, Layout, QSortBy> {
  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot0() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_0', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot0Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_0', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_1', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_1', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_2', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_2', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_3', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_3', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot4() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_4', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot4Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_4', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot5() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_5', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot5Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_5', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot6() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_6', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortBySlot6Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_6', Sort.desc);
    });
  }
}

extension LayoutQuerySortThenBy on QueryBuilder<Layout, Layout, QSortThenBy> {
  QueryBuilder<Layout, Layout, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot0() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_0', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot0Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_0', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot1() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_1', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot1Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_1', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot2() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_2', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot2Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_2', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot3() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_3', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot3Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_3', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot4() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_4', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot4Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_4', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot5() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_5', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot5Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_5', Sort.desc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot6() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_6', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenBySlot6Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slot_6', Sort.desc);
    });
  }
}

extension LayoutQueryWhereDistinct on QueryBuilder<Layout, Layout, QDistinct> {
  QueryBuilder<Layout, Layout, QDistinct> distinctBySlot0(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slot_0', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Layout, Layout, QDistinct> distinctBySlot1(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slot_1', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Layout, Layout, QDistinct> distinctBySlot2(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slot_2', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Layout, Layout, QDistinct> distinctBySlot3(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slot_3', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Layout, Layout, QDistinct> distinctBySlot4(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slot_4', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Layout, Layout, QDistinct> distinctBySlot5(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slot_5', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Layout, Layout, QDistinct> distinctBySlot6(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slot_6', caseSensitive: caseSensitive);
    });
  }
}

extension LayoutQueryProperty on QueryBuilder<Layout, Layout, QQueryProperty> {
  QueryBuilder<Layout, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Layout, String, QQueryOperations> slot0Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slot_0');
    });
  }

  QueryBuilder<Layout, String, QQueryOperations> slot1Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slot_1');
    });
  }

  QueryBuilder<Layout, String, QQueryOperations> slot2Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slot_2');
    });
  }

  QueryBuilder<Layout, String, QQueryOperations> slot3Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slot_3');
    });
  }

  QueryBuilder<Layout, String, QQueryOperations> slot4Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slot_4');
    });
  }

  QueryBuilder<Layout, String, QQueryOperations> slot5Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slot_5');
    });
  }

  QueryBuilder<Layout, String, QQueryOperations> slot6Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slot_6');
    });
  }
}
