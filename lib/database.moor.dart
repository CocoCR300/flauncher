// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class App extends DataClass implements Insertable<App> {
  final String packageName;
  final String name;
  final String className;
  final String version;
  final Uint8List? banner;
  final Uint8List? icon;
  App(
      {required this.packageName,
      required this.name,
      required this.className,
      required this.version,
      this.banner,
      this.icon});
  factory App.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return App(
      packageName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}package_name'])!,
      name: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      className: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}class_name'])!,
      version: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}version'])!,
      banner: const BlobType().mapFromDatabaseResponse(data['${effectivePrefix}banner']),
      icon: const BlobType().mapFromDatabaseResponse(data['${effectivePrefix}icon']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['package_name'] = Variable<String>(packageName);
    map['name'] = Variable<String>(name);
    map['class_name'] = Variable<String>(className);
    map['version'] = Variable<String>(version);
    if (!nullToAbsent || banner != null) {
      map['banner'] = Variable<Uint8List?>(banner);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<Uint8List?>(icon);
    }
    return map;
  }

  AppsCompanion toCompanion(bool nullToAbsent) {
    return AppsCompanion(
      packageName: Value(packageName),
      name: Value(name),
      className: Value(className),
      version: Value(version),
      banner: banner == null && nullToAbsent ? const Value.absent() : Value(banner),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory App.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return App(
      packageName: serializer.fromJson<String>(json['packageName']),
      name: serializer.fromJson<String>(json['name']),
      className: serializer.fromJson<String>(json['className']),
      version: serializer.fromJson<String>(json['version']),
      banner: serializer.fromJson<Uint8List?>(json['banner']),
      icon: serializer.fromJson<Uint8List?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'packageName': serializer.toJson<String>(packageName),
      'name': serializer.toJson<String>(name),
      'className': serializer.toJson<String>(className),
      'version': serializer.toJson<String>(version),
      'banner': serializer.toJson<Uint8List?>(banner),
      'icon': serializer.toJson<Uint8List?>(icon),
    };
  }

  App copyWith(
          {String? packageName,
          String? name,
          String? className,
          String? version,
          Uint8List? banner,
          Uint8List? icon}) =>
      App(
        packageName: packageName ?? this.packageName,
        name: name ?? this.name,
        className: className ?? this.className,
        version: version ?? this.version,
        banner: banner ?? this.banner,
        icon: icon ?? this.icon,
      );
  @override
  String toString() {
    return (StringBuffer('App(')
          ..write('packageName: $packageName, ')
          ..write('name: $name, ')
          ..write('className: $className, ')
          ..write('version: $version, ')
          ..write('banner: $banner, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(packageName.hashCode,
      $mrjc(name.hashCode, $mrjc(className.hashCode, $mrjc(version.hashCode, $mrjc(banner.hashCode, icon.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is App &&
          other.packageName == this.packageName &&
          other.name == this.name &&
          other.className == this.className &&
          other.version == this.version &&
          other.banner == this.banner &&
          other.icon == this.icon);
}

class AppsCompanion extends UpdateCompanion<App> {
  final Value<String> packageName;
  final Value<String> name;
  final Value<String> className;
  final Value<String> version;
  final Value<Uint8List?> banner;
  final Value<Uint8List?> icon;
  const AppsCompanion({
    this.packageName = const Value.absent(),
    this.name = const Value.absent(),
    this.className = const Value.absent(),
    this.version = const Value.absent(),
    this.banner = const Value.absent(),
    this.icon = const Value.absent(),
  });
  AppsCompanion.insert({
    required String packageName,
    required String name,
    required String className,
    required String version,
    this.banner = const Value.absent(),
    this.icon = const Value.absent(),
  })  : packageName = Value(packageName),
        name = Value(name),
        className = Value(className),
        version = Value(version);
  static Insertable<App> custom({
    Expression<String>? packageName,
    Expression<String>? name,
    Expression<String>? className,
    Expression<String>? version,
    Expression<Uint8List?>? banner,
    Expression<Uint8List?>? icon,
  }) {
    return RawValuesInsertable({
      if (packageName != null) 'package_name': packageName,
      if (name != null) 'name': name,
      if (className != null) 'class_name': className,
      if (version != null) 'version': version,
      if (banner != null) 'banner': banner,
      if (icon != null) 'icon': icon,
    });
  }

  AppsCompanion copyWith(
      {Value<String>? packageName,
      Value<String>? name,
      Value<String>? className,
      Value<String>? version,
      Value<Uint8List?>? banner,
      Value<Uint8List?>? icon}) {
    return AppsCompanion(
      packageName: packageName ?? this.packageName,
      name: name ?? this.name,
      className: className ?? this.className,
      version: version ?? this.version,
      banner: banner ?? this.banner,
      icon: icon ?? this.icon,
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
    if (className.present) {
      map['class_name'] = Variable<String>(className.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppsCompanion(')
          ..write('packageName: $packageName, ')
          ..write('name: $name, ')
          ..write('className: $className, ')
          ..write('version: $version, ')
          ..write('banner: $banner, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }
}

class $AppsTable extends Apps with TableInfo<$AppsTable, App> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AppsTable(this._db, [this._alias]);
  final VerificationMeta _packageNameMeta = const VerificationMeta('packageName');
  @override
  late final GeneratedTextColumn packageName = _constructPackageName();
  GeneratedTextColumn _constructPackageName() {
    return GeneratedTextColumn(
      'package_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedTextColumn name = _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _classNameMeta = const VerificationMeta('className');
  @override
  late final GeneratedTextColumn className = _constructClassName();
  GeneratedTextColumn _constructClassName() {
    return GeneratedTextColumn(
      'class_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _versionMeta = const VerificationMeta('version');
  @override
  late final GeneratedTextColumn version = _constructVersion();
  GeneratedTextColumn _constructVersion() {
    return GeneratedTextColumn(
      'version',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bannerMeta = const VerificationMeta('banner');
  @override
  late final GeneratedBlobColumn banner = _constructBanner();
  GeneratedBlobColumn _constructBanner() {
    return GeneratedBlobColumn(
      'banner',
      $tableName,
      true,
    );
  }

  final VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedBlobColumn icon = _constructIcon();
  GeneratedBlobColumn _constructIcon() {
    return GeneratedBlobColumn(
      'icon',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [packageName, name, className, version, banner, icon];
  @override
  $AppsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'apps';
  @override
  final String actualTableName = 'apps';
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
    if (data.containsKey('class_name')) {
      context.handle(_classNameMeta, className.isAcceptableOrUnknown(data['class_name']!, _classNameMeta));
    } else if (isInserting) {
      context.missing(_classNameMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {packageName};
  @override
  App map(Map<String, dynamic> data, {String? tablePrefix}) {
    return App.fromData(data, _db, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AppsTable createAlias(String alias) {
    return $AppsTable(_db, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int order;
  Category({required this.id, required this.name, required this.order});
  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Category(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      order: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}order'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['order'] = Variable<int>(order);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      order: Value(order),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
    };
  }

  Category copyWith({int? id, String? name, int? order}) => Category(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')..write('id: $id, ')..write('name: $name, ')..write('order: $order')..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode, $mrjc(name.hashCode, order.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category && other.id == this.id && other.name == this.name && other.order == this.order);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> order;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.order = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int order,
  })  : name = Value(name),
        order = Value(order);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (order != null) 'order': order,
    });
  }

  CategoriesCompanion copyWith({Value<int>? id, Value<String>? name, Value<int>? order}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories with TableInfo<$CategoriesTable, Category> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CategoriesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false, hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedTextColumn name = _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn(
      'name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedIntColumn order = _constructOrder();
  GeneratedIntColumn _constructOrder() {
    return GeneratedIntColumn(
      'order',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, order];
  @override
  $CategoriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'categories';
  @override
  final String actualTableName = 'categories';
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
    return Category.fromData(data, _db, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(_db, alias);
  }
}

class AppCategory extends DataClass implements Insertable<AppCategory> {
  final int categoryId;
  final String appPackageName;
  final int order;
  AppCategory({required this.categoryId, required this.appPackageName, required this.order});
  factory AppCategory.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String? prefix}) {
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
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AppCategory(
      categoryId: serializer.fromJson<int>(json['categoryId']),
      appPackageName: serializer.fromJson<String>(json['appPackageName']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
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
  int get hashCode => $mrjf($mrjc(categoryId.hashCode, $mrjc(appPackageName.hashCode, order.hashCode)));
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
  final GeneratedDatabase _db;
  final String? _alias;
  $AppsCategoriesTable(this._db, [this._alias]);
  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedIntColumn categoryId = _constructCategoryId();
  GeneratedIntColumn _constructCategoryId() {
    return GeneratedIntColumn('category_id', $tableName, false,
        $customConstraints: 'REFERENCES categories(id) ON DELETE CASCADE');
  }

  final VerificationMeta _appPackageNameMeta = const VerificationMeta('appPackageName');
  @override
  late final GeneratedTextColumn appPackageName = _constructAppPackageName();
  GeneratedTextColumn _constructAppPackageName() {
    return GeneratedTextColumn('app_package_name', $tableName, false,
        $customConstraints: 'REFERENCES apps(package_name) ON DELETE CASCADE');
  }

  final VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedIntColumn order = _constructOrder();
  GeneratedIntColumn _constructOrder() {
    return GeneratedIntColumn(
      'order',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [categoryId, appPackageName, order];
  @override
  $AppsCategoriesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'apps_categories';
  @override
  final String actualTableName = 'apps_categories';
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
    return AppCategory.fromData(data, _db, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AppsCategoriesTable createAlias(String alias) {
    return $AppsCategoriesTable(_db, alias);
  }
}

abstract class _$FLauncherDatabase extends GeneratedDatabase {
  _$FLauncherDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $AppsTable apps = $AppsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $AppsCategoriesTable appsCategories = $AppsCategoriesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [apps, categories, appsCategories];
}
