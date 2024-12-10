// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetThemeCollection on Isar {
  IsarCollection<Theme> get themes => this.collection();
}

const ThemeSchema = CollectionSchema(
  name: r'themes',
  id: 5413617843239542158,
  properties: {
    r'background_color': PropertySchema(
      id: 0,
      name: r'background_color',
      type: IsarType.long,
    ),
    r'background_image': PropertySchema(
      id: 1,
      name: r'background_image',
      type: IsarType.string,
    ),
    r'chapter_font_size': PropertySchema(
      id: 2,
      name: r'chapter_font_size',
      type: IsarType.double,
    ),
    r'chapter_font_weight': PropertySchema(
      id: 3,
      name: r'chapter_font_weight',
      type: IsarType.long,
    ),
    r'chapter_height': PropertySchema(
      id: 4,
      name: r'chapter_height',
      type: IsarType.double,
    ),
    r'chapter_letter_spacing': PropertySchema(
      id: 5,
      name: r'chapter_letter_spacing',
      type: IsarType.double,
    ),
    r'chapter_word_spacing': PropertySchema(
      id: 6,
      name: r'chapter_word_spacing',
      type: IsarType.double,
    ),
    r'content_color': PropertySchema(
      id: 7,
      name: r'content_color',
      type: IsarType.long,
    ),
    r'content_font_size': PropertySchema(
      id: 8,
      name: r'content_font_size',
      type: IsarType.double,
    ),
    r'content_font_weight': PropertySchema(
      id: 9,
      name: r'content_font_weight',
      type: IsarType.long,
    ),
    r'content_height': PropertySchema(
      id: 10,
      name: r'content_height',
      type: IsarType.double,
    ),
    r'content_letter_spacing': PropertySchema(
      id: 11,
      name: r'content_letter_spacing',
      type: IsarType.double,
    ),
    r'content_padding_bottom': PropertySchema(
      id: 12,
      name: r'content_padding_bottom',
      type: IsarType.double,
    ),
    r'content_padding_left': PropertySchema(
      id: 13,
      name: r'content_padding_left',
      type: IsarType.double,
    ),
    r'content_padding_right': PropertySchema(
      id: 14,
      name: r'content_padding_right',
      type: IsarType.double,
    ),
    r'content_padding_top': PropertySchema(
      id: 15,
      name: r'content_padding_top',
      type: IsarType.double,
    ),
    r'content_word_spacing': PropertySchema(
      id: 16,
      name: r'content_word_spacing',
      type: IsarType.double,
    ),
    r'footer_color': PropertySchema(
      id: 17,
      name: r'footer_color',
      type: IsarType.long,
    ),
    r'footer_font_size': PropertySchema(
      id: 18,
      name: r'footer_font_size',
      type: IsarType.double,
    ),
    r'footer_font_weight': PropertySchema(
      id: 19,
      name: r'footer_font_weight',
      type: IsarType.long,
    ),
    r'footer_height': PropertySchema(
      id: 20,
      name: r'footer_height',
      type: IsarType.double,
    ),
    r'footer_letter_spacing': PropertySchema(
      id: 21,
      name: r'footer_letter_spacing',
      type: IsarType.double,
    ),
    r'footer_padding_bottom': PropertySchema(
      id: 22,
      name: r'footer_padding_bottom',
      type: IsarType.double,
    ),
    r'footer_padding_left': PropertySchema(
      id: 23,
      name: r'footer_padding_left',
      type: IsarType.double,
    ),
    r'footer_padding_right': PropertySchema(
      id: 24,
      name: r'footer_padding_right',
      type: IsarType.double,
    ),
    r'footer_padding_top': PropertySchema(
      id: 25,
      name: r'footer_padding_top',
      type: IsarType.double,
    ),
    r'footer_word_spacing': PropertySchema(
      id: 26,
      name: r'footer_word_spacing',
      type: IsarType.double,
    ),
    r'header_color': PropertySchema(
      id: 27,
      name: r'header_color',
      type: IsarType.long,
    ),
    r'header_font_size': PropertySchema(
      id: 28,
      name: r'header_font_size',
      type: IsarType.double,
    ),
    r'header_font_weight': PropertySchema(
      id: 29,
      name: r'header_font_weight',
      type: IsarType.long,
    ),
    r'header_height': PropertySchema(
      id: 30,
      name: r'header_height',
      type: IsarType.double,
    ),
    r'header_letter_spacing': PropertySchema(
      id: 31,
      name: r'header_letter_spacing',
      type: IsarType.double,
    ),
    r'header_padding_bottom': PropertySchema(
      id: 32,
      name: r'header_padding_bottom',
      type: IsarType.double,
    ),
    r'header_padding_left': PropertySchema(
      id: 33,
      name: r'header_padding_left',
      type: IsarType.double,
    ),
    r'header_padding_right': PropertySchema(
      id: 34,
      name: r'header_padding_right',
      type: IsarType.double,
    ),
    r'header_padding_top': PropertySchema(
      id: 35,
      name: r'header_padding_top',
      type: IsarType.double,
    ),
    r'header_word_spacing': PropertySchema(
      id: 36,
      name: r'header_word_spacing',
      type: IsarType.double,
    )
  },
  estimateSize: _themeEstimateSize,
  serialize: _themeSerialize,
  deserialize: _themeDeserialize,
  deserializeProp: _themeDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _themeGetId,
  getLinks: _themeGetLinks,
  attach: _themeAttach,
  version: '3.1.8',
);

