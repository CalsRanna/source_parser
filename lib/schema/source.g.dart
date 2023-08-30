// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSourceCollection on Isar {
  IsarCollection<Source> get sources => this.collection();
}

const SourceSchema = CollectionSchema(
  name: r'sources',
  id: -8474198948352137446,
  properties: {
    r'catalogue_chapters': PropertySchema(
      id: 0,
      name: r'catalogue_chapters',
      type: IsarType.string,
    ),
    r'catalogue_method': PropertySchema(
      id: 1,
      name: r'catalogue_method',
      type: IsarType.string,
    ),
    r'catalogue_name': PropertySchema(
      id: 2,
      name: r'catalogue_name',
      type: IsarType.string,
    ),
    r'catalogue_pagination': PropertySchema(
      id: 3,
      name: r'catalogue_pagination',
      type: IsarType.string,
    ),
    r'catalogue_updated_at': PropertySchema(
      id: 4,
      name: r'catalogue_updated_at',
      type: IsarType.string,
    ),
    r'catalogue_url': PropertySchema(
      id: 5,
      name: r'catalogue_url',
      type: IsarType.string,
    ),
    r'charset': PropertySchema(
      id: 6,
      name: r'charset',
      type: IsarType.string,
    ),
    r'comment': PropertySchema(
      id: 7,
      name: r'comment',
      type: IsarType.string,
    ),
    r'content_content': PropertySchema(
      id: 8,
      name: r'content_content',
      type: IsarType.string,
    ),
    r'content_method': PropertySchema(
      id: 9,
      name: r'content_method',
      type: IsarType.string,
    ),
    r'content_pagination': PropertySchema(
      id: 10,
      name: r'content_pagination',
      type: IsarType.string,
    ),
    r'enabled': PropertySchema(
      id: 11,
      name: r'enabled',
      type: IsarType.bool,
    ),
    r'explore_enabled': PropertySchema(
      id: 12,
      name: r'explore_enabled',
      type: IsarType.bool,
    ),
    r'explore_json': PropertySchema(
      id: 13,
      name: r'explore_json',
      type: IsarType.string,
    ),
    r'header': PropertySchema(
      id: 14,
      name: r'header',
      type: IsarType.string,
    ),
    r'information_author': PropertySchema(
      id: 15,
      name: r'information_author',
      type: IsarType.string,
    ),
    r'information_catalogue_url': PropertySchema(
      id: 16,
      name: r'information_catalogue_url',
      type: IsarType.string,
    ),
    r'information_category': PropertySchema(
      id: 17,
      name: r'information_category',
      type: IsarType.string,
    ),
    r'information_cover': PropertySchema(
      id: 18,
      name: r'information_cover',
      type: IsarType.string,
    ),
    r'information_introduction': PropertySchema(
      id: 19,
      name: r'information_introduction',
      type: IsarType.string,
    ),
    r'information_latest_chapter': PropertySchema(
      id: 20,
      name: r'information_latest_chapter',
      type: IsarType.string,
    ),
    r'information_method': PropertySchema(
      id: 21,
      name: r'information_method',
      type: IsarType.string,
    ),
    r'information_name': PropertySchema(
      id: 22,
      name: r'information_name',
      type: IsarType.string,
    ),
    r'information_word_count': PropertySchema(
      id: 23,
      name: r'information_word_count',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 24,
      name: r'name',
      type: IsarType.string,
    ),
    r'search_author': PropertySchema(
      id: 25,
      name: r'search_author',
      type: IsarType.string,
    ),
    r'search_books': PropertySchema(
      id: 26,
      name: r'search_books',
      type: IsarType.string,
    ),
    r'search_category': PropertySchema(
      id: 27,
      name: r'search_category',
      type: IsarType.string,
    ),
    r'search_cover': PropertySchema(
      id: 28,
      name: r'search_cover',
      type: IsarType.string,
    ),
    r'search_information_url': PropertySchema(
      id: 29,
      name: r'search_information_url',
      type: IsarType.string,
    ),
    r'search_introduction': PropertySchema(
      id: 30,
      name: r'search_introduction',
      type: IsarType.string,
    ),
    r'search_latest_chapter': PropertySchema(
      id: 31,
      name: r'search_latest_chapter',
      type: IsarType.string,
    ),
    r'search_method': PropertySchema(
      id: 32,
      name: r'search_method',
      type: IsarType.string,
    ),
    r'search_name': PropertySchema(
      id: 33,
      name: r'search_name',
      type: IsarType.string,
    ),
    r'search_url': PropertySchema(
      id: 34,
      name: r'search_url',
      type: IsarType.string,
    ),
    r'search_word_count': PropertySchema(
      id: 35,
      name: r'search_word_count',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 36,
      name: r'type',
      type: IsarType.string,
    ),
    r'url': PropertySchema(
      id: 37,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _sourceEstimateSize,
  serialize: _sourceSerialize,
  deserialize: _sourceDeserialize,
  deserializeProp: _sourceDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sourceGetId,
  getLinks: _sourceGetLinks,
  attach: _sourceAttach,
  version: '3.1.0+1',
);

int _sourceEstimateSize(
  Source object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.catalogueChapters.length * 3;
  bytesCount += 3 + object.catalogueMethod.length * 3;
  bytesCount += 3 + object.catalogueName.length * 3;
  bytesCount += 3 + object.cataloguePagination.length * 3;
  bytesCount += 3 + object.catalogueUpdatedAt.length * 3;
  bytesCount += 3 + object.catalogueUrl.length * 3;
  bytesCount += 3 + object.charset.length * 3;
  bytesCount += 3 + object.comment.length * 3;
  bytesCount += 3 + object.contentContent.length * 3;
  bytesCount += 3 + object.contentMethod.length * 3;
  bytesCount += 3 + object.contentPagination.length * 3;
  bytesCount += 3 + object.exploreJson.length * 3;
  bytesCount += 3 + object.header.length * 3;
  bytesCount += 3 + object.informationAuthor.length * 3;
  bytesCount += 3 + object.informationCatalogueUrl.length * 3;
  bytesCount += 3 + object.informationCategory.length * 3;
  bytesCount += 3 + object.informationCover.length * 3;
  bytesCount += 3 + object.informationIntroduction.length * 3;
  bytesCount += 3 + object.informationLatestChapter.length * 3;
  bytesCount += 3 + object.informationMethod.length * 3;
  bytesCount += 3 + object.informationName.length * 3;
  bytesCount += 3 + object.informationWordCount.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.searchAuthor.length * 3;
  bytesCount += 3 + object.searchBooks.length * 3;
  bytesCount += 3 + object.searchCategory.length * 3;
  bytesCount += 3 + object.searchCover.length * 3;
  bytesCount += 3 + object.searchInformationUrl.length * 3;
  bytesCount += 3 + object.searchIntroduction.length * 3;
  bytesCount += 3 + object.searchLatestChapter.length * 3;
  bytesCount += 3 + object.searchMethod.length * 3;
  bytesCount += 3 + object.searchName.length * 3;
  bytesCount += 3 + object.searchUrl.length * 3;
  bytesCount += 3 + object.searchWordCount.length * 3;
  bytesCount += 3 + object.type.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _sourceSerialize(
  Source object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.catalogueChapters);
  writer.writeString(offsets[1], object.catalogueMethod);
  writer.writeString(offsets[2], object.catalogueName);
  writer.writeString(offsets[3], object.cataloguePagination);
  writer.writeString(offsets[4], object.catalogueUpdatedAt);
  writer.writeString(offsets[5], object.catalogueUrl);
  writer.writeString(offsets[6], object.charset);
  writer.writeString(offsets[7], object.comment);
  writer.writeString(offsets[8], object.contentContent);
  writer.writeString(offsets[9], object.contentMethod);
  writer.writeString(offsets[10], object.contentPagination);
  writer.writeBool(offsets[11], object.enabled);
  writer.writeBool(offsets[12], object.exploreEnabled);
  writer.writeString(offsets[13], object.exploreJson);
  writer.writeString(offsets[14], object.header);
  writer.writeString(offsets[15], object.informationAuthor);
  writer.writeString(offsets[16], object.informationCatalogueUrl);
  writer.writeString(offsets[17], object.informationCategory);
  writer.writeString(offsets[18], object.informationCover);
  writer.writeString(offsets[19], object.informationIntroduction);
  writer.writeString(offsets[20], object.informationLatestChapter);
  writer.writeString(offsets[21], object.informationMethod);
  writer.writeString(offsets[22], object.informationName);
  writer.writeString(offsets[23], object.informationWordCount);
  writer.writeString(offsets[24], object.name);
  writer.writeString(offsets[25], object.searchAuthor);
  writer.writeString(offsets[26], object.searchBooks);
  writer.writeString(offsets[27], object.searchCategory);
  writer.writeString(offsets[28], object.searchCover);
  writer.writeString(offsets[29], object.searchInformationUrl);
  writer.writeString(offsets[30], object.searchIntroduction);
  writer.writeString(offsets[31], object.searchLatestChapter);
  writer.writeString(offsets[32], object.searchMethod);
  writer.writeString(offsets[33], object.searchName);
  writer.writeString(offsets[34], object.searchUrl);
  writer.writeString(offsets[35], object.searchWordCount);
  writer.writeString(offsets[36], object.type);
  writer.writeString(offsets[37], object.url);
}

Source _sourceDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Source();
  object.catalogueChapters = reader.readString(offsets[0]);
  object.catalogueMethod = reader.readString(offsets[1]);
  object.catalogueName = reader.readString(offsets[2]);
  object.cataloguePagination = reader.readString(offsets[3]);
  object.catalogueUpdatedAt = reader.readString(offsets[4]);
  object.catalogueUrl = reader.readString(offsets[5]);
  object.charset = reader.readString(offsets[6]);
  object.comment = reader.readString(offsets[7]);
  object.contentContent = reader.readString(offsets[8]);
  object.contentMethod = reader.readString(offsets[9]);
  object.contentPagination = reader.readString(offsets[10]);
  object.enabled = reader.readBool(offsets[11]);
  object.exploreEnabled = reader.readBool(offsets[12]);
  object.exploreJson = reader.readString(offsets[13]);
  object.header = reader.readString(offsets[14]);
  object.id = id;
  object.informationAuthor = reader.readString(offsets[15]);
  object.informationCatalogueUrl = reader.readString(offsets[16]);
  object.informationCategory = reader.readString(offsets[17]);
  object.informationCover = reader.readString(offsets[18]);
  object.informationIntroduction = reader.readString(offsets[19]);
  object.informationLatestChapter = reader.readString(offsets[20]);
  object.informationMethod = reader.readString(offsets[21]);
  object.informationName = reader.readString(offsets[22]);
  object.informationWordCount = reader.readString(offsets[23]);
  object.name = reader.readString(offsets[24]);
  object.searchAuthor = reader.readString(offsets[25]);
  object.searchBooks = reader.readString(offsets[26]);
  object.searchCategory = reader.readString(offsets[27]);
  object.searchCover = reader.readString(offsets[28]);
  object.searchInformationUrl = reader.readString(offsets[29]);
  object.searchIntroduction = reader.readString(offsets[30]);
  object.searchLatestChapter = reader.readString(offsets[31]);
  object.searchMethod = reader.readString(offsets[32]);
  object.searchName = reader.readString(offsets[33]);
  object.searchUrl = reader.readString(offsets[34]);
  object.searchWordCount = reader.readString(offsets[35]);
  object.type = reader.readString(offsets[36]);
  object.url = reader.readString(offsets[37]);
  return object;
}

P _sourceDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readString(offset)) as P;
    case 25:
      return (reader.readString(offset)) as P;
    case 26:
      return (reader.readString(offset)) as P;
    case 27:
      return (reader.readString(offset)) as P;
    case 28:
      return (reader.readString(offset)) as P;
    case 29:
      return (reader.readString(offset)) as P;
    case 30:
      return (reader.readString(offset)) as P;
    case 31:
      return (reader.readString(offset)) as P;
    case 32:
      return (reader.readString(offset)) as P;
    case 33:
      return (reader.readString(offset)) as P;
    case 34:
      return (reader.readString(offset)) as P;
    case 35:
      return (reader.readString(offset)) as P;
    case 36:
      return (reader.readString(offset)) as P;
    case 37:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sourceGetId(Source object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sourceGetLinks(Source object) {
  return [];
}

void _sourceAttach(IsarCollection<dynamic> col, Id id, Source object) {
  object.id = id;
}

extension SourceQueryWhereSort on QueryBuilder<Source, Source, QWhere> {
  QueryBuilder<Source, Source, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SourceQueryWhere on QueryBuilder<Source, Source, QWhereClause> {
  QueryBuilder<Source, Source, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Source, Source, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Source, Source, QAfterWhereClause> idBetween(
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

extension SourceQueryFilter on QueryBuilder<Source, Source, QFilterCondition> {
  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueChaptersEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_chapters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueChaptersGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogue_chapters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueChaptersLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogue_chapters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueChaptersBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogue_chapters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueChaptersStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogue_chapters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueChaptersEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogue_chapters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueChaptersContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogue_chapters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueChaptersMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogue_chapters',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueChaptersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_chapters',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueChaptersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogue_chapters',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogue_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogue_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogue_method',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogue_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogue_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueMethodContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogue_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueMethodMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogue_method',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_method',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogue_method',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogue_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogue_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogue_name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogue_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogue_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogue_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogue_name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_name',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogue_name',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogue_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogue_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogue_pagination',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogue_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogue_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogue_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogue_pagination',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_pagination',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      cataloguePaginationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogue_pagination',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUpdatedAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_updated_at',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueUpdatedAtGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogue_updated_at',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueUpdatedAtLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogue_updated_at',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUpdatedAtBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogue_updated_at',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueUpdatedAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogue_updated_at',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueUpdatedAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogue_updated_at',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueUpdatedAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogue_updated_at',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUpdatedAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogue_updated_at',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueUpdatedAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_updated_at',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      catalogueUpdatedAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogue_updated_at',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'catalogue_url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'catalogue_url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'catalogue_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> catalogueUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'catalogue_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'charset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'charset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'charset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'charset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'charset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'charset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'charset',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'charset',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'charset',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> charsetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'charset',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'comment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'comment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'comment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> commentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'comment',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentContentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentContentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentContentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentContentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentContentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content_content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentContentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content_content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentContentContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content_content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentContentMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content_content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_content',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      contentContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content_content',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_method',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentMethodContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentMethodMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content_method',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_method',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      contentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content_method',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentPaginationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      contentPaginationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentPaginationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentPaginationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_pagination',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      contentPaginationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentPaginationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentPaginationContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content_pagination',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> contentPaginationMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content_pagination',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      contentPaginationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_pagination',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      contentPaginationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content_pagination',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> enabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreEnabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explore_enabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explore_json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'explore_json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'explore_json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'explore_json',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'explore_json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'explore_json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'explore_json',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'explore_json',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explore_json',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> exploreJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'explore_json',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'header',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'header',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'header',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'header',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> headerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'header',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> informationAuthorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationAuthorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'information_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationAuthorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'information_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationAuthorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'information_author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationAuthorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'information_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationAuthorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'information_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationAuthorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'information_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationAuthorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'information_author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationAuthorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_author',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationAuthorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'information_author',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'information_catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'information_catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'information_catalogue_url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'information_catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'information_catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'information_catalogue_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'information_catalogue_url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_catalogue_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCatalogueUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'information_catalogue_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'information_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'information_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'information_category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'information_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'information_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'information_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'information_category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_category',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'information_category',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationCoverEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCoverGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'information_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationCoverLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'information_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationCoverBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'information_cover',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCoverStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'information_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationCoverEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'information_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationCoverContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'information_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationCoverMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'information_cover',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCoverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_cover',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationCoverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'information_cover',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'information_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'information_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'information_introduction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'information_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'information_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'information_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'information_introduction',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_introduction',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationIntroductionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'information_introduction',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'information_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'information_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'information_latest_chapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'information_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'information_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'information_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'information_latest_chapter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_latest_chapter',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationLatestChapterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'information_latest_chapter',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'information_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'information_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'information_method',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'information_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'information_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationMethodContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'information_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationMethodMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'information_method',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_method',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'information_method',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'information_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'information_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'information_name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'information_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'information_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'information_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'information_name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> informationNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_name',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'information_name',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'information_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'information_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'information_word_count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'information_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'information_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'information_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'information_word_count',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'information_word_count',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      informationWordCountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'information_word_count',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_author',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_author',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_author',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_author',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchAuthorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_author',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_books',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_books',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_books',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_books',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_books',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_books',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_books',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_books',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_books',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchBooksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_books',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCategoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCategoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCategoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCategoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCategoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCategoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCategoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCategoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCategoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_category',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchCategoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_category',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_cover',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_cover',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_cover',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_cover',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchCoverIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_cover',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_information_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_information_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_information_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_information_url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_information_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_information_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_information_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_information_url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_information_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchInformationUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_information_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchIntroductionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchIntroductionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchIntroductionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchIntroductionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_introduction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchIntroductionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchIntroductionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchIntroductionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_introduction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchIntroductionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_introduction',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchIntroductionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_introduction',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchIntroductionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_introduction',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_latest_chapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_latest_chapter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_latest_chapter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_latest_chapter',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchLatestChapterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_latest_chapter',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_method',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_method',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_method',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_method',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_name',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_name',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_url',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchWordCountEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchWordCountGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'search_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchWordCountLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'search_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchWordCountBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'search_word_count',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchWordCountStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'search_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchWordCountEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'search_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchWordCountContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'search_word_count',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchWordCountMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'search_word_count',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> searchWordCountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'search_word_count',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition>
      searchWordCountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'search_word_count',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> urlEqualTo(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> urlGreaterThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> urlLessThan(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> urlBetween(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> urlStartsWith(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> urlEndsWith(
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

  QueryBuilder<Source, Source, QAfterFilterCondition> urlContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> urlMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<Source, Source, QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension SourceQueryObject on QueryBuilder<Source, Source, QFilterCondition> {}

extension SourceQueryLinks on QueryBuilder<Source, Source, QFilterCondition> {}

extension SourceQuerySortBy on QueryBuilder<Source, Source, QSortBy> {
  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_chapters', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_chapters', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_method', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_method', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCataloguePagination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_pagination', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCataloguePaginationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_pagination', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_updated_at', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_updated_at', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCatalogueUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_url', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCharset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'charset', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCharsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'charset', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByContentContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_content', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByContentContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_content', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByContentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_method', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByContentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_method', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByContentPagination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_pagination', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByContentPaginationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_pagination', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByExploreEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explore_enabled', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByExploreEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explore_enabled', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByExploreJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explore_json', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByExploreJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explore_json', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByHeader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByHeaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_author', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_author', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationCatalogueUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_catalogue_url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy>
      sortByInformationCatalogueUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_catalogue_url', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_category', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_category', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationCover() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_cover', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationCoverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_cover', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationIntroduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_introduction', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy>
      sortByInformationIntroductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_introduction', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationLatestChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_latest_chapter', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy>
      sortByInformationLatestChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_latest_chapter', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_method', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_method', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationWordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_word_count', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByInformationWordCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_word_count', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_author', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_author', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchBooks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_books', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchBooksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_books', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_category', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_category', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchCover() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_cover', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchCoverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_cover', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchInformationUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_information_url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchInformationUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_information_url', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchIntroduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_introduction', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchIntroductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_introduction', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchLatestChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_latest_chapter', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchLatestChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_latest_chapter', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_method', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_method', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_url', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchWordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_word_count', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortBySearchWordCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_word_count', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension SourceQuerySortThenBy on QueryBuilder<Source, Source, QSortThenBy> {
  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueChapters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_chapters', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueChaptersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_chapters', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_method', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_method', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCataloguePagination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_pagination', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCataloguePaginationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_pagination', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_updated_at', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_updated_at', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCatalogueUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'catalogue_url', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCharset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'charset', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCharsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'charset', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByComment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByCommentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'comment', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByContentContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_content', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByContentContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_content', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByContentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_method', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByContentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_method', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByContentPagination() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_pagination', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByContentPaginationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_pagination', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enabled', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByExploreEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explore_enabled', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByExploreEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explore_enabled', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByExploreJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explore_json', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByExploreJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explore_json', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByHeader() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByHeaderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_author', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_author', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationCatalogueUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_catalogue_url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy>
      thenByInformationCatalogueUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_catalogue_url', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_category', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_category', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationCover() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_cover', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationCoverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_cover', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationIntroduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_introduction', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy>
      thenByInformationIntroductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_introduction', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationLatestChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_latest_chapter', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy>
      thenByInformationLatestChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_latest_chapter', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_method', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_method', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationWordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_word_count', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByInformationWordCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'information_word_count', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchAuthor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_author', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchAuthorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_author', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchBooks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_books', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchBooksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_books', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_category', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_category', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchCover() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_cover', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchCoverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_cover', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchInformationUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_information_url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchInformationUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_information_url', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchIntroduction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_introduction', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchIntroductionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_introduction', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchLatestChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_latest_chapter', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchLatestChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_latest_chapter', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_method', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_method', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_name', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_name', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_url', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchWordCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_word_count', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenBySearchWordCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'search_word_count', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<Source, Source, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension SourceQueryWhereDistinct on QueryBuilder<Source, Source, QDistinct> {
  QueryBuilder<Source, Source, QDistinct> distinctByCatalogueChapters(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogue_chapters',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByCatalogueMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogue_method',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByCatalogueName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogue_name',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByCataloguePagination(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogue_pagination',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByCatalogueUpdatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogue_updated_at',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByCatalogueUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'catalogue_url',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByCharset(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'charset', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByComment(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'comment', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByContentContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_content',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByContentMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_method',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByContentPagination(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_pagination',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enabled');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByExploreEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'explore_enabled');
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByExploreJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'explore_json', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByHeader(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByInformationAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'information_author',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByInformationCatalogueUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'information_catalogue_url',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByInformationCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'information_category',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByInformationCover(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'information_cover',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByInformationIntroduction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'information_introduction',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByInformationLatestChapter(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'information_latest_chapter',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByInformationMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'information_method',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByInformationName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'information_name',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByInformationWordCount(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'information_word_count',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchAuthor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_author',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchBooks(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_books', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_category',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchCover(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_cover', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchInformationUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_information_url',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchIntroduction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_introduction',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchLatestChapter(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_latest_chapter',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_method',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_url', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctBySearchWordCount(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'search_word_count',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Source, Source, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension SourceQueryProperty on QueryBuilder<Source, Source, QQueryProperty> {
  QueryBuilder<Source, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> catalogueChaptersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogue_chapters');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> catalogueMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogue_method');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> catalogueNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogue_name');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> cataloguePaginationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogue_pagination');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> catalogueUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogue_updated_at');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> catalogueUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'catalogue_url');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> charsetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'charset');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> commentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'comment');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> contentContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_content');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> contentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_method');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> contentPaginationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_pagination');
    });
  }

  QueryBuilder<Source, bool, QQueryOperations> enabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enabled');
    });
  }

  QueryBuilder<Source, bool, QQueryOperations> exploreEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'explore_enabled');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> exploreJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'explore_json');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> headerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> informationAuthorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'information_author');
    });
  }

  QueryBuilder<Source, String, QQueryOperations>
      informationCatalogueUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'information_catalogue_url');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> informationCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'information_category');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> informationCoverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'information_cover');
    });
  }

  QueryBuilder<Source, String, QQueryOperations>
      informationIntroductionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'information_introduction');
    });
  }

  QueryBuilder<Source, String, QQueryOperations>
      informationLatestChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'information_latest_chapter');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> informationMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'information_method');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> informationNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'information_name');
    });
  }

  QueryBuilder<Source, String, QQueryOperations>
      informationWordCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'information_word_count');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchAuthorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_author');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchBooksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_books');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchCategoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_category');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchCoverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_cover');
    });
  }

  QueryBuilder<Source, String, QQueryOperations>
      searchInformationUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_information_url');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchIntroductionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_introduction');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchLatestChapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_latest_chapter');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_method');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_name');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_url');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> searchWordCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'search_word_count');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Source, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}
