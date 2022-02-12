// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class App extends DataClass implements Insertable<App> {
  final String packageName;
  final String name;
  final String version;
  final Uint8List? banner;
  final Uint8List? icon;
  final bool hidden;
  final bool sideloaded;
  App(
      {required this.packageName,
      required this.name,
      required this.version,
      this.banner,
      this.icon,
      required this.hidden,
      required this.sideloaded});
  factory App.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return App(
      packageName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}package_name'])!,
      name: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      version: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}version'])!,
      banner: const BlobType().mapFromDatabaseResponse(data['${effectivePrefix}banner']),
      icon: const BlobType().mapFromDatabaseResponse(data['${effectivePrefix}icon']),
      hidden: const BoolType().mapFromDatabaseResponse(data['${effectivePrefix}hidden'])!,
      sideloaded: const BoolType().mapFromDatabaseResponse(data['${effectivePrefix}sideloaded'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['name'] = Variable<String>(name);
    map['version'] = Variable<String>(version);
    if (!nullToAbsent || banner != null) {
      map['banner'] = Variable<Uint8List?>(banner);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<Uint8List?>(icon);
    }
    map['hidden'] = Variable<bool>(hidden);
    map['sideloaded'] = Variable<bool>(sideloaded);
    return map;
  }

  AppsCompanion toCompanion(bool nullToAbsent) {
    return AppsCompanion(
      packageName: Value(packageName),
      name: Value(name),
      version: Value(version),
      banner: banner == null && nullToAbsent ? const Value.absent() : Value(banner),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      hidden: Value(hidden),
      sideloaded: Value(sideloaded),
    );
  }

  factory App.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return App(
      packageName: serializer.fromJson<String>(json['packageName']),
      name: serializer.fromJson<String>(json['name']),
      version: serializer.fromJson<String>(json['version']),
      banner: serializer.fromJson<Uint8List?>(json['banner']),
      icon: serializer.fromJson<Uint8List?>(json['icon']),
      hidden: serializer.fromJson<bool>(json['hidden']),
      sideloaded: serializer.fromJson<bool>(json['sideloaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'name': serializer.toJson<String>(name),
      'version': serializer.toJson<String>(version),
      'banner': serializer.toJson<Uint8List?>(banner),
      'icon': serializer.toJson<Uint8List?>(icon),
      'hidden': serializer.toJson<bool>(hidden),
      'sideloaded': serializer.toJson<bool>(sideloaded),
    };
  }

  App copyWith(
          {String? packageName,
          String? name,
          String? version,
          Uint8List? banner,
          Uint8List? icon,
          bool? hidden,
          bool? sideloaded}) =>
      App(
        packageName: packageName ?? this.packageName,
        name: name ?? this.name,
        version: version ?? this.version,
        banner: banner ?? this.banner,
        icon: icon ?? this.icon,
        hidden: hidden ?? this.hidden,
        sideloaded: sideloaded ?? this.sideloaded,
      );
  @override
  String toString() {
    return (StringBuffer('App(')
          ..write('packageName: $packageName, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('banner: $banner, ')
          ..write('icon: $icon, ')
          ..write('hidden: $hidden, ')
          ..write('sideloaded: $sideloaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(packageName, name, version, banner, icon, hidden, sideloaded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is App &&
          other.packageName == this.packageName &&
          other.name == this.name &&
          other.version == this.version &&
          other.banner == this.banner &&
          other.icon == this.icon &&
          other.hidden == this.hidden &&
          other.sideloaded == this.sideloaded);
}

class AppsCompanion extends UpdateCompanion<App> {
  final Value<String> packageName;
  final Value<String> name;
  final Value<String> version;
  final Value<Uint8List?> banner;
  final Value<Uint8List?> icon;
  final Value<bool> hidden;
  final Value<bool> sideloaded;
  const AppsCompanion({
    this.packageName = const Value.absent(),
    this.name = const Value.absent(),
    this.version = const Value.absent(),
    this.banner = const Value.absent(),
    this.icon = const Value.absent(),
    this.hidden = const Value.absent(),
    this.sideloaded = const Value.absent(),
  });
  AppsCompanion.insert({
    required String packageName,
    required String name,
    required String version,
    this.banner = const Value.absent(),
    this.icon = const Value.absent(),
    this.hidden = const Value.absent(),
    this.sideloaded = const Value.absent(),
  })  : packageName = Value(packageName),
        name = Value(name),
        version = Value(version);
  static Insertable<App> custom({
    Expression<String>? packageName,
    Expression<String>? name,
    Expression<String>? version,
    Expression<Uint8List?>? banner,
    Expression<Uint8List?>? icon,
    Expression<bool>? hidden,
    Expression<bool>? sideloaded,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (name != null) 'name': name,
      if (version != null) 'version': version,
      if (banner != null) 'banner': banner,
      if (icon != null) 'icon': icon,
      if (hidden != null) 'hidden': hidden,
      if (sideloaded != null) 'sideloaded': sideloaded,
    });
  }

  AppsCompanion copyWith(
      {Value<String>? packageName,
      Value<String>? name,
      Value<String>? version,
      Value<Uint8List?>? banner,
      Value<Uint8List?>? icon,
      Value<bool>? hidden,
      Value<bool>? sideloaded}) {
    return AppsCompanion(
      packageName: packageName ?? this.packageName,
      name: name ?? this.name,
      version: version ?? this.version,
      banner: banner ?? this.banner,
      icon: icon ?? this.icon,
      hidden: hidden ?? this.hidden,
      sideloaded: sideloaded ?? this.sideloaded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (banner.present) {
      map['banner'] = Variable<Uint8List?>(banner.value);
    }
    if (icon.present) {
      map['icon'] = Variable<Uint8List?>(icon.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    if (sideloaded.present) {
      map['sideloaded'] = Variable<bool>(sideloaded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppsCompanion(')
          ..write('packageName: $packageName, ')
          ..write('name: $name, ')
          ..write('version: $version, ')
          ..write('banner: $banner, ')
          ..write('icon: $icon, ')
          ..write('hidden: $hidden, ')
          ..write('sideloaded: $sideloaded')
          ..write(')'))
        .toString();
  }
}

class $AppsTable extends Apps with TableInfo<$AppsTable, App> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _packageNameMeta = const VerificationMeta('packageName');
  @override
  late final GeneratedColumn<String?> packageName = GeneratedColumn<String?>('package_name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name =
      GeneratedColumn<String?>('name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _versionMeta = const VerificationMeta('version');
  @override
  late final GeneratedColumn<String?> version =
      GeneratedColumn<String?>('version', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _bannerMeta = const VerificationMeta('banner');
  @override
  late final GeneratedColumn<Uint8List?> banner =
      GeneratedColumn<Uint8List?>('banner', aliasedName, true, type: const BlobType(), requiredDuringInsert: false);
  final VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<Uint8List?> icon =
      GeneratedColumn<Uint8List?>('icon', aliasedName, true, type: const BlobType(), requiredDuringInsert: false);
  final VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool?> hidden = GeneratedColumn<bool?>('hidden', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (hidden IN (0, 1))',
      defaultValue: Constant(false));
  final VerificationMeta _sideloadedMeta = const VerificationMeta('sideloaded');
  @override
  late final GeneratedColumn<bool?> sideloaded = GeneratedColumn<bool?>('sideloaded', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (sideloaded IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [packageName, name, version, banner, icon, hidden, sideloaded];
  @override
  String get aliasedName => _alias ?? 'apps';
  @override
  String get actualTableName => 'apps';
  @override
  VerificationContext validateIntegrity(Insertable<App> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('package_name')) {
      context.handle(_packageNameMeta, packageName.isAcceptableOrUnknown(data['package_name']!, _packageNameMeta));
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta, version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('banner')) {
      context.handle(_bannerMeta, banner.isAcceptableOrUnknown(data['banner']!, _bannerMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(_iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('hidden')) {
      context.handle(_hiddenMeta, hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta));
    }
    if (data.containsKey('sideloaded')) {
      context.handle(_sideloadedMeta, sideloaded.isAcceptableOrUnknown(data['sideloaded']!, _sideloadedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName};
  @override
  App map(Map<String, dynamic> data, {String? tablePrefix}) {
    return App.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AppsTable createAlias(String alias) {
    return $AppsTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final CategorySort sort;
  final CategoryType type;
  final int rowHeight;
  final int columnsCount;
  final int order;
  Category(
      {required this.id,
      required this.name,
      required this.sort,
      required this.type,
      required this.rowHeight,
      required this.columnsCount,
      required this.order});
  factory Category.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Category(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      sort: $CategoriesTable.$converter0
          .mapToDart(const IntType().mapFromDatabaseResponse(data['${effectivePrefix}sort']))!,
      type: $CategoriesTable.$converter1
          .mapToDart(const IntType().mapFromDatabaseResponse(data['${effectivePrefix}type']))!,
      rowHeight: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}row_height'])!,
      columnsCount: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}columns_count'])!,
      order: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}order'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      final converter = $CategoriesTable.$converter0;
      map['sort'] = Variable<int>(converter.mapToSql(sort)!);
    }
    {
      final converter = $CategoriesTable.$converter1;
      map['type'] = Variable<int>(converter.mapToSql(type)!);
    }
    map['row_height'] = Variable<int>(rowHeight);
    map['columns_count'] = Variable<int>(columnsCount);
    map['order'] = Variable<int>(order);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      sort: Value(sort),
      type: Value(type),
      rowHeight: Value(rowHeight),
      columnsCount: Value(columnsCount),
      order: Value(order),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sort: serializer.fromJson<CategorySort>(json['sort']),
      type: serializer.fromJson<CategoryType>(json['type']),
      rowHeight: serializer.fromJson<int>(json['rowHeight']),
      columnsCount: serializer.fromJson<int>(json['columnsCount']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sort': serializer.toJson<CategorySort>(sort),
      'type': serializer.toJson<CategoryType>(type),
      'rowHeight': serializer.toJson<int>(rowHeight),
      'columnsCount': serializer.toJson<int>(columnsCount),
      'order': serializer.toJson<int>(order),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          CategorySort? sort,
          CategoryType? type,
          int? rowHeight,
          int? columnsCount,
          int? order}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        sort: sort ?? this.sort,
        type: type ?? this.type,
        rowHeight: rowHeight ?? this.rowHeight,
        columnsCount: columnsCount ?? this.columnsCount,
        order: order ?? this.order,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sort: $sort, ')
          ..write('type: $type, ')
          ..write('rowHeight: $rowHeight, ')
          ..write('columnsCount: $columnsCount, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sort, type, rowHeight, columnsCount, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.sort == this.sort &&
          other.type == this.type &&
          other.rowHeight == this.rowHeight &&
          other.columnsCount == this.columnsCount &&
          other.order == this.order);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<CategorySort> sort;
  final Value<CategoryType> type;
  final Value<int> rowHeight;
  final Value<int> columnsCount;
  final Value<int> order;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sort = const Value.absent(),
    this.type = const Value.absent(),
    this.rowHeight = const Value.absent(),
    this.columnsCount = const Value.absent(),
    this.order = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sort = const Value.absent(),
    this.type = const Value.absent(),
    this.rowHeight = const Value.absent(),
    this.columnsCount = const Value.absent(),
    required int order,
  })  : name = Value(name),
        order = Value(order);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<CategorySort>? sort,
    Expression<CategoryType>? type,
    Expression<int>? rowHeight,
    Expression<int>? columnsCount,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sort != null) 'sort': sort,
      if (type != null) 'type': type,
      if (rowHeight != null) 'row_height': rowHeight,
      if (columnsCount != null) 'columns_count': columnsCount,
      if (order != null) 'order': order,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<CategorySort>? sort,
      Value<CategoryType>? type,
      Value<int>? rowHeight,
      Value<int>? columnsCount,
      Value<int>? order}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sort: sort ?? this.sort,
      type: type ?? this.type,
      rowHeight: rowHeight ?? this.rowHeight,
      columnsCount: columnsCount ?? this.columnsCount,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sort.present) {
      final converter = $CategoriesTable.$converter0;
      map['sort'] = Variable<int>(converter.mapToSql(sort.value)!);
    }
    if (type.present) {
      final converter = $CategoriesTable.$converter1;
      map['type'] = Variable<int>(converter.mapToSql(type.value)!);
    }
    if (rowHeight.present) {
      map['row_height'] = Variable<int>(rowHeight.value);
    }
    if (columnsCount.present) {
      map['columns_count'] = Variable<int>(columnsCount.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sort: $sort, ')
          ..write('type: $type, ')
          ..write('rowHeight: $rowHeight, ')
          ..write('columnsCount: $columnsCount, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false, defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name =
      GeneratedColumn<String?>('name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumnWithTypeConverter<CategorySort, int?> sort = GeneratedColumn<int?>(
          'sort', aliasedName, false,
          type: const IntType(), requiredDuringInsert: false, defaultValue: Constant(0))
      .withConverter<CategorySort>($CategoriesTable.$converter0);
  final VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<CategoryType, int?> type = GeneratedColumn<int?>(
          'type', aliasedName, false,
          type: const IntType(), requiredDuringInsert: false, defaultValue: Constant(0))
      .withConverter<CategoryType>($CategoriesTable.$converter1);
  final VerificationMeta _rowHeightMeta = const VerificationMeta('rowHeight');
  @override
  late final GeneratedColumn<int?> rowHeight = GeneratedColumn<int?>('row_height', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false, defaultValue: Constant(110));
  final VerificationMeta _columnsCountMeta = const VerificationMeta('columnsCount');
  @override
  late final GeneratedColumn<int?> columnsCount = GeneratedColumn<int?>('columns_count', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false, defaultValue: Constant(6));
  final VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int?> order =
      GeneratedColumn<int?>('order', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, sort, type, rowHeight, columnsCount, order];
  @override
  String get aliasedName => _alias ?? 'categories';
  @override
  String get actualTableName => 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_sortMeta, const VerificationResult.success());
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('row_height')) {
      context.handle(_rowHeightMeta, rowHeight.isAcceptableOrUnknown(data['row_height']!, _rowHeightMeta));
    }
    if (data.containsKey('columns_count')) {
      context.handle(_columnsCountMeta, columnsCount.isAcceptableOrUnknown(data['columns_count']!, _columnsCountMeta));
    }
    if (data.containsKey('order')) {
      context.handle(_orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Category.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static TypeConverter<CategorySort, int> $converter0 = const EnumIndexConverter<CategorySort>(CategorySort.values);
  static TypeConverter<CategoryType, int> $converter1 = const EnumIndexConverter<CategoryType>(CategoryType.values);
}

class AppCategory extends DataClass implements Insertable<AppCategory> {
  final int categoryId;
  final String appPackageName;
  final int order;
  AppCategory({required this.categoryId, required this.appPackageName, required this.order});
  factory AppCategory.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return AppCategory(
      categoryId: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}category_id'])!,
      appPackageName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}app_package_name'])!,
      order: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}order'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_id'] = Variable<int>(categoryId);
    map['app_package_name'] = Variable<String>(appPackageName);
    map['order'] = Variable<int>(order);
    return map;
  }

  AppsCategoriesCompanion toCompanion(bool nullToAbsent) {
    return AppsCategoriesCompanion(
      categoryId: Value(categoryId),
      appPackageName: Value(appPackageName),
      order: Value(order),
    );
  }

  factory AppCategory.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppCategory(
      categoryId: serializer.fromJson<int>(json['categoryId']),
      appPackageName: serializer.fromJson<String>(json['appPackageName']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryId': serializer.toJson<int>(categoryId),
      'appPackageName': serializer.toJson<String>(appPackageName),
      'order': serializer.toJson<int>(order),
    };
  }

  AppCategory copyWith({int? categoryId, String? appPackageName, int? order}) => AppCategory(
        categoryId: categoryId ?? this.categoryId,
        appPackageName: appPackageName ?? this.appPackageName,
        order: order ?? this.order,
      );
  @override
  String toString() {
    return (StringBuffer('AppCategory(')
          ..write('categoryId: $categoryId, ')
          ..write('appPackageName: $appPackageName, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(categoryId, appPackageName, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppCategory &&
          other.categoryId == this.categoryId &&
          other.appPackageName == this.appPackageName &&
          other.order == this.order);
}

class AppsCategoriesCompanion extends UpdateCompanion<AppCategory> {
  final Value<int> categoryId;
  final Value<String> appPackageName;
  final Value<int> order;
  const AppsCategoriesCompanion({
    this.categoryId = const Value.absent(),
    this.appPackageName = const Value.absent(),
    this.order = const Value.absent(),
  });
  AppsCategoriesCompanion.insert({
    required int categoryId,
    required String appPackageName,
    required int order,
  })  : categoryId = Value(categoryId),
        appPackageName = Value(appPackageName),
        order = Value(order);
  static Insertable<AppCategory> custom({
    Expression<int>? categoryId,
    Expression<String>? appPackageName,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (categoryId != null) 'category_id': categoryId,
      if (appPackageName != null) 'app_package_name': appPackageName,
      if (order != null) 'order': order,
    });
  }

  AppsCategoriesCompanion copyWith({Value<int>? categoryId, Value<String>? appPackageName, Value<int>? order}) {
    return AppsCategoriesCompanion(
      categoryId: categoryId ?? this.categoryId,
      appPackageName: appPackageName ?? this.appPackageName,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (appPackageName.present) {
      map['app_package_name'] = Variable<String>(appPackageName.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppsCategoriesCompanion(')
          ..write('categoryId: $categoryId, ')
          ..write('appPackageName: $appPackageName, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class $AppsCategoriesTable extends AppsCategories with TableInfo<$AppsCategoriesTable, AppCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppsCategoriesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int?> categoryId = GeneratedColumn<int?>('category_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES categories(id) ON DELETE CASCADE');
  final VerificationMeta _appPackageNameMeta = const VerificationMeta('appPackageName');
  @override
  late final GeneratedColumn<String?> appPackageName = GeneratedColumn<String?>('app_package_name', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES apps(package_name) ON DELETE CASCADE');
  final VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int?> order =
      GeneratedColumn<int?>('order', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [categoryId, appPackageName, order];
  @override
  String get aliasedName => _alias ?? 'apps_categories';
  @override
  String get actualTableName => 'apps_categories';
  @override
  VerificationContext validateIntegrity(Insertable<AppCategory> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(_categoryIdMeta, categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('app_package_name')) {
      context.handle(
          _appPackageNameMeta, appPackageName.isAcceptableOrUnknown(data['app_package_name']!, _appPackageNameMeta));
    } else if (isInserting) {
      context.missing(_appPackageNameMeta);
    }
    if (data.containsKey('order')) {
      context.handle(_orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryId, appPackageName};
  @override
  AppCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    return AppCategory.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AppsCategoriesTable createAlias(String alias) {
    return $AppsCategoriesTable(attachedDatabase, alias);
  }
}

abstract class _$FLauncherDatabase extends GeneratedDatabase {
  _$FLauncherDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  _$FLauncherDatabase.connect(DatabaseConnection c) : super.connect(c);
  late final $AppsTable apps = $AppsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $AppsCategoriesTable appsCategories = $AppsCategoriesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [apps, categories, appsCategories];
}
