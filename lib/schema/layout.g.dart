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
    r'app_bar_buttons': PropertySchema(
      id: 0,
      name: r'app_bar_buttons',
      type: IsarType.byteList,
      enumMap: _LayoutappBarButtonsEnumValueMap,
    ),
    r'bottom_bar_buttons': PropertySchema(
      id: 1,
      name: r'bottom_bar_buttons',
      type: IsarType.byteList,
      enumMap: _LayoutbottomBarButtonsEnumValueMap,
    ),
    r'isValid': PropertySchema(
      id: 2,
      name: r'isValid',
      type: IsarType.bool,
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
  bytesCount += 3 + object.appBarButtons.length;
  bytesCount += 3 + object.bottomBarButtons.length;
  return bytesCount;
}

void _layoutSerialize(
  Layout object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByteList(
      offsets[0], object.appBarButtons.map((e) => e.index).toList());
  writer.writeByteList(
      offsets[1], object.bottomBarButtons.map((e) => e.index).toList());
  writer.writeBool(offsets[2], object.isValid);
}

Layout _layoutDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Layout(
    appBarButtons: reader
            .readByteList(offsets[0])
            ?.map((e) =>
                _LayoutappBarButtonsValueEnumMap[e] ?? ButtonPosition.audio)
            .toList() ??
        const [],
    bottomBarButtons: reader
            .readByteList(offsets[1])
            ?.map((e) =>
                _LayoutbottomBarButtonsValueEnumMap[e] ?? ButtonPosition.audio)
            .toList() ??
        const [],
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
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _LayoutappBarButtonsValueEnumMap[e] ?? ButtonPosition.audio)
              .toList() ??
          const []) as P;
    case 1:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _LayoutbottomBarButtonsValueEnumMap[e] ??
                  ButtonPosition.audio)
              .toList() ??
          const []) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _LayoutappBarButtonsEnumValueMap = {
  'audio': 0,
  'cache': 1,
  'catalogue': 2,
  'darkMode': 3,
  'forceRefresh': 4,
  'information': 5,
  'previousChapter': 6,
  'nextChapter': 7,
  'source': 8,
  'theme': 9,
};
const _LayoutappBarButtonsValueEnumMap = {
  0: ButtonPosition.audio,
  1: ButtonPosition.cache,
  2: ButtonPosition.catalogue,
  3: ButtonPosition.darkMode,
  4: ButtonPosition.forceRefresh,
  5: ButtonPosition.information,
  6: ButtonPosition.previousChapter,
  7: ButtonPosition.nextChapter,
  8: ButtonPosition.source,
  9: ButtonPosition.theme,
};
const _LayoutbottomBarButtonsEnumValueMap = {
  'audio': 0,
  'cache': 1,
  'catalogue': 2,
  'darkMode': 3,
  'forceRefresh': 4,
  'information': 5,
  'previousChapter': 6,
  'nextChapter': 7,
  'source': 8,
  'theme': 9,
};
const _LayoutbottomBarButtonsValueEnumMap = {
  0: ButtonPosition.audio,
  1: ButtonPosition.cache,
  2: ButtonPosition.catalogue,
  3: ButtonPosition.darkMode,
  4: ButtonPosition.forceRefresh,
  5: ButtonPosition.information,
  6: ButtonPosition.previousChapter,
  7: ButtonPosition.nextChapter,
  8: ButtonPosition.source,
  9: ButtonPosition.theme,
};

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
  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      appBarButtonsElementEqualTo(ButtonPosition value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'app_bar_buttons',
        value: value,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      appBarButtonsElementGreaterThan(
    ButtonPosition value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'app_bar_buttons',
        value: value,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      appBarButtonsElementLessThan(
    ButtonPosition value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'app_bar_buttons',
        value: value,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      appBarButtonsElementBetween(
    ButtonPosition lower,
    ButtonPosition upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'app_bar_buttons',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      appBarButtonsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'app_bar_buttons',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition> appBarButtonsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'app_bar_buttons',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      appBarButtonsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'app_bar_buttons',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      appBarButtonsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'app_bar_buttons',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      appBarButtonsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'app_bar_buttons',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      appBarButtonsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'app_bar_buttons',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsElementEqualTo(ButtonPosition value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bottom_bar_buttons',
        value: value,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsElementGreaterThan(
    ButtonPosition value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bottom_bar_buttons',
        value: value,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsElementLessThan(
    ButtonPosition value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bottom_bar_buttons',
        value: value,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsElementBetween(
    ButtonPosition lower,
    ButtonPosition upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bottom_bar_buttons',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottom_bar_buttons',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottom_bar_buttons',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottom_bar_buttons',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottom_bar_buttons',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottom_bar_buttons',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Layout, Layout, QAfterFilterCondition>
      bottomBarButtonsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottom_bar_buttons',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

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

  QueryBuilder<Layout, Layout, QAfterFilterCondition> isValidEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isValid',
        value: value,
      ));
    });
  }
}

extension LayoutQueryObject on QueryBuilder<Layout, Layout, QFilterCondition> {}

extension LayoutQueryLinks on QueryBuilder<Layout, Layout, QFilterCondition> {}

extension LayoutQuerySortBy on QueryBuilder<Layout, Layout, QSortBy> {
  QueryBuilder<Layout, Layout, QAfterSortBy> sortByIsValid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValid', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> sortByIsValidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValid', Sort.desc);
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

  QueryBuilder<Layout, Layout, QAfterSortBy> thenByIsValid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValid', Sort.asc);
    });
  }

  QueryBuilder<Layout, Layout, QAfterSortBy> thenByIsValidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValid', Sort.desc);
    });
  }
}

extension LayoutQueryWhereDistinct on QueryBuilder<Layout, Layout, QDistinct> {
  QueryBuilder<Layout, Layout, QDistinct> distinctByAppBarButtons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'app_bar_buttons');
    });
  }

  QueryBuilder<Layout, Layout, QDistinct> distinctByBottomBarButtons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bottom_bar_buttons');
    });
  }

  QueryBuilder<Layout, Layout, QDistinct> distinctByIsValid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isValid');
    });
  }
}

extension LayoutQueryProperty on QueryBuilder<Layout, Layout, QQueryProperty> {
  QueryBuilder<Layout, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Layout, List<ButtonPosition>, QQueryOperations>
      appBarButtonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'app_bar_buttons');
    });
  }

  QueryBuilder<Layout, List<ButtonPosition>, QQueryOperations>
      bottomBarButtonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bottom_bar_buttons');
    });
  }

  QueryBuilder<Layout, bool, QQueryOperations> isValidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isValid');
    });
  }
}
