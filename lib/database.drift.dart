// ignore_for_file: type=lint
part of 'database.dart';

class $AppsTable extends Apps with TableInfo<$AppsTable, App> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _packageNameMeta = const VerificationMeta('packageName');
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>('package_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta = const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version =
      GeneratedColumn<String>('version', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bannerMeta = const VerificationMeta('banner');
  @override
  late final GeneratedColumn<Uint8List> banner =
      GeneratedColumn<Uint8List>('banner', aliasedName, true, type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<Uint8List> icon =
      GeneratedColumn<Uint8List>('icon', aliasedName, true, type: DriftSqlType.blob, requiredDuringInsert: false);
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>('hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("hidden" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }),
      defaultValue: Constant(false));
  static const VerificationMeta _sideloadedMeta = const VerificationMeta('sideloaded');
  @override
  late final GeneratedColumn<bool> sideloaded = GeneratedColumn<bool>('sideloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
        SqlDialect.sqlite: 'CHECK ("sideloaded" IN (0, 1))',
        SqlDialect.mysql: '',
        SqlDialect.postgres: '',
      }),
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return App(
      packageName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}package_name'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      version: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      banner: attachedDatabase.typeMapping.read(DriftSqlType.blob, data['${effectivePrefix}banner']),
      icon: attachedDatabase.typeMapping.read(DriftSqlType.blob, data['${effectivePrefix}icon']),
      hidden: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}hidden'])!,
      sideloaded: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}sideloaded'])!,
    );
  }

  @override
  $AppsTable createAlias(String alias) {
    return $AppsTable(attachedDatabase, alias);
  }
}

class App extends DataClass implements Insertable<App> {
  final String packageName;
  final String name;
  final String version;
  final Uint8List? banner;
  final Uint8List? icon;
  final bool hidden;
  final bool sideloaded;
  const App(
      {required this.packageName,
      required this.name,
      required this.version,
      this.banner,
      this.icon,
      required this.hidden,
      required this.sideloaded});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['name'] = Variable<String>(name);
    map['version'] = Variable<String>(version);
    if (!nullToAbsent || banner != null) {
      map['banner'] = Variable<Uint8List>(banner);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<Uint8List>(icon);
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
          Value<Uint8List?> banner = const Value.absent(),
          Value<Uint8List?> icon = const Value.absent(),
          bool? hidden,
          bool? sideloaded}) =>
      App(
        packageName: packageName ?? this.packageName,
        name: name ?? this.name,
        version: version ?? this.version,
        banner: banner.present ? banner.value : this.banner,
        icon: icon.present ? icon.value : this.icon,
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
  int get hashCode => Object.hash(
      packageName, name, version, $driftBlobEquality.hash(banner), $driftBlobEquality.hash(icon), hidden, sideloaded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is App &&
          other.packageName == this.packageName &&
          other.name == this.name &&
          other.version == this.version &&
          $driftBlobEquality.equals(other.banner, this.banner) &&
          $driftBlobEquality.equals(other.icon, this.icon) &&
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
    Expression<Uint8List>? banner,
    Expression<Uint8List>? icon,
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
      map['banner'] = Variable<Uint8List>(banner.value);
    }
    if (icon.present) {
      map['icon'] = Variable<Uint8List>(icon.value);
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

class $CategoriesTable extends Categories with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name =
      GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumnWithTypeConverter<CategorySort, int> sort = GeneratedColumn<int>('sort', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: Constant(0))
      .withConverter<CategorySort>($CategoriesTable.$convertersort);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<CategoryType, int> type = GeneratedColumn<int>('type', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: Constant(0))
      .withConverter<CategoryType>($CategoriesTable.$convertertype);
  static const VerificationMeta _rowHeightMeta = const VerificationMeta('rowHeight');
  @override
  late final GeneratedColumn<int> rowHeight = GeneratedColumn<int>('row_height', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: Constant(110));
  static const VerificationMeta _columnsCountMeta = const VerificationMeta('columnsCount');
  @override
  late final GeneratedColumn<int> columnsCount = GeneratedColumn<int>('columns_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: Constant(6));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order =
      GeneratedColumn<int>('order', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      sort: $CategoriesTable.$convertersort
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort'])!),
      type: $CategoriesTable.$convertertype
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      rowHeight: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}row_height'])!,
      columnsCount: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}columns_count'])!,
      order: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}order'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategorySort, int, int> $convertersort =
      const EnumIndexConverter<CategorySort>(CategorySort.values);
  static JsonTypeConverter2<CategoryType, int, int> $convertertype =
      const EnumIndexConverter<CategoryType>(CategoryType.values);
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final CategorySort sort;
  final CategoryType type;
  final int rowHeight;
  final int columnsCount;
  final int order;
  const Category(
      {required this.id,
      required this.name,
      required this.sort,
      required this.type,
      required this.rowHeight,
      required this.columnsCount,
      required this.order});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      final converter = $CategoriesTable.$convertersort;
      map['sort'] = Variable<int>(converter.toSql(sort));
    }
    {
      final converter = $CategoriesTable.$convertertype;
      map['type'] = Variable<int>(converter.toSql(type));
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
      sort: $CategoriesTable.$convertersort.fromJson(serializer.fromJson<int>(json['sort'])),
      type: $CategoriesTable.$convertertype.fromJson(serializer.fromJson<int>(json['type'])),
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
      'sort': serializer.toJson<int>($CategoriesTable.$convertersort.toJson(sort)),
      'type': serializer.toJson<int>($CategoriesTable.$convertertype.toJson(type)),
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
    Expression<int>? sort,
    Expression<int>? type,
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
      final converter = $CategoriesTable.$convertersort;
      map['sort'] = Variable<int>(converter.toSql(sort.value));
    }
    if (type.present) {
      final converter = $CategoriesTable.$convertertype;
      map['type'] = Variable<int>(converter.toSql(type.value));
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

class $AppsCategoriesTable extends AppsCategories with TableInfo<$AppsCategoriesTable, AppCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppsCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>('category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES categories(id) ON DELETE CASCADE');
  static const VerificationMeta _appPackageNameMeta = const VerificationMeta('appPackageName');
  @override
  late final GeneratedColumn<String> appPackageName = GeneratedColumn<String>('app_package_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES apps(package_name) ON DELETE CASCADE');
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order =
      GeneratedColumn<int>('order', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true);
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
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppCategory(
      categoryId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      appPackageName:
          attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}app_package_name'])!,
      order: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}order'])!,
    );
  }

  @override
  $AppsCategoriesTable createAlias(String alias) {
    return $AppsCategoriesTable(attachedDatabase, alias);
  }
}

class AppCategory extends DataClass implements Insertable<AppCategory> {
  final int categoryId;
  final String appPackageName;
  final int order;
  const AppCategory({required this.categoryId, required this.appPackageName, required this.order});
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

abstract class _$FLauncherDatabase extends GeneratedDatabase {
  _$FLauncherDatabase(QueryExecutor e) : super(e);
  late final $AppsTable apps = $AppsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $AppsCategoriesTable appsCategories = $AppsCategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [apps, categories, appsCategories];
}