int _themeEstimateSize(
  Theme object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.backgroundImage.length * 3;
  return bytesCount;
}

void _themeSerialize(
  Theme object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.backgroundColor);
  writer.writeString(offsets[1], object.backgroundImage);
  writer.writeDouble(offsets[2], object.chapterFontSize);
  writer.writeLong(offsets[3], object.chapterFontWeight);
  writer.writeDouble(offsets[4], object.chapterHeight);
  writer.writeDouble(offsets[5], object.chapterLetterSpacing);
  writer.writeDouble(offsets[6], object.chapterWordSpacing);
  writer.writeLong(offsets[7], object.contentColor);
  writer.writeDouble(offsets[8], object.contentFontSize);
  writer.writeLong(offsets[9], object.contentFontWeight);
  writer.writeDouble(offsets[10], object.contentHeight);
  writer.writeDouble(offsets[11], object.contentLetterSpacing);
  writer.writeDouble(offsets[12], object.contentPaddingBottom);
  writer.writeDouble(offsets[13], object.contentPaddingLeft);
  writer.writeDouble(offsets[14], object.contentPaddingRight);
  writer.writeDouble(offsets[15], object.contentPaddingTop);
  writer.writeDouble(offsets[16], object.contentWordSpacing);
  writer.writeLong(offsets[17], object.footerColor);
  writer.writeDouble(offsets[18], object.footerFontSize);
  writer.writeLong(offsets[19], object.footerFontWeight);
  writer.writeDouble(offsets[20], object.footerHeight);
  writer.writeDouble(offsets[21], object.footerLetterSpacing);
  writer.writeDouble(offsets[22], object.footerPaddingBottom);
  writer.writeDouble(offsets[23], object.footerPaddingLeft);
  writer.writeDouble(offsets[24], object.footerPaddingRight);
  writer.writeDouble(offsets[25], object.footerPaddingTop);
  writer.writeDouble(offsets[26], object.footerWordSpacing);
  writer.writeLong(offsets[27], object.headerColor);
  writer.writeDouble(offsets[28], object.headerFontSize);
  writer.writeLong(offsets[29], object.headerFontWeight);
  writer.writeDouble(offsets[30], object.headerHeight);
  writer.writeDouble(offsets[31], object.headerLetterSpacing);
  writer.writeDouble(offsets[32], object.headerPaddingBottom);
  writer.writeDouble(offsets[33], object.headerPaddingLeft);
  writer.writeDouble(offsets[34], object.headerPaddingRight);
  writer.writeDouble(offsets[35], object.headerPaddingTop);
  writer.writeDouble(offsets[36], object.headerWordSpacing);
}

