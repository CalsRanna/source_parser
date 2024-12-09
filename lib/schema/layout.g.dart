// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReaderLayoutCollection on Isar {
  IsarCollection<ReaderLayout> get readerLayouts => this.collection();
}

const ReaderLayoutSchema = CollectionSchema(
  name: r'ReaderLayout',
  id: 8113643544944692526,
  properties: {
    r'appBarButtons': PropertySchema(
      id: 0,
      name: r'appBarButtons',
      type: IsarType.byteList,
      enumMap: _ReaderLayoutappBarButtonsEnumValueMap,
    ),
    r'bottomBarButtons': PropertySchema(
      id: 1,
      name: r'bottomBarButtons',
      type: IsarType.byteList,
      enumMap: _ReaderLayoutbottomBarButtonsEnumValueMap,
    ),
    r'isValid': PropertySchema(
      id: 2,
      name: r'isValid',
      type: IsarType.bool,
    )
  },
  estimateSize: _readerLayoutEstimateSize,
  serialize: _readerLayoutSerialize,
  deserialize: _readerLayoutDeserialize,
  deserializeProp: _readerLayoutDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _readerLayoutGetId,
  getLinks: _readerLayoutGetLinks,
  attach: _readerLayoutAttach,
  version: '3.1.8',
);

int _readerLayoutEstimateSize(
  ReaderLayout object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.appBarButtons.length;
  bytesCount += 3 + object.bottomBarButtons.length;
  return bytesCount;
}

void _readerLayoutSerialize(
  ReaderLayout object,
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

ReaderLayout _readerLayoutDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReaderLayout(
    appBarButtons: reader
            .readByteList(offsets[0])
            ?.map((e) =>
                _ReaderLayoutappBarButtonsValueEnumMap[e] ??
                ButtonPosition.information)
            .toList() ??
        const [],
    bottomBarButtons: reader
            .readByteList(offsets[1])
            ?.map((e) =>
                _ReaderLayoutbottomBarButtonsValueEnumMap[e] ??
                ButtonPosition.information)
            .toList() ??
        const [],
  );
  object.id = id;
  return object;
}

P _readerLayoutDeserializeProp<P>(
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
                  _ReaderLayoutappBarButtonsValueEnumMap[e] ??
                  ButtonPosition.information)
              .toList() ??
          const []) as P;
    case 1:
      return (reader
              .readByteList(offset)
              ?.map((e) =>
                  _ReaderLayoutbottomBarButtonsValueEnumMap[e] ??
                  ButtonPosition.information)
              .toList() ??
          const []) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ReaderLayoutappBarButtonsEnumValueMap = {
  'information': 0,
  'cache': 1,
  'darkMode': 2,
  'catalogue': 3,
  'source': 4,
  'theme': 5,
  'audio': 6,
  'previousChapter': 7,
  'nextChapter': 8,
};
const _ReaderLayoutappBarButtonsValueEnumMap = {
  0: ButtonPosition.information,
  1: ButtonPosition.cache,
  2: ButtonPosition.darkMode,
  3: ButtonPosition.catalogue,
  4: ButtonPosition.source,
  5: ButtonPosition.theme,
  6: ButtonPosition.audio,
  7: ButtonPosition.previousChapter,
  8: ButtonPosition.nextChapter,
};
const _ReaderLayoutbottomBarButtonsEnumValueMap = {
  'information': 0,
  'cache': 1,
  'darkMode': 2,
  'catalogue': 3,
  'source': 4,
  'theme': 5,
  'audio': 6,
  'previousChapter': 7,
  'nextChapter': 8,
};
const _ReaderLayoutbottomBarButtonsValueEnumMap = {
  0: ButtonPosition.information,
  1: ButtonPosition.cache,
  2: ButtonPosition.darkMode,
  3: ButtonPosition.catalogue,
  4: ButtonPosition.source,
  5: ButtonPosition.theme,
  6: ButtonPosition.audio,
  7: ButtonPosition.previousChapter,
  8: ButtonPosition.nextChapter,
};

