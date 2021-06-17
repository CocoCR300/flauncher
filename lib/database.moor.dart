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
  final String name;
  final int order;
  Category({required this.name, required this.order});
  factory Category.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Category(
      name: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      order: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}order'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['order'] = Variable<int>(order);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      name: Value(name),
      order: Value(order),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Category(
      name: serializer.fromJson<String>(json['name']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'order': serializer.toJson<int>(order),
    };
  }

  Category copyWith({String? name, int? order}) => Category(
        name: name ?? this.name,
        order: order ?? this.order,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')..write('name: $name, ')..write('order: $order')..write(')')).toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(name.hashCode, order.hashCode));
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Category && other.name == this.name && other.order == this.order);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> name;
  final Value<int> order;
  const CategoriesCompanion({
    this.name = const Value.absent(),
    this.order = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String name,
    required int order,
  })  : name = Value(name),
        order = Value(order);
  static Insertable<Category> custom({
    Expression<String>? name,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (order != null) 'order': order,
    });
  }

  CategoriesCompanion copyWith({Value<String>? name, Value<int>? order}) {
    return CategoriesCompanion(
      name: name ?? this.name,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
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
    return (StringBuffer('CategoriesCompanion(')..write('name: $name, ')..write('order: $order')..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories with TableInfo<$CategoriesTable, Category> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CategoriesTable(this._db, [this._alias]);
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
  List<GeneratedColumn> get $columns => [name, order];
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
  Set<GeneratedColumn> get $primaryKey => {name};
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
  final String categoryName;
  final String appPackageName;
  final int order;
  AppCategory({required this.categoryName, required this.appPackageName, required this.order});
  factory AppCategory.fromData(Map<String, dynamic> data, GeneratedDatabase db, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return AppCategory(
      categoryName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}category_name'])!,
      appPackageName: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}app_package_name'])!,
      order: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}order'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_name'] = Variable<String>(categoryName);
    map['app_package_name'] = Variable<String>(appPackageName);
    map['order'] = Variable<int>(order);
    return map;
  }

  AppsCategoriesCompanion toCompanion(bool nullToAbsent) {
    return AppsCategoriesCompanion(
      categoryName: Value(categoryName),
      appPackageName: Value(appPackageName),
      order: Value(order),
    );
  }

  factory AppCategory.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return AppCategory(
      categoryName: serializer.fromJson<String>(json['categoryName']),
      appPackageName: serializer.fromJson<String>(json['appPackageName']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryName': serializer.toJson<String>(categoryName),
      'appPackageName': serializer.toJson<String>(appPackageName),
      'order': serializer.toJson<int>(order),
    };
  }

  AppCategory copyWith({String? categoryName, String? appPackageName, int? order}) => AppCategory(
        categoryName: categoryName ?? this.categoryName,
        appPackageName: appPackageName ?? this.appPackageName,
        order: order ?? this.order,
      );
  @override
  String toString() {
    return (StringBuffer('AppCategory(')
          ..write('categoryName: $categoryName, ')
          ..write('appPackageName: $appPackageName, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(categoryName.hashCode, $mrjc(appPackageName.hashCode, order.hashCode)));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppCategory &&
          other.categoryName == this.categoryName &&
          other.appPackageName == this.appPackageName &&
          other.order == this.order);
}

class AppsCategoriesCompanion extends UpdateCompanion<AppCategory> {
  final Value<String> categoryName;
  final Value<String> appPackageName;
  final Value<int> order;
  const AppsCategoriesCompanion({
    this.categoryName = const Value.absent(),
    this.appPackageName = const Value.absent(),
    this.order = const Value.absent(),
  });
  AppsCategoriesCompanion.insert({
    required String categoryName,
    required String appPackageName,
    required int order,
  })  : categoryName = Value(categoryName),
        appPackageName = Value(appPackageName),
        order = Value(order);
  static Insertable<AppCategory> custom({
    Expression<String>? categoryName,
    Expression<String>? appPackageName,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (categoryName != null) 'category_name': categoryName,
      if (appPackageName != null) 'app_package_name': appPackageName,
      if (order != null) 'order': order,
    });
  }

  AppsCategoriesCompanion copyWith({Value<String>? categoryName, Value<String>? appPackageName, Value<int>? order}) {
    return AppsCategoriesCompanion(
      categoryName: categoryName ?? this.categoryName,
      appPackageName: appPackageName ?? this.appPackageName,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
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
          ..write('categoryName: $categoryName, ')
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
  final VerificationMeta _categoryNameMeta = const VerificationMeta('categoryName');
  @override
  late final GeneratedTextColumn categoryName = _constructCategoryName();
  GeneratedTextColumn _constructCategoryName() {
    return GeneratedTextColumn('category_name', $tableName, false,
        $customConstraints: 'REFERENCES categories(name) ON DELETE CASCADE');
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
  List<GeneratedColumn> get $columns => [categoryName, appPackageName, order];
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
    if (data.containsKey('category_name')) {
      context.handle(_categoryNameMeta, categoryName.isAcceptableOrUnknown(data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
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
  Set<GeneratedColumn> get $primaryKey => {categoryName, appPackageName};
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