Theme _themeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Theme();
  object.backgroundColor = reader.readLong(offsets[0]);
  object.backgroundImage = reader.readString(offsets[1]);
  object.chapterFontSize = reader.readDouble(offsets[2]);
  object.chapterFontWeight = reader.readLong(offsets[3]);
  object.chapterHeight = reader.readDouble(offsets[4]);
  object.chapterLetterSpacing = reader.readDouble(offsets[5]);
  object.chapterWordSpacing = reader.readDouble(offsets[6]);
  object.contentColor = reader.readLong(offsets[7]);
  object.contentFontSize = reader.readDouble(offsets[8]);
  object.contentFontWeight = reader.readLong(offsets[9]);
  object.contentHeight = reader.readDouble(offsets[10]);
  object.contentLetterSpacing = reader.readDouble(offsets[11]);
  object.contentPaddingBottom = reader.readDouble(offsets[12]);
  object.contentPaddingLeft = reader.readDouble(offsets[13]);
  object.contentPaddingRight = reader.readDouble(offsets[14]);
  object.contentPaddingTop = reader.readDouble(offsets[15]);
  object.contentWordSpacing = reader.readDouble(offsets[16]);
  object.footerColor = reader.readLong(offsets[17]);
  object.footerFontSize = reader.readDouble(offsets[18]);
  object.footerFontWeight = reader.readLong(offsets[19]);
  object.footerHeight = reader.readDouble(offsets[20]);
  object.footerLetterSpacing = reader.readDouble(offsets[21]);
  object.footerPaddingBottom = reader.readDouble(offsets[22]);
  object.footerPaddingLeft = reader.readDouble(offsets[23]);
  object.footerPaddingRight = reader.readDouble(offsets[24]);
  object.footerPaddingTop = reader.readDouble(offsets[25]);
  object.footerWordSpacing = reader.readDouble(offsets[26]);
  object.headerColor = reader.readLong(offsets[27]);
  object.headerFontSize = reader.readDouble(offsets[28]);
  object.headerFontWeight = reader.readLong(offsets[29]);
  object.headerHeight = reader.readDouble(offsets[30]);
  object.headerLetterSpacing = reader.readDouble(offsets[31]);
  object.headerPaddingBottom = reader.readDouble(offsets[32]);
  object.headerPaddingLeft = reader.readDouble(offsets[33]);
  object.headerPaddingRight = reader.readDouble(offsets[34]);
  object.headerPaddingTop = reader.readDouble(offsets[35]);
  object.headerWordSpacing = reader.readDouble(offsets[36]);
  object.id = id;
  return object;
}

