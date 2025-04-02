// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_source.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAvailableSourceCollection on Isar {
  IsarCollection<AvailableSource> get availableSources => this.collection();
}

const AvailableSourceSchema = CollectionSchema(
  name: r'available_sources',
  id: 2456530648758287462,
  properties: {
    r'book_id': PropertySchema(
      id: 0,
      name: r'book_id',
      type: IsarType.long,
    ),
    r'latest_chapter': PropertySchema(
      id: 1,
      name: r'latest_chapter',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 2,
      name: r'name',
      type: IsarType.string,
    ),
    r'url': PropertySchema(
      id: 3,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _availableSourceEstimateSize,
  serialize: _availableSourceSerialize,
  deserialize: _availableSourceDeserialize,
  deserializeProp: _availableSourceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _availableSourceGetId,
  getLinks: _availableSourceGetLinks,
  attach: _availableSourceAttach,
  version: '3.1.8',
);

int _availableSourceEstimateSize(
  AvailableSource object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.latestChapter.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _availableSourceSerialize(
  AvailableSource object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bookId);
  writer.writeString(offsets[1], object.latestChapter);
  writer.writeString(offsets[2], object.name);
  writer.writeString(offsets[3], object.url);
}

AvailableSource _availableSourceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AvailableSource();
  object.bookId = reader.readLong(offsets[0]);
  object.id = id;
  object.latestChapter = reader.readString(offsets[1]);
  object.name = reader.readString(offsets[2]);
  object.url = reader.readString(offsets[3]);
  return object;
}

P _availableSourceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _availableSourceGetId(AvailableSource object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _availableSourceGetLinks(AvailableSource object) {
  return [];
}

void _availableSourceAttach(
    IsarCollection<dynamic> col, Id id, AvailableSource object) {
  object.id = id;
}

extension AvailableSourceQueryWhereSort
    on QueryBuilder<AvailableSource, AvailableSource, QWhere> {
  QueryBuilder<AvailableSource, AvailableSource, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AvailableSourceQueryWhere
    on QueryBuilder<AvailableSource, AvailableSource, QWhereClause> {
  QueryBuilder<AvailableSource, AvailableSource, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<AvailableSource, AvailableSource, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterWhereClause> idBetween(
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

extension AvailableSourceQueryFilter
    on QueryBuilder<AvailableSource, AvailableSource, QFilterCondition> {
  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      bookIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'book_id',
        value: value,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      bookIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'book_id',
        value: value,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      bookIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'book_id',
        value: value,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      bookIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'book_id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
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

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      idLessThan(
    Id value, {
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

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latest_chapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'latest_chapter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latest_chapter',
        value: '',
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      latestChapterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'latest_chapter',
        value: '',
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterFilterCondition>
      urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension AvailableSourceQueryObject
    on QueryBuilder<AvailableSource, AvailableSource, QFilterCondition> {}

extension AvailableSourceQueryLinks
    on QueryBuilder<AvailableSource, AvailableSource, QFilterCondition> {}

extension AvailableSourceQuerySortBy
    on QueryBuilder<AvailableSource, AvailableSource, QSortBy> {
  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> sortByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book_id', Sort.asc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy>
      sortByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book_id', Sort.desc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy>
      sortByLatestChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latest_chapter', Sort.asc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy>
      sortByLatestChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latest_chapter', Sort.desc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension AvailableSourceQuerySortThenBy
    on QueryBuilder<AvailableSource, AvailableSource, QSortThenBy> {
  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> thenByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book_id', Sort.asc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy>
      thenByBookIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book_id', Sort.desc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy>
      thenByLatestChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latest_chapter', Sort.asc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy>
      thenByLatestChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latest_chapter', Sort.desc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension AvailableSourceQueryWhereDistinct
    on QueryBuilder<AvailableSource, AvailableSource, QDistinct> {
  QueryBuilder<AvailableSource, AvailableSource, QDistinct> distinctByBookId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'book_id');
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QDistinct>
      distinctByLatestChapter({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latest_chapter',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AvailableSource, AvailableSource, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension AvailableSourceQueryProperty
    on QueryBuilder<AvailableSource, AvailableSource, QQueryProperty> {
  QueryBuilder<AvailableSource, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AvailableSource, int, QQueryOperations> bookIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'book_id');
    });
  }

  QueryBuilder<AvailableSource, String, QQueryOperations>
      latestChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latest_chapter');
    });
  }

  QueryBuilder<AvailableSource, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<AvailableSource, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}
