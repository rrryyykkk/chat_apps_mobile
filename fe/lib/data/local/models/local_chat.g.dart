// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_chat.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalChatCollection on Isar {
  IsarCollection<LocalChat> get localChats => this.collection();
}

const LocalChatSchema = CollectionSchema(
  name: r'LocalChat',
  id: -2936702508279018238,
  properties: {
    r'chatId': PropertySchema(
      id: 0,
      name: r'chatId',
      type: IsarType.string,
    ),
    r'icon': PropertySchema(
      id: 1,
      name: r'icon',
      type: IsarType.string,
    ),
    r'isGroup': PropertySchema(
      id: 2,
      name: r'isGroup',
      type: IsarType.bool,
    ),
    r'lastMessageContent': PropertySchema(
      id: 3,
      name: r'lastMessageContent',
      type: IsarType.string,
    ),
    r'lastMessageSenderName': PropertySchema(
      id: 4,
      name: r'lastMessageSenderName',
      type: IsarType.string,
    ),
    r'lastMessageTime': PropertySchema(
      id: 5,
      name: r'lastMessageTime',
      type: IsarType.dateTime,
    ),
    r'lastMessageType': PropertySchema(
      id: 6,
      name: r'lastMessageType',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 7,
      name: r'name',
      type: IsarType.string,
    ),
    r'participantIds': PropertySchema(
      id: 8,
      name: r'participantIds',
      type: IsarType.stringList,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _localChatEstimateSize,
  serialize: _localChatSerialize,
  deserialize: _localChatDeserialize,
  deserializeProp: _localChatDeserializeProp,
  idName: r'id',
  indexes: {
    r'chatId': IndexSchema(
      id: 1909629659142158609,
      name: r'chatId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'chatId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localChatGetId,
  getLinks: _localChatGetLinks,
  attach: _localChatAttach,
  version: '3.1.0+1',
);

int _localChatEstimateSize(
  LocalChat object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.chatId.length * 3;
  {
    final value = object.icon;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastMessageContent;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastMessageSenderName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastMessageType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.participantIds.length * 3;
  {
    for (var i = 0; i < object.participantIds.length; i++) {
      final value = object.participantIds[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _localChatSerialize(
  LocalChat object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chatId);
  writer.writeString(offsets[1], object.icon);
  writer.writeBool(offsets[2], object.isGroup);
  writer.writeString(offsets[3], object.lastMessageContent);
  writer.writeString(offsets[4], object.lastMessageSenderName);
  writer.writeDateTime(offsets[5], object.lastMessageTime);
  writer.writeString(offsets[6], object.lastMessageType);
  writer.writeString(offsets[7], object.name);
  writer.writeStringList(offsets[8], object.participantIds);
  writer.writeDateTime(offsets[9], object.updatedAt);
}

LocalChat _localChatDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalChat();
  object.chatId = reader.readString(offsets[0]);
  object.icon = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.isGroup = reader.readBool(offsets[2]);
  object.lastMessageContent = reader.readStringOrNull(offsets[3]);
  object.lastMessageSenderName = reader.readStringOrNull(offsets[4]);
  object.lastMessageTime = reader.readDateTimeOrNull(offsets[5]);
  object.lastMessageType = reader.readStringOrNull(offsets[6]);
  object.name = reader.readStringOrNull(offsets[7]);
  object.participantIds = reader.readStringList(offsets[8]) ?? [];
  object.updatedAt = reader.readDateTimeOrNull(offsets[9]);
  return object;
}

P _localChatDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringList(offset) ?? []) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localChatGetId(LocalChat object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localChatGetLinks(LocalChat object) {
  return [];
}

void _localChatAttach(IsarCollection<dynamic> col, Id id, LocalChat object) {
  object.id = id;
}

extension LocalChatByIndex on IsarCollection<LocalChat> {
  Future<LocalChat?> getByChatId(String chatId) {
    return getByIndex(r'chatId', [chatId]);
  }

  LocalChat? getByChatIdSync(String chatId) {
    return getByIndexSync(r'chatId', [chatId]);
  }

  Future<bool> deleteByChatId(String chatId) {
    return deleteByIndex(r'chatId', [chatId]);
  }

  bool deleteByChatIdSync(String chatId) {
    return deleteByIndexSync(r'chatId', [chatId]);
  }

  Future<List<LocalChat?>> getAllByChatId(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'chatId', values);
  }

  List<LocalChat?> getAllByChatIdSync(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'chatId', values);
  }

  Future<int> deleteAllByChatId(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'chatId', values);
  }

  int deleteAllByChatIdSync(List<String> chatIdValues) {
    final values = chatIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'chatId', values);
  }

  Future<Id> putByChatId(LocalChat object) {
    return putByIndex(r'chatId', object);
  }

  Id putByChatIdSync(LocalChat object, {bool saveLinks = true}) {
    return putByIndexSync(r'chatId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByChatId(List<LocalChat> objects) {
    return putAllByIndex(r'chatId', objects);
  }

  List<Id> putAllByChatIdSync(List<LocalChat> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'chatId', objects, saveLinks: saveLinks);
  }
}

extension LocalChatQueryWhereSort
    on QueryBuilder<LocalChat, LocalChat, QWhere> {
  QueryBuilder<LocalChat, LocalChat, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalChatQueryWhere
    on QueryBuilder<LocalChat, LocalChat, QWhereClause> {
  QueryBuilder<LocalChat, LocalChat, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<LocalChat, LocalChat, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterWhereClause> idBetween(
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

  QueryBuilder<LocalChat, LocalChat, QAfterWhereClause> chatIdEqualTo(
      String chatId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chatId',
        value: [chatId],
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterWhereClause> chatIdNotEqualTo(
      String chatId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [chatId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chatId',
              lower: [],
              upper: [chatId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension LocalChatQueryFilter
    on QueryBuilder<LocalChat, LocalChat, QFilterCondition> {
  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> chatIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chatId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'icon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> isGroupEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isGroup',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastMessageContent',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastMessageContent',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessageContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessageContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessageContent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastMessageContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastMessageContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastMessageContent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastMessageContent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageContent',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageContentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastMessageContent',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastMessageSenderName',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastMessageSenderName',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessageSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessageSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessageSenderName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastMessageSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastMessageSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastMessageSenderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastMessageSenderName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageSenderName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageSenderNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastMessageSenderName',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastMessageTime',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastMessageTime',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTimeEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageTime',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTimeGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessageTime',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTimeLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessageTime',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTimeBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessageTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastMessageType',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastMessageType',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessageType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastMessageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastMessageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastMessageType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastMessageType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      lastMessageTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastMessageType',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameEqualTo(
    String? value, {
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameGreaterThan(
    String? value, {
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameLessThan(
    String? value, {
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'participantIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'participantIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'participantIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'participantIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'participantIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'participantIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'participantIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'participantIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'participantIds',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'participantIds',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participantIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participantIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participantIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participantIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participantIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      participantIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participantIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LocalChatQueryObject
    on QueryBuilder<LocalChat, LocalChat, QFilterCondition> {}

extension LocalChatQueryLinks
    on QueryBuilder<LocalChat, LocalChat, QFilterCondition> {}

extension LocalChatQuerySortBy on QueryBuilder<LocalChat, LocalChat, QSortBy> {
  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByIsGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGroup', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByIsGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGroup', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByLastMessageContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageContent', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy>
      sortByLastMessageContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageContent', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy>
      sortByLastMessageSenderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageSenderName', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy>
      sortByLastMessageSenderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageSenderName', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByLastMessageTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageTime', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByLastMessageTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageTime', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByLastMessageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageType', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByLastMessageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageType', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalChatQuerySortThenBy
    on QueryBuilder<LocalChat, LocalChat, QSortThenBy> {
  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByChatId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByChatIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatId', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByIsGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGroup', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByIsGroupDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isGroup', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByLastMessageContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageContent', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy>
      thenByLastMessageContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageContent', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy>
      thenByLastMessageSenderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageSenderName', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy>
      thenByLastMessageSenderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageSenderName', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByLastMessageTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageTime', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByLastMessageTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageTime', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByLastMessageType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageType', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByLastMessageTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageType', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalChatQueryWhereDistinct
    on QueryBuilder<LocalChat, LocalChat, QDistinct> {
  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByChatId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByIcon(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'icon', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByIsGroup() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isGroup');
    });
  }

  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByLastMessageContent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessageContent',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByLastMessageSenderName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessageSenderName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByLastMessageTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessageTime');
    });
  }

  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByLastMessageType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessageType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByParticipantIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'participantIds');
    });
  }

  QueryBuilder<LocalChat, LocalChat, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LocalChatQueryProperty
    on QueryBuilder<LocalChat, LocalChat, QQueryProperty> {
  QueryBuilder<LocalChat, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalChat, String, QQueryOperations> chatIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatId');
    });
  }

  QueryBuilder<LocalChat, String?, QQueryOperations> iconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'icon');
    });
  }

  QueryBuilder<LocalChat, bool, QQueryOperations> isGroupProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isGroup');
    });
  }

  QueryBuilder<LocalChat, String?, QQueryOperations>
      lastMessageContentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessageContent');
    });
  }

  QueryBuilder<LocalChat, String?, QQueryOperations>
      lastMessageSenderNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessageSenderName');
    });
  }

  QueryBuilder<LocalChat, DateTime?, QQueryOperations>
      lastMessageTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessageTime');
    });
  }

  QueryBuilder<LocalChat, String?, QQueryOperations> lastMessageTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessageType');
    });
  }

  QueryBuilder<LocalChat, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<LocalChat, List<String>, QQueryOperations>
      participantIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'participantIds');
    });
  }

  QueryBuilder<LocalChat, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