P _themeDeserializeProp<P>(
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
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readDouble(offset)) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    case 22:
      return (reader.readDouble(offset)) as P;
    case 23:
      return (reader.readDouble(offset)) as P;
    case 24:
      return (reader.readDouble(offset)) as P;
    case 25:
      return (reader.readDouble(offset)) as P;
    case 26:
      return (reader.readDouble(offset)) as P;
    case 27:
      return (reader.readLong(offset)) as P;
    case 28:
      return (reader.readDouble(offset)) as P;
    case 29:
      return (reader.readLong(offset)) as P;
    case 30:
      return (reader.readDouble(offset)) as P;
    case 31:
      return (reader.readDouble(offset)) as P;
    case 32:
      return (reader.readDouble(offset)) as P;
    case 33:
      return (reader.readDouble(offset)) as P;
    case 34:
      return (reader.readDouble(offset)) as P;
    case 35:
      return (reader.readDouble(offset)) as P;
    case 36:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _themeGetId(Theme object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _themeGetLinks(Theme object) {
  return [];
}

void _themeAttach(IsarCollection<dynamic> col, Id id, Theme object) {
  object.id = id;
}

extension ThemeQueryWhereSort on QueryBuilder<Theme, Theme, QWhere> {
  QueryBuilder<Theme, Theme, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ThemeQueryWhere on QueryBuilder<Theme, Theme, QWhereClause> {
  QueryBuilder<Theme, Theme, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Theme, Theme, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Theme, Theme, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Theme, Theme, QAfterWhereClause> idBetween(
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

extension ThemeQueryFilter on QueryBuilder<Theme, Theme, QFilterCondition> {
  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundColorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'background_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundColorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'background_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundColorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'background_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundColorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'background_color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundImageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'background_image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundImageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'background_image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundImageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'background_image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundImageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'background_image',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'background_image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'background_image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundImageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'background_image',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundImageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'background_image',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> backgroundImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'background_image',
        value: '',
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      backgroundImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'background_image',
        value: '',
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterFontSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterFontSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterFontSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterFontSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter_font_size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterFontWeightEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      chapterFontWeightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterFontWeightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterFontWeightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter_font_weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter_height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterLetterSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      chapterLetterSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      chapterLetterSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterLetterSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter_letter_spacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterWordSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      chapterWordSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterWordSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> chapterWordSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter_word_spacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentColorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentColorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentColorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentColorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentFontSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentFontSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentFontSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentFontSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_font_size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentFontWeightEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      contentFontWeightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentFontWeightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentFontWeightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_font_weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentLetterSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      contentLetterSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      contentLetterSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentLetterSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_letter_spacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingBottomEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_padding_bottom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      contentPaddingBottomGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_padding_bottom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      contentPaddingBottomLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_padding_bottom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingBottomBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_padding_bottom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingLeftEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_padding_left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      contentPaddingLeftGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_padding_left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingLeftLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_padding_left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingLeftBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_padding_left',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingRightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_padding_right',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      contentPaddingRightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_padding_right',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingRightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_padding_right',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingRightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_padding_right',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingTopEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_padding_top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      contentPaddingTopGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_padding_top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingTopLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_padding_top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentPaddingTopBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_padding_top',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentWordSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      contentWordSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentWordSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> contentWordSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content_word_spacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerColorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerColorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerColorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerColorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerFontSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerFontSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerFontSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerFontSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_font_size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerFontWeightEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerFontWeightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerFontWeightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerFontWeightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_font_weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerLetterSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      footerLetterSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerLetterSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerLetterSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_letter_spacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingBottomEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_padding_bottom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      footerPaddingBottomGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_padding_bottom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingBottomLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_padding_bottom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingBottomBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_padding_bottom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingLeftEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_padding_left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      footerPaddingLeftGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_padding_left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingLeftLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_padding_left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingLeftBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_padding_left',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingRightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_padding_right',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      footerPaddingRightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_padding_right',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingRightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_padding_right',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingRightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_padding_right',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingTopEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_padding_top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingTopGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_padding_top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingTopLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_padding_top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerPaddingTopBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_padding_top',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerWordSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footer_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      footerWordSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footer_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerWordSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footer_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> footerWordSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footer_word_spacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerColorEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerColorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerColorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_color',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerColorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerFontSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerFontSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerFontSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_font_size',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerFontSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_font_size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerFontWeightEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerFontWeightGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerFontWeightLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_font_weight',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerFontWeightBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_font_weight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerLetterSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      headerLetterSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerLetterSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_letter_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerLetterSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_letter_spacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingBottomEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_padding_bottom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      headerPaddingBottomGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_padding_bottom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingBottomLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_padding_bottom',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingBottomBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_padding_bottom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingLeftEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_padding_left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      headerPaddingLeftGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_padding_left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingLeftLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_padding_left',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingLeftBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_padding_left',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingRightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_padding_right',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      headerPaddingRightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_padding_right',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingRightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_padding_right',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingRightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_padding_right',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingTopEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_padding_top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingTopGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_padding_top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingTopLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_padding_top',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerPaddingTopBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_padding_top',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerWordSpacingEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'header_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition>
      headerWordSpacingGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'header_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerWordSpacingLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'header_word_spacing',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> headerWordSpacingBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'header_word_spacing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Theme, Theme, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Theme, Theme, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Theme, Theme, QAfterFilterCondition> idBetween(
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
}

extension ThemeQueryObject on QueryBuilder<Theme, Theme, QFilterCondition> {}

extension ThemeQueryLinks on QueryBuilder<Theme, Theme, QFilterCondition> {}

extension ThemeQuerySortBy on QueryBuilder<Theme, Theme, QSortBy> {
  QueryBuilder<Theme, Theme, QAfterSortBy> sortByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'background_color', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByBackgroundColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'background_color', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByBackgroundImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'background_image', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByBackgroundImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'background_image', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_font_size', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_font_size', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_font_weight', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterFontWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_font_weight', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_height', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_height', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_letter_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_letter_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_word_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByChapterWordSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_word_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_color', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_color', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_font_size', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_font_size', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_font_weight', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentFontWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_font_weight', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_height', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_height', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_letter_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_letter_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentPaddingBottom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_bottom', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentPaddingBottomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_bottom', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentPaddingLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_left', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentPaddingLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_left', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentPaddingRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_right', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentPaddingRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_right', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentPaddingTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_top', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentPaddingTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_top', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_word_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByContentWordSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_word_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_color', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_color', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_font_size', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_font_size', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_font_weight', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterFontWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_font_weight', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_height', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_height', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_letter_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_letter_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterPaddingBottom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_bottom', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterPaddingBottomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_bottom', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterPaddingLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_left', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterPaddingLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_left', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterPaddingRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_right', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterPaddingRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_right', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterPaddingTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_top', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterPaddingTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_top', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_word_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByFooterWordSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_word_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_color', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_color', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_font_size', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_font_size', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_font_weight', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderFontWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_font_weight', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_height', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_height', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_letter_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_letter_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderPaddingBottom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_bottom', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderPaddingBottomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_bottom', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderPaddingLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_left', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderPaddingLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_left', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderPaddingRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_right', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderPaddingRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_right', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderPaddingTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_top', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderPaddingTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_top', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_word_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> sortByHeaderWordSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_word_spacing', Sort.desc);
    });
  }
}

extension ThemeQuerySortThenBy on QueryBuilder<Theme, Theme, QSortThenBy> {
  QueryBuilder<Theme, Theme, QAfterSortBy> thenByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'background_color', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByBackgroundColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'background_color', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByBackgroundImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'background_image', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByBackgroundImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'background_image', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_font_size', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_font_size', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_font_weight', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterFontWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_font_weight', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_height', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_height', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_letter_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_letter_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_word_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByChapterWordSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter_word_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_color', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_color', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_font_size', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_font_size', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_font_weight', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentFontWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_font_weight', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_height', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_height', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_letter_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_letter_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentPaddingBottom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_bottom', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentPaddingBottomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_bottom', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentPaddingLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_left', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentPaddingLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_left', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentPaddingRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_right', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentPaddingRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_right', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentPaddingTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_top', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentPaddingTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_padding_top', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_word_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByContentWordSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content_word_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_color', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_color', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_font_size', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_font_size', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_font_weight', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterFontWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_font_weight', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_height', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_height', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_letter_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_letter_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterPaddingBottom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_bottom', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterPaddingBottomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_bottom', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterPaddingLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_left', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterPaddingLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_left', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterPaddingRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_right', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterPaddingRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_right', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterPaddingTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_top', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterPaddingTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_padding_top', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_word_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByFooterWordSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'footer_word_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_color', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_color', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_font_size', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderFontSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_font_size', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_font_weight', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderFontWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_font_weight', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_height', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_height', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_letter_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderLetterSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_letter_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderPaddingBottom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_bottom', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderPaddingBottomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_bottom', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderPaddingLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_left', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderPaddingLeftDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_left', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderPaddingRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_right', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderPaddingRightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_right', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderPaddingTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_top', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderPaddingTopDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_padding_top', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_word_spacing', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByHeaderWordSpacingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'header_word_spacing', Sort.desc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Theme, Theme, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ThemeQueryWhereDistinct on QueryBuilder<Theme, Theme, QDistinct> {
  QueryBuilder<Theme, Theme, QDistinct> distinctByBackgroundColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'background_color');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByBackgroundImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'background_image',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByChapterFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter_font_size');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByChapterFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter_font_weight');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByChapterHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter_height');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByChapterLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter_letter_spacing');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByChapterWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter_word_spacing');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_color');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_font_size');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_font_weight');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_height');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_letter_spacing');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentPaddingBottom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_padding_bottom');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentPaddingLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_padding_left');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentPaddingRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_padding_right');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentPaddingTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_padding_top');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByContentWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content_word_spacing');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_color');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_font_size');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_font_weight');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_height');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_letter_spacing');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterPaddingBottom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_padding_bottom');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterPaddingLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_padding_left');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterPaddingRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_padding_right');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterPaddingTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_padding_top');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByFooterWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footer_word_spacing');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_color');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderFontSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_font_size');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderFontWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_font_weight');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_height');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderLetterSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_letter_spacing');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderPaddingBottom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_padding_bottom');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderPaddingLeft() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_padding_left');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderPaddingRight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_padding_right');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderPaddingTop() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_padding_top');
    });
  }

  QueryBuilder<Theme, Theme, QDistinct> distinctByHeaderWordSpacing() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'header_word_spacing');
    });
  }
}

