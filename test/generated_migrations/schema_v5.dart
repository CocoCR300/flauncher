// GENERATED CODE, DO NOT EDIT BY HAND.
//@dart=2.12
import 'package:drift/drift.dart';

class AppsData extends DataClass implements Insertable<AppsData> {
  final String packageName;
  final String name;
  final String version;
  final Uint8List? banner;
  final Uint8List? icon;
  final bool hidden;
  final bool sideloaded;
  AppsData(
      {required this.packageName,
      required this.name,
      required this.version,
      this.banner,
      this.icon,
      required this.hidden,
      required this.sideloaded});
  factory AppsData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return AppsData(
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

  factory AppsData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppsData(
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

  AppsData copyWith(
          {String? packageName,
          String? name,
          String? version,
          Uint8List? banner,
          Uint8List? icon,
          bool? hidden,
          bool? sideloaded}) =>
      AppsData(
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
    return (StringBuffer('AppsData(')
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
      (other is AppsData &&
          other.packageName == this.packageName &&
          other.name == this.name &&
          other.version == this.version &&
          other.banner == this.banner &&
          other.icon == this.icon &&
          other.hidden == this.hidden &&
          other.sideloaded == this.sideloaded);
}

class AppsCompanion extends UpdateCompanion<AppsData> {
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
  static Insertable<AppsData> custom({
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

class Apps extends Table with TableInfo<Apps, AppsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Apps(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String?> packageName = GeneratedColumn<String?>('package_name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<String?> name =
      GeneratedColumn<String?>('name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<String?> version =
      GeneratedColumn<String?>('version', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<Uint8List?> banner =
      GeneratedColumn<Uint8List?>('banner', aliasedName, true, type: const BlobType(), requiredDuringInsert: false);
  late final GeneratedColumn<Uint8List?> icon =
      GeneratedColumn<Uint8List?>('icon', aliasedName, true, type: const BlobType(), requiredDuringInsert: false);
  late final GeneratedColumn<bool?> hidden = GeneratedColumn<bool?>('hidden', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (hidden IN (0, 1))',
      defaultValue: Constant(false));
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
  Set<GeneratedColumn> get $primaryKey => {packageName};
  @override
  AppsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return AppsData.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Apps createAlias(String alias) {
    return Apps(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => false;
}

class CategoriesData extends DataClass implements Insertable<CategoriesData> {
  final int id;
  final String name;
  final int sort;
  final int type;
  final int rowHeight;
  final int columnsCount;
  final int order;
  CategoriesData(
      {required this.id,
      required this.name,
      required this.sort,
      required this.type,
      required this.rowHeight,
      required this.columnsCount,
      required this.order});
  factory CategoriesData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CategoriesData(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType().mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      sort: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}sort'])!,
      type: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}type'])!,
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
    map['sort'] = Variable<int>(sort);
    map['type'] = Variable<int>(type);
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

  factory CategoriesData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sort: serializer.fromJson<int>(json['sort']),
      type: serializer.fromJson<int>(json['type']),
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
      'sort': serializer.toJson<int>(sort),
      'type': serializer.toJson<int>(type),
      'rowHeight': serializer.toJson<int>(rowHeight),
      'columnsCount': serializer.toJson<int>(columnsCount),
      'order': serializer.toJson<int>(order),
    };
  }

  CategoriesData copyWith(
          {int? id, String? name, int? sort, int? type, int? rowHeight, int? columnsCount, int? order}) =>
      CategoriesData(
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
    return (StringBuffer('CategoriesData(')
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
      (other is CategoriesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.sort == this.sort &&
          other.type == this.type &&
          other.rowHeight == this.rowHeight &&
          other.columnsCount == this.columnsCount &&
          other.order == this.order);
}

class CategoriesCompanion extends UpdateCompanion<CategoriesData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sort;
  final Value<int> type;
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
  static Insertable<CategoriesData> custom({
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
      Value<int>? sort,
      Value<int>? type,
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
      map['sort'] = Variable<int>(sort.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
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

class Categories extends Table with TableInfo<Categories, CategoriesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categories(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>('id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false, defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  late final GeneratedColumn<String?> name =
      GeneratedColumn<String?>('name', aliasedName, false, type: const StringType(), requiredDuringInsert: true);
  late final GeneratedColumn<int?> sort = GeneratedColumn<int?>('sort', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false, defaultValue: Constant(0));
  late final GeneratedColumn<int?> type = GeneratedColumn<int?>('type', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false, defaultValue: Constant(0));
  late final GeneratedColumn<int?> rowHeight = GeneratedColumn<int?>('row_height', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false, defaultValue: Constant(110));
  late final GeneratedColumn<int?> columnsCount = GeneratedColumn<int?>('columns_count', aliasedName, false,
      type: const IntType(), requiredDuringInsert: false, defaultValue: Constant(6));
  late final GeneratedColumn<int?> order =
      GeneratedColumn<int?>('order', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, sort, type, rowHeight, columnsCount, order];
  @override
  String get aliasedName => _alias ?? 'categories';
  @override
  String get actualTableName => 'categories';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CategoriesData.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  Categories createAlias(String alias) {
    return Categories(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => false;
}

class AppsCategoriesData extends DataClass implements Insertable<AppsCategoriesData> {
  final int categoryId;
  final String appPackageName;
  final int order;
  AppsCategoriesData({required this.categoryId, required this.appPackageName, required this.order});
  factory AppsCategoriesData.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return AppsCategoriesData(
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

  factory AppsCategoriesData.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppsCategoriesData(
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

  AppsCategoriesData copyWith({int? categoryId, String? appPackageName, int? order}) => AppsCategoriesData(
        categoryId: categoryId ?? this.categoryId,
        appPackageName: appPackageName ?? this.appPackageName,
        order: order ?? this.order,
      );
  @override
  String toString() {
    return (StringBuffer('AppsCategoriesData(')
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
      (other is AppsCategoriesData &&
          other.categoryId == this.categoryId &&
          other.appPackageName == this.appPackageName &&
          other.order == this.order);
}

class AppsCategoriesCompanion extends UpdateCompanion<AppsCategoriesData> {
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
  static Insertable<AppsCategoriesData> custom({
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

class AppsCategories extends Table with TableInfo<AppsCategories, AppsCategoriesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AppsCategories(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int?> categoryId = GeneratedColumn<int?>('category_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES categories(id) ON DELETE CASCADE');
  late final GeneratedColumn<String?> appPackageName = GeneratedColumn<String?>('app_package_name', aliasedName, false,
      type: const StringType(),
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES apps(package_name) ON DELETE CASCADE');
  late final GeneratedColumn<int?> order =
      GeneratedColumn<int?>('order', aliasedName, false, type: const IntType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [categoryId, appPackageName, order];
  @override
  String get aliasedName => _alias ?? 'apps_categories';
  @override
  String get actualTableName => 'apps_categories';
  @override
  Set<GeneratedColumn> get $primaryKey => {categoryId, appPackageName};
  @override
  AppsCategoriesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return AppsCategoriesData.fromData(data, prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  AppsCategories createAlias(String alias) {
    return AppsCategories(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => false;
}

class DatabaseAtV5 extends GeneratedDatabase {
  DatabaseAtV5(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final Apps apps = Apps(this);
  late final Categories categories = Categories(this);
  late final AppsCategories appsCategories = AppsCategories(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [apps, categories, appsCategories];
  @override
  int get schemaVersion => 5;
}