Id _readerLayoutGetId(ReaderLayout object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _readerLayoutGetLinks(ReaderLayout object) {
  return [];
}

void _readerLayoutAttach(
    IsarCollection<dynamic> col, Id id, ReaderLayout object) {
  object.id = id;
}

extension ReaderLayoutQueryWhereSort
    on QueryBuilder<ReaderLayout, ReaderLayout, QWhere> {
  QueryBuilder<ReaderLayout, ReaderLayout, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReaderLayoutQueryWhere
    on QueryBuilder<ReaderLayout, ReaderLayout, QWhereClause> {
  QueryBuilder<ReaderLayout, ReaderLayout, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterWhereClause> idBetween(
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

extension ReaderLayoutQueryFilter
    on QueryBuilder<ReaderLayout, ReaderLayout, QFilterCondition> {
  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsElementEqualTo(ButtonPosition value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appBarButtons',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsElementGreaterThan(
    ButtonPosition value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appBarButtons',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsElementLessThan(
    ButtonPosition value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appBarButtons',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsElementBetween(
    ButtonPosition lower,
    ButtonPosition upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appBarButtons',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appBarButtons',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appBarButtons',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appBarButtons',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appBarButtons',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appBarButtons',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      appBarButtonsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'appBarButtons',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsElementEqualTo(ButtonPosition value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bottomBarButtons',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsElementGreaterThan(
    ButtonPosition value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bottomBarButtons',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsElementLessThan(
    ButtonPosition value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bottomBarButtons',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsElementBetween(
    ButtonPosition lower,
    ButtonPosition upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bottomBarButtons',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottomBarButtons',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottomBarButtons',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottomBarButtons',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottomBarButtons',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottomBarButtons',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      bottomBarButtonsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'bottomBarButtons',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterFilterCondition>
      isValidEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isValid',
        value: value,
      ));
    });
  }
}

extension ReaderLayoutQueryObject
    on QueryBuilder<ReaderLayout, ReaderLayout, QFilterCondition> {}

extension ReaderLayoutQueryLinks
    on QueryBuilder<ReaderLayout, ReaderLayout, QFilterCondition> {}

extension ReaderLayoutQuerySortBy
    on QueryBuilder<ReaderLayout, ReaderLayout, QSortBy> {
  QueryBuilder<ReaderLayout, ReaderLayout, QAfterSortBy> sortByIsValid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValid', Sort.asc);
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterSortBy> sortByIsValidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValid', Sort.desc);
    });
  }
}

extension ReaderLayoutQuerySortThenBy
    on QueryBuilder<ReaderLayout, ReaderLayout, QSortThenBy> {
  QueryBuilder<ReaderLayout, ReaderLayout, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterSortBy> thenByIsValid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValid', Sort.asc);
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QAfterSortBy> thenByIsValidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isValid', Sort.desc);
    });
  }
}

extension ReaderLayoutQueryWhereDistinct
    on QueryBuilder<ReaderLayout, ReaderLayout, QDistinct> {
  QueryBuilder<ReaderLayout, ReaderLayout, QDistinct>
      distinctByAppBarButtons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appBarButtons');
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QDistinct>
      distinctByBottomBarButtons() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bottomBarButtons');
    });
  }

  QueryBuilder<ReaderLayout, ReaderLayout, QDistinct> distinctByIsValid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isValid');
    });
  }
}

extension ReaderLayoutQueryProperty
    on QueryBuilder<ReaderLayout, ReaderLayout, QQueryProperty> {
  QueryBuilder<ReaderLayout, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReaderLayout, List<ButtonPosition>, QQueryOperations>
      appBarButtonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appBarButtons');
    });
  }

  QueryBuilder<ReaderLayout, List<ButtonPosition>, QQueryOperations>
      bottomBarButtonsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bottomBarButtons');
    });
  }

  QueryBuilder<ReaderLayout, bool, QQueryOperations> isValidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isValid');
    });
  }
}