extension ThemeQueryProperty on QueryBuilder<Theme, Theme, QQueryProperty> {
  QueryBuilder<Theme, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Theme, int, QQueryOperations> backgroundColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'background_color');
    });
  }

  QueryBuilder<Theme, String, QQueryOperations> backgroundImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'background_image');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> chapterFontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter_font_size');
    });
  }

  QueryBuilder<Theme, int, QQueryOperations> chapterFontWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter_font_weight');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> chapterHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter_height');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> chapterLetterSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter_letter_spacing');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> chapterWordSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter_word_spacing');
    });
  }

  QueryBuilder<Theme, int, QQueryOperations> contentColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_color');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> contentFontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_font_size');
    });
  }

  QueryBuilder<Theme, int, QQueryOperations> contentFontWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_font_weight');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> contentHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_height');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> contentLetterSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_letter_spacing');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> contentPaddingBottomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_padding_bottom');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> contentPaddingLeftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_padding_left');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> contentPaddingRightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_padding_right');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> contentPaddingTopProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_padding_top');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> contentWordSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content_word_spacing');
    });
  }

  QueryBuilder<Theme, int, QQueryOperations> footerColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_color');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> footerFontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_font_size');
    });
  }

  QueryBuilder<Theme, int, QQueryOperations> footerFontWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_font_weight');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> footerHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_height');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> footerLetterSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_letter_spacing');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> footerPaddingBottomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_padding_bottom');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> footerPaddingLeftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_padding_left');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> footerPaddingRightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_padding_right');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> footerPaddingTopProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_padding_top');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> footerWordSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footer_word_spacing');
    });
  }

  QueryBuilder<Theme, int, QQueryOperations> headerColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_color');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> headerFontSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_font_size');
    });
  }

  QueryBuilder<Theme, int, QQueryOperations> headerFontWeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_font_weight');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> headerHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_height');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> headerLetterSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_letter_spacing');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> headerPaddingBottomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_padding_bottom');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> headerPaddingLeftProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_padding_left');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> headerPaddingRightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_padding_right');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> headerPaddingTopProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_padding_top');
    });
  }

  QueryBuilder<Theme, double, QQueryOperations> headerWordSpacingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'header_word_spacing');
    });
  }
}
