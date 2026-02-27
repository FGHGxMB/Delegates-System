// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String? value;
  const Setting({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  Setting copyWith(
          {String? key, Value<String?> value = const Value.absent()}) =>
      Setting(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key, Value<String?>? value, Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WarehousesTable extends Warehouses
    with TableInfo<$WarehousesTable, Warehouse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WarehousesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'warehouses';
  @override
  VerificationContext validateIntegrity(Insertable<Warehouse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Warehouse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Warehouse(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $WarehousesTable createAlias(String alias) {
    return $WarehousesTable(attachedDatabase, alias);
  }
}

class Warehouse extends DataClass implements Insertable<Warehouse> {
  final int id;
  final String name;
  const Warehouse({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  WarehousesCompanion toCompanion(bool nullToAbsent) {
    return WarehousesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory Warehouse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Warehouse(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Warehouse copyWith({int? id, String? name}) => Warehouse(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  Warehouse copyWithCompanion(WarehousesCompanion data) {
    return Warehouse(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Warehouse(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Warehouse && other.id == this.id && other.name == this.name);
}

class WarehousesCompanion extends UpdateCompanion<Warehouse> {
  final Value<int> id;
  final Value<String> name;
  const WarehousesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  WarehousesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<Warehouse> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  WarehousesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return WarehousesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WarehousesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountCodeMeta =
      const VerificationMeta('accountCode');
  @override
  late final GeneratedColumn<String> accountCode = GeneratedColumn<String>(
      'account_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phone1Meta = const VerificationMeta('phone1');
  @override
  late final GeneratedColumn<String> phone1 = GeneratedColumn<String>(
      'phone1', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phone2Meta = const VerificationMeta('phone2');
  @override
  late final GeneratedColumn<String> phone2 = GeneratedColumn<String>(
      'phone2', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
      'area', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _neighborhoodMeta =
      const VerificationMeta('neighborhood');
  @override
  late final GeneratedColumn<String> neighborhood = GeneratedColumn<String>(
      'neighborhood', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _streetMeta = const VerificationMeta('street');
  @override
  late final GeneratedColumn<String> street = GeneratedColumn<String>(
      'street', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSentMeta = const VerificationMeta('isSent');
  @override
  late final GeneratedColumn<bool> isSent = GeneratedColumn<bool>(
      'is_sent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_sent" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isModifiedMeta =
      const VerificationMeta('isModified');
  @override
  late final GeneratedColumn<bool> isModified = GeneratedColumn<bool>(
      'is_modified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_modified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountCode,
        name,
        currency,
        phone1,
        phone2,
        email,
        notes,
        country,
        city,
        area,
        neighborhood,
        street,
        gender,
        isSent,
        isModified,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_code')) {
      context.handle(
          _accountCodeMeta,
          accountCode.isAcceptableOrUnknown(
              data['account_code']!, _accountCodeMeta));
    } else if (isInserting) {
      context.missing(_accountCodeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('phone1')) {
      context.handle(_phone1Meta,
          phone1.isAcceptableOrUnknown(data['phone1']!, _phone1Meta));
    }
    if (data.containsKey('phone2')) {
      context.handle(_phone2Meta,
          phone2.isAcceptableOrUnknown(data['phone2']!, _phone2Meta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('area')) {
      context.handle(
          _areaMeta, area.isAcceptableOrUnknown(data['area']!, _areaMeta));
    }
    if (data.containsKey('neighborhood')) {
      context.handle(
          _neighborhoodMeta,
          neighborhood.isAcceptableOrUnknown(
              data['neighborhood']!, _neighborhoodMeta));
    }
    if (data.containsKey('street')) {
      context.handle(_streetMeta,
          street.isAcceptableOrUnknown(data['street']!, _streetMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('is_sent')) {
      context.handle(_isSentMeta,
          isSent.isAcceptableOrUnknown(data['is_sent']!, _isSentMeta));
    }
    if (data.containsKey('is_modified')) {
      context.handle(
          _isModifiedMeta,
          isModified.isAcceptableOrUnknown(
              data['is_modified']!, _isModifiedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      phone1: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone1']),
      phone2: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone2']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      area: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}area']),
      neighborhood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}neighborhood']),
      street: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}street']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      isSent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_sent'])!,
      isModified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_modified'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String accountCode;
  final String name;
  final String currency;
  final String? phone1;
  final String? phone2;
  final String? email;
  final String? notes;
  final String? country;
  final String? city;
  final String? area;
  final String? neighborhood;
  final String? street;
  final String gender;
  final bool isSent;
  final bool isModified;
  final DateTime? createdAt;
  const Customer(
      {required this.id,
      required this.accountCode,
      required this.name,
      required this.currency,
      this.phone1,
      this.phone2,
      this.email,
      this.notes,
      this.country,
      this.city,
      this.area,
      this.neighborhood,
      this.street,
      required this.gender,
      required this.isSent,
      required this.isModified,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_code'] = Variable<String>(accountCode);
    map['name'] = Variable<String>(name);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || phone1 != null) {
      map['phone1'] = Variable<String>(phone1);
    }
    if (!nullToAbsent || phone2 != null) {
      map['phone2'] = Variable<String>(phone2);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || area != null) {
      map['area'] = Variable<String>(area);
    }
    if (!nullToAbsent || neighborhood != null) {
      map['neighborhood'] = Variable<String>(neighborhood);
    }
    if (!nullToAbsent || street != null) {
      map['street'] = Variable<String>(street);
    }
    map['gender'] = Variable<String>(gender);
    map['is_sent'] = Variable<bool>(isSent);
    map['is_modified'] = Variable<bool>(isModified);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      accountCode: Value(accountCode),
      name: Value(name),
      currency: Value(currency),
      phone1:
          phone1 == null && nullToAbsent ? const Value.absent() : Value(phone1),
      phone2:
          phone2 == null && nullToAbsent ? const Value.absent() : Value(phone2),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      area: area == null && nullToAbsent ? const Value.absent() : Value(area),
      neighborhood: neighborhood == null && nullToAbsent
          ? const Value.absent()
          : Value(neighborhood),
      street:
          street == null && nullToAbsent ? const Value.absent() : Value(street),
      gender: Value(gender),
      isSent: Value(isSent),
      isModified: Value(isModified),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      accountCode: serializer.fromJson<String>(json['accountCode']),
      name: serializer.fromJson<String>(json['name']),
      currency: serializer.fromJson<String>(json['currency']),
      phone1: serializer.fromJson<String?>(json['phone1']),
      phone2: serializer.fromJson<String?>(json['phone2']),
      email: serializer.fromJson<String?>(json['email']),
      notes: serializer.fromJson<String?>(json['notes']),
      country: serializer.fromJson<String?>(json['country']),
      city: serializer.fromJson<String?>(json['city']),
      area: serializer.fromJson<String?>(json['area']),
      neighborhood: serializer.fromJson<String?>(json['neighborhood']),
      street: serializer.fromJson<String?>(json['street']),
      gender: serializer.fromJson<String>(json['gender']),
      isSent: serializer.fromJson<bool>(json['isSent']),
      isModified: serializer.fromJson<bool>(json['isModified']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountCode': serializer.toJson<String>(accountCode),
      'name': serializer.toJson<String>(name),
      'currency': serializer.toJson<String>(currency),
      'phone1': serializer.toJson<String?>(phone1),
      'phone2': serializer.toJson<String?>(phone2),
      'email': serializer.toJson<String?>(email),
      'notes': serializer.toJson<String?>(notes),
      'country': serializer.toJson<String?>(country),
      'city': serializer.toJson<String?>(city),
      'area': serializer.toJson<String?>(area),
      'neighborhood': serializer.toJson<String?>(neighborhood),
      'street': serializer.toJson<String?>(street),
      'gender': serializer.toJson<String>(gender),
      'isSent': serializer.toJson<bool>(isSent),
      'isModified': serializer.toJson<bool>(isModified),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  Customer copyWith(
          {int? id,
          String? accountCode,
          String? name,
          String? currency,
          Value<String?> phone1 = const Value.absent(),
          Value<String?> phone2 = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> country = const Value.absent(),
          Value<String?> city = const Value.absent(),
          Value<String?> area = const Value.absent(),
          Value<String?> neighborhood = const Value.absent(),
          Value<String?> street = const Value.absent(),
          String? gender,
          bool? isSent,
          bool? isModified,
          Value<DateTime?> createdAt = const Value.absent()}) =>
      Customer(
        id: id ?? this.id,
        accountCode: accountCode ?? this.accountCode,
        name: name ?? this.name,
        currency: currency ?? this.currency,
        phone1: phone1.present ? phone1.value : this.phone1,
        phone2: phone2.present ? phone2.value : this.phone2,
        email: email.present ? email.value : this.email,
        notes: notes.present ? notes.value : this.notes,
        country: country.present ? country.value : this.country,
        city: city.present ? city.value : this.city,
        area: area.present ? area.value : this.area,
        neighborhood:
            neighborhood.present ? neighborhood.value : this.neighborhood,
        street: street.present ? street.value : this.street,
        gender: gender ?? this.gender,
        isSent: isSent ?? this.isSent,
        isModified: isModified ?? this.isModified,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      accountCode:
          data.accountCode.present ? data.accountCode.value : this.accountCode,
      name: data.name.present ? data.name.value : this.name,
      currency: data.currency.present ? data.currency.value : this.currency,
      phone1: data.phone1.present ? data.phone1.value : this.phone1,
      phone2: data.phone2.present ? data.phone2.value : this.phone2,
      email: data.email.present ? data.email.value : this.email,
      notes: data.notes.present ? data.notes.value : this.notes,
      country: data.country.present ? data.country.value : this.country,
      city: data.city.present ? data.city.value : this.city,
      area: data.area.present ? data.area.value : this.area,
      neighborhood: data.neighborhood.present
          ? data.neighborhood.value
          : this.neighborhood,
      street: data.street.present ? data.street.value : this.street,
      gender: data.gender.present ? data.gender.value : this.gender,
      isSent: data.isSent.present ? data.isSent.value : this.isSent,
      isModified:
          data.isModified.present ? data.isModified.value : this.isModified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('accountCode: $accountCode, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('phone1: $phone1, ')
          ..write('phone2: $phone2, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('country: $country, ')
          ..write('city: $city, ')
          ..write('area: $area, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('street: $street, ')
          ..write('gender: $gender, ')
          ..write('isSent: $isSent, ')
          ..write('isModified: $isModified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountCode,
      name,
      currency,
      phone1,
      phone2,
      email,
      notes,
      country,
      city,
      area,
      neighborhood,
      street,
      gender,
      isSent,
      isModified,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.accountCode == this.accountCode &&
          other.name == this.name &&
          other.currency == this.currency &&
          other.phone1 == this.phone1 &&
          other.phone2 == this.phone2 &&
          other.email == this.email &&
          other.notes == this.notes &&
          other.country == this.country &&
          other.city == this.city &&
          other.area == this.area &&
          other.neighborhood == this.neighborhood &&
          other.street == this.street &&
          other.gender == this.gender &&
          other.isSent == this.isSent &&
          other.isModified == this.isModified &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> accountCode;
  final Value<String> name;
  final Value<String> currency;
  final Value<String?> phone1;
  final Value<String?> phone2;
  final Value<String?> email;
  final Value<String?> notes;
  final Value<String?> country;
  final Value<String?> city;
  final Value<String?> area;
  final Value<String?> neighborhood;
  final Value<String?> street;
  final Value<String> gender;
  final Value<bool> isSent;
  final Value<bool> isModified;
  final Value<DateTime?> createdAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.accountCode = const Value.absent(),
    this.name = const Value.absent(),
    this.currency = const Value.absent(),
    this.phone1 = const Value.absent(),
    this.phone2 = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.country = const Value.absent(),
    this.city = const Value.absent(),
    this.area = const Value.absent(),
    this.neighborhood = const Value.absent(),
    this.street = const Value.absent(),
    this.gender = const Value.absent(),
    this.isSent = const Value.absent(),
    this.isModified = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String accountCode,
    required String name,
    required String currency,
    this.phone1 = const Value.absent(),
    this.phone2 = const Value.absent(),
    this.email = const Value.absent(),
    this.notes = const Value.absent(),
    this.country = const Value.absent(),
    this.city = const Value.absent(),
    this.area = const Value.absent(),
    this.neighborhood = const Value.absent(),
    this.street = const Value.absent(),
    required String gender,
    this.isSent = const Value.absent(),
    this.isModified = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : accountCode = Value(accountCode),
        name = Value(name),
        currency = Value(currency),
        gender = Value(gender);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? accountCode,
    Expression<String>? name,
    Expression<String>? currency,
    Expression<String>? phone1,
    Expression<String>? phone2,
    Expression<String>? email,
    Expression<String>? notes,
    Expression<String>? country,
    Expression<String>? city,
    Expression<String>? area,
    Expression<String>? neighborhood,
    Expression<String>? street,
    Expression<String>? gender,
    Expression<bool>? isSent,
    Expression<bool>? isModified,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountCode != null) 'account_code': accountCode,
      if (name != null) 'name': name,
      if (currency != null) 'currency': currency,
      if (phone1 != null) 'phone1': phone1,
      if (phone2 != null) 'phone2': phone2,
      if (email != null) 'email': email,
      if (notes != null) 'notes': notes,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (area != null) 'area': area,
      if (neighborhood != null) 'neighborhood': neighborhood,
      if (street != null) 'street': street,
      if (gender != null) 'gender': gender,
      if (isSent != null) 'is_sent': isSent,
      if (isModified != null) 'is_modified': isModified,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith(
      {Value<int>? id,
      Value<String>? accountCode,
      Value<String>? name,
      Value<String>? currency,
      Value<String?>? phone1,
      Value<String?>? phone2,
      Value<String?>? email,
      Value<String?>? notes,
      Value<String?>? country,
      Value<String?>? city,
      Value<String?>? area,
      Value<String?>? neighborhood,
      Value<String?>? street,
      Value<String>? gender,
      Value<bool>? isSent,
      Value<bool>? isModified,
      Value<DateTime?>? createdAt}) {
    return CustomersCompanion(
      id: id ?? this.id,
      accountCode: accountCode ?? this.accountCode,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      country: country ?? this.country,
      city: city ?? this.city,
      area: area ?? this.area,
      neighborhood: neighborhood ?? this.neighborhood,
      street: street ?? this.street,
      gender: gender ?? this.gender,
      isSent: isSent ?? this.isSent,
      isModified: isModified ?? this.isModified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountCode.present) {
      map['account_code'] = Variable<String>(accountCode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (phone1.present) {
      map['phone1'] = Variable<String>(phone1.value);
    }
    if (phone2.present) {
      map['phone2'] = Variable<String>(phone2.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (neighborhood.present) {
      map['neighborhood'] = Variable<String>(neighborhood.value);
    }
    if (street.present) {
      map['street'] = Variable<String>(street.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (isSent.present) {
      map['is_sent'] = Variable<bool>(isSent.value);
    }
    if (isModified.present) {
      map['is_modified'] = Variable<bool>(isModified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('accountCode: $accountCode, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('phone1: $phone1, ')
          ..write('phone2: $phone2, ')
          ..write('email: $email, ')
          ..write('notes: $notes, ')
          ..write('country: $country, ')
          ..write('city: $city, ')
          ..write('area: $area, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('street: $street, ')
          ..write('gender: $gender, ')
          ..write('isSent: $isSent, ')
          ..write('isModified: $isModified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProductCategoriesTable extends ProductCategories
    with TableInfo<$ProductCategoriesTable, ProductCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _gridColumnsMeta =
      const VerificationMeta('gridColumns');
  @override
  late final GeneratedColumn<int> gridColumns = GeneratedColumn<int>(
      'grid_columns', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(2));
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isVisibleMeta =
      const VerificationMeta('isVisible');
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
      'is_visible', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_visible" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, gridColumns, displayOrder, isVisible];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ProductCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('grid_columns')) {
      context.handle(
          _gridColumnsMeta,
          gridColumns.isAcceptableOrUnknown(
              data['grid_columns']!, _gridColumnsMeta));
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    }
    if (data.containsKey('is_visible')) {
      context.handle(_isVisibleMeta,
          isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      gridColumns: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grid_columns'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
      isVisible: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_visible'])!,
    );
  }

  @override
  $ProductCategoriesTable createAlias(String alias) {
    return $ProductCategoriesTable(attachedDatabase, alias);
  }
}

class ProductCategory extends DataClass implements Insertable<ProductCategory> {
  final int id;
  final String name;
  final int gridColumns;
  final int displayOrder;
  final bool isVisible;
  const ProductCategory(
      {required this.id,
      required this.name,
      required this.gridColumns,
      required this.displayOrder,
      required this.isVisible});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['grid_columns'] = Variable<int>(gridColumns);
    map['display_order'] = Variable<int>(displayOrder);
    map['is_visible'] = Variable<bool>(isVisible);
    return map;
  }

  ProductCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ProductCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      gridColumns: Value(gridColumns),
      displayOrder: Value(displayOrder),
      isVisible: Value(isVisible),
    );
  }

  factory ProductCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      gridColumns: serializer.fromJson<int>(json['gridColumns']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'gridColumns': serializer.toJson<int>(gridColumns),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isVisible': serializer.toJson<bool>(isVisible),
    };
  }

  ProductCategory copyWith(
          {int? id,
          String? name,
          int? gridColumns,
          int? displayOrder,
          bool? isVisible}) =>
      ProductCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        gridColumns: gridColumns ?? this.gridColumns,
        displayOrder: displayOrder ?? this.displayOrder,
        isVisible: isVisible ?? this.isVisible,
      );
  ProductCategory copyWithCompanion(ProductCategoriesCompanion data) {
    return ProductCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      gridColumns:
          data.gridColumns.present ? data.gridColumns.value : this.gridColumns,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gridColumns: $gridColumns, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isVisible: $isVisible')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, gridColumns, displayOrder, isVisible);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.gridColumns == this.gridColumns &&
          other.displayOrder == this.displayOrder &&
          other.isVisible == this.isVisible);
}

class ProductCategoriesCompanion extends UpdateCompanion<ProductCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> gridColumns;
  final Value<int> displayOrder;
  final Value<bool> isVisible;
  const ProductCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.gridColumns = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isVisible = const Value.absent(),
  });
  ProductCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.gridColumns = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isVisible = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ProductCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? gridColumns,
    Expression<int>? displayOrder,
    Expression<bool>? isVisible,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (gridColumns != null) 'grid_columns': gridColumns,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isVisible != null) 'is_visible': isVisible,
    });
  }

  ProductCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? gridColumns,
      Value<int>? displayOrder,
      Value<bool>? isVisible}) {
    return ProductCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      gridColumns: gridColumns ?? this.gridColumns,
      displayOrder: displayOrder ?? this.displayOrder,
      isVisible: isVisible ?? this.isVisible,
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
    if (gridColumns.present) {
      map['grid_columns'] = Variable<int>(gridColumns.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('gridColumns: $gridColumns, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isVisible: $isVisible')
          ..write(')'))
        .toString();
  }
}

class $ProductColumnsTable extends ProductColumns
    with TableInfo<$ProductColumnsTable, ProductColumn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductColumnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES product_categories(id)');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isVisibleMeta =
      const VerificationMeta('isVisible');
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
      'is_visible', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_visible" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, name, isVisible, displayOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_columns';
  @override
  VerificationContext validateIntegrity(Insertable<ProductColumn> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_visible')) {
      context.handle(_isVisibleMeta,
          isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta));
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductColumn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductColumn(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isVisible: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_visible'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
    );
  }

  @override
  $ProductColumnsTable createAlias(String alias) {
    return $ProductColumnsTable(attachedDatabase, alias);
  }
}

class ProductColumn extends DataClass implements Insertable<ProductColumn> {
  final int id;
  final int categoryId;
  final String name;
  final bool isVisible;
  final int displayOrder;
  const ProductColumn(
      {required this.id,
      required this.categoryId,
      required this.name,
      required this.isVisible,
      required this.displayOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['name'] = Variable<String>(name);
    map['is_visible'] = Variable<bool>(isVisible);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  ProductColumnsCompanion toCompanion(bool nullToAbsent) {
    return ProductColumnsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      isVisible: Value(isVisible),
      displayOrder: Value(displayOrder),
    );
  }

  factory ProductColumn.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductColumn(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'name': serializer.toJson<String>(name),
      'isVisible': serializer.toJson<bool>(isVisible),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  ProductColumn copyWith(
          {int? id,
          int? categoryId,
          String? name,
          bool? isVisible,
          int? displayOrder}) =>
      ProductColumn(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        isVisible: isVisible ?? this.isVisible,
        displayOrder: displayOrder ?? this.displayOrder,
      );
  ProductColumn copyWithCompanion(ProductColumnsCompanion data) {
    return ProductColumn(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductColumn(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('isVisible: $isVisible, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, name, isVisible, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductColumn &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.isVisible == this.isVisible &&
          other.displayOrder == this.displayOrder);
}

class ProductColumnsCompanion extends UpdateCompanion<ProductColumn> {
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> name;
  final Value<bool> isVisible;
  final Value<int> displayOrder;
  const ProductColumnsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  ProductColumnsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryId,
    required String name,
    this.isVisible = const Value.absent(),
    this.displayOrder = const Value.absent(),
  })  : categoryId = Value(categoryId),
        name = Value(name);
  static Insertable<ProductColumn> custom({
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? name,
    Expression<bool>? isVisible,
    Expression<int>? displayOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (isVisible != null) 'is_visible': isVisible,
      if (displayOrder != null) 'display_order': displayOrder,
    });
  }

  ProductColumnsCompanion copyWith(
      {Value<int>? id,
      Value<int>? categoryId,
      Value<String>? name,
      Value<bool>? isVisible,
      Value<int>? displayOrder}) {
    return ProductColumnsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductColumnsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('isVisible: $isVisible, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_categories (id)'));
  static const VerificationMeta _columnIdMeta =
      const VerificationMeta('columnId');
  @override
  late final GeneratedColumn<int> columnId = GeneratedColumn<int>(
      'column_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      $customConstraints: 'REFERENCES product_columns(id)');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unit1NameMeta =
      const VerificationMeta('unit1Name');
  @override
  late final GeneratedColumn<String> unit1Name = GeneratedColumn<String>(
      'unit1_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unit1BarcodeMeta =
      const VerificationMeta('unit1Barcode');
  @override
  late final GeneratedColumn<String> unit1Barcode = GeneratedColumn<String>(
      'unit1_barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unit1PriceRetailMeta =
      const VerificationMeta('unit1PriceRetail');
  @override
  late final GeneratedColumn<double> unit1PriceRetail = GeneratedColumn<double>(
      'unit1_price_retail', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unit1PriceWholesaleMeta =
      const VerificationMeta('unit1PriceWholesale');
  @override
  late final GeneratedColumn<double> unit1PriceWholesale =
      GeneratedColumn<double>('unit1_price_wholesale', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  static const VerificationMeta _unit2NameMeta =
      const VerificationMeta('unit2Name');
  @override
  late final GeneratedColumn<String> unit2Name = GeneratedColumn<String>(
      'unit2_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unit2BarcodeMeta =
      const VerificationMeta('unit2Barcode');
  @override
  late final GeneratedColumn<String> unit2Barcode = GeneratedColumn<String>(
      'unit2_barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unit2FactorMeta =
      const VerificationMeta('unit2Factor');
  @override
  late final GeneratedColumn<double> unit2Factor = GeneratedColumn<double>(
      'unit2_factor', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unit2PriceRetailMeta =
      const VerificationMeta('unit2PriceRetail');
  @override
  late final GeneratedColumn<double> unit2PriceRetail = GeneratedColumn<double>(
      'unit2_price_retail', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unit2PriceWholesaleMeta =
      const VerificationMeta('unit2PriceWholesale');
  @override
  late final GeneratedColumn<double> unit2PriceWholesale =
      GeneratedColumn<double>('unit2_price_wholesale', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unit3NameMeta =
      const VerificationMeta('unit3Name');
  @override
  late final GeneratedColumn<String> unit3Name = GeneratedColumn<String>(
      'unit3_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unit3BarcodeMeta =
      const VerificationMeta('unit3Barcode');
  @override
  late final GeneratedColumn<String> unit3Barcode = GeneratedColumn<String>(
      'unit3_barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unit3FactorMeta =
      const VerificationMeta('unit3Factor');
  @override
  late final GeneratedColumn<double> unit3Factor = GeneratedColumn<double>(
      'unit3_factor', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unit3PriceRetailMeta =
      const VerificationMeta('unit3PriceRetail');
  @override
  late final GeneratedColumn<double> unit3PriceRetail = GeneratedColumn<double>(
      'unit3_price_retail', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _unit3PriceWholesaleMeta =
      const VerificationMeta('unit3PriceWholesale');
  @override
  late final GeneratedColumn<double> unit3PriceWholesale =
      GeneratedColumn<double>('unit3_price_wholesale', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _defaultUnitMeta =
      const VerificationMeta('defaultUnit');
  @override
  late final GeneratedColumn<int> defaultUnit = GeneratedColumn<int>(
      'default_unit', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        code,
        categoryId,
        columnId,
        name,
        currency,
        unit1Name,
        unit1Barcode,
        unit1PriceRetail,
        unit1PriceWholesale,
        unit2Name,
        unit2Barcode,
        unit2Factor,
        unit2PriceRetail,
        unit2PriceWholesale,
        unit3Name,
        unit3Barcode,
        unit3Factor,
        unit3PriceRetail,
        unit3PriceWholesale,
        defaultUnit,
        isActive,
        displayOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('column_id')) {
      context.handle(_columnIdMeta,
          columnId.isAcceptableOrUnknown(data['column_id']!, _columnIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('unit1_name')) {
      context.handle(_unit1NameMeta,
          unit1Name.isAcceptableOrUnknown(data['unit1_name']!, _unit1NameMeta));
    } else if (isInserting) {
      context.missing(_unit1NameMeta);
    }
    if (data.containsKey('unit1_barcode')) {
      context.handle(
          _unit1BarcodeMeta,
          unit1Barcode.isAcceptableOrUnknown(
              data['unit1_barcode']!, _unit1BarcodeMeta));
    }
    if (data.containsKey('unit1_price_retail')) {
      context.handle(
          _unit1PriceRetailMeta,
          unit1PriceRetail.isAcceptableOrUnknown(
              data['unit1_price_retail']!, _unit1PriceRetailMeta));
    }
    if (data.containsKey('unit1_price_wholesale')) {
      context.handle(
          _unit1PriceWholesaleMeta,
          unit1PriceWholesale.isAcceptableOrUnknown(
              data['unit1_price_wholesale']!, _unit1PriceWholesaleMeta));
    }
    if (data.containsKey('unit2_name')) {
      context.handle(_unit2NameMeta,
          unit2Name.isAcceptableOrUnknown(data['unit2_name']!, _unit2NameMeta));
    }
    if (data.containsKey('unit2_barcode')) {
      context.handle(
          _unit2BarcodeMeta,
          unit2Barcode.isAcceptableOrUnknown(
              data['unit2_barcode']!, _unit2BarcodeMeta));
    }
    if (data.containsKey('unit2_factor')) {
      context.handle(
          _unit2FactorMeta,
          unit2Factor.isAcceptableOrUnknown(
              data['unit2_factor']!, _unit2FactorMeta));
    }
    if (data.containsKey('unit2_price_retail')) {
      context.handle(
          _unit2PriceRetailMeta,
          unit2PriceRetail.isAcceptableOrUnknown(
              data['unit2_price_retail']!, _unit2PriceRetailMeta));
    }
    if (data.containsKey('unit2_price_wholesale')) {
      context.handle(
          _unit2PriceWholesaleMeta,
          unit2PriceWholesale.isAcceptableOrUnknown(
              data['unit2_price_wholesale']!, _unit2PriceWholesaleMeta));
    }
    if (data.containsKey('unit3_name')) {
      context.handle(_unit3NameMeta,
          unit3Name.isAcceptableOrUnknown(data['unit3_name']!, _unit3NameMeta));
    }
    if (data.containsKey('unit3_barcode')) {
      context.handle(
          _unit3BarcodeMeta,
          unit3Barcode.isAcceptableOrUnknown(
              data['unit3_barcode']!, _unit3BarcodeMeta));
    }
    if (data.containsKey('unit3_factor')) {
      context.handle(
          _unit3FactorMeta,
          unit3Factor.isAcceptableOrUnknown(
              data['unit3_factor']!, _unit3FactorMeta));
    }
    if (data.containsKey('unit3_price_retail')) {
      context.handle(
          _unit3PriceRetailMeta,
          unit3PriceRetail.isAcceptableOrUnknown(
              data['unit3_price_retail']!, _unit3PriceRetailMeta));
    }
    if (data.containsKey('unit3_price_wholesale')) {
      context.handle(
          _unit3PriceWholesaleMeta,
          unit3PriceWholesale.isAcceptableOrUnknown(
              data['unit3_price_wholesale']!, _unit3PriceWholesaleMeta));
    }
    if (data.containsKey('default_unit')) {
      context.handle(
          _defaultUnitMeta,
          defaultUnit.isAcceptableOrUnknown(
              data['default_unit']!, _defaultUnitMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      columnId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}column_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      unit1Name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit1_name'])!,
      unit1Barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit1_barcode']),
      unit1PriceRetail: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}unit1_price_retail'])!,
      unit1PriceWholesale: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}unit1_price_wholesale'])!,
      unit2Name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit2_name']),
      unit2Barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit2_barcode']),
      unit2Factor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit2_factor']),
      unit2PriceRetail: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}unit2_price_retail']),
      unit2PriceWholesale: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}unit2_price_wholesale']),
      unit3Name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit3_name']),
      unit3Barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit3_barcode']),
      unit3Factor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit3_factor']),
      unit3PriceRetail: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}unit3_price_retail']),
      unit3PriceWholesale: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}unit3_price_wholesale']),
      defaultUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}default_unit'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String code;
  final int categoryId;
  final int? columnId;
  final String name;
  final String currency;
  final String unit1Name;
  final String? unit1Barcode;
  final double unit1PriceRetail;
  final double unit1PriceWholesale;
  final String? unit2Name;
  final String? unit2Barcode;
  final double? unit2Factor;
  final double? unit2PriceRetail;
  final double? unit2PriceWholesale;
  final String? unit3Name;
  final String? unit3Barcode;
  final double? unit3Factor;
  final double? unit3PriceRetail;
  final double? unit3PriceWholesale;
  final int defaultUnit;
  final bool isActive;
  final int displayOrder;
  const Product(
      {required this.id,
      required this.code,
      required this.categoryId,
      this.columnId,
      required this.name,
      required this.currency,
      required this.unit1Name,
      this.unit1Barcode,
      required this.unit1PriceRetail,
      required this.unit1PriceWholesale,
      this.unit2Name,
      this.unit2Barcode,
      this.unit2Factor,
      this.unit2PriceRetail,
      this.unit2PriceWholesale,
      this.unit3Name,
      this.unit3Barcode,
      this.unit3Factor,
      this.unit3PriceRetail,
      this.unit3PriceWholesale,
      required this.defaultUnit,
      required this.isActive,
      required this.displayOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || columnId != null) {
      map['column_id'] = Variable<int>(columnId);
    }
    map['name'] = Variable<String>(name);
    map['currency'] = Variable<String>(currency);
    map['unit1_name'] = Variable<String>(unit1Name);
    if (!nullToAbsent || unit1Barcode != null) {
      map['unit1_barcode'] = Variable<String>(unit1Barcode);
    }
    map['unit1_price_retail'] = Variable<double>(unit1PriceRetail);
    map['unit1_price_wholesale'] = Variable<double>(unit1PriceWholesale);
    if (!nullToAbsent || unit2Name != null) {
      map['unit2_name'] = Variable<String>(unit2Name);
    }
    if (!nullToAbsent || unit2Barcode != null) {
      map['unit2_barcode'] = Variable<String>(unit2Barcode);
    }
    if (!nullToAbsent || unit2Factor != null) {
      map['unit2_factor'] = Variable<double>(unit2Factor);
    }
    if (!nullToAbsent || unit2PriceRetail != null) {
      map['unit2_price_retail'] = Variable<double>(unit2PriceRetail);
    }
    if (!nullToAbsent || unit2PriceWholesale != null) {
      map['unit2_price_wholesale'] = Variable<double>(unit2PriceWholesale);
    }
    if (!nullToAbsent || unit3Name != null) {
      map['unit3_name'] = Variable<String>(unit3Name);
    }
    if (!nullToAbsent || unit3Barcode != null) {
      map['unit3_barcode'] = Variable<String>(unit3Barcode);
    }
    if (!nullToAbsent || unit3Factor != null) {
      map['unit3_factor'] = Variable<double>(unit3Factor);
    }
    if (!nullToAbsent || unit3PriceRetail != null) {
      map['unit3_price_retail'] = Variable<double>(unit3PriceRetail);
    }
    if (!nullToAbsent || unit3PriceWholesale != null) {
      map['unit3_price_wholesale'] = Variable<double>(unit3PriceWholesale);
    }
    map['default_unit'] = Variable<int>(defaultUnit);
    map['is_active'] = Variable<bool>(isActive);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      code: Value(code),
      categoryId: Value(categoryId),
      columnId: columnId == null && nullToAbsent
          ? const Value.absent()
          : Value(columnId),
      name: Value(name),
      currency: Value(currency),
      unit1Name: Value(unit1Name),
      unit1Barcode: unit1Barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(unit1Barcode),
      unit1PriceRetail: Value(unit1PriceRetail),
      unit1PriceWholesale: Value(unit1PriceWholesale),
      unit2Name: unit2Name == null && nullToAbsent
          ? const Value.absent()
          : Value(unit2Name),
      unit2Barcode: unit2Barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(unit2Barcode),
      unit2Factor: unit2Factor == null && nullToAbsent
          ? const Value.absent()
          : Value(unit2Factor),
      unit2PriceRetail: unit2PriceRetail == null && nullToAbsent
          ? const Value.absent()
          : Value(unit2PriceRetail),
      unit2PriceWholesale: unit2PriceWholesale == null && nullToAbsent
          ? const Value.absent()
          : Value(unit2PriceWholesale),
      unit3Name: unit3Name == null && nullToAbsent
          ? const Value.absent()
          : Value(unit3Name),
      unit3Barcode: unit3Barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(unit3Barcode),
      unit3Factor: unit3Factor == null && nullToAbsent
          ? const Value.absent()
          : Value(unit3Factor),
      unit3PriceRetail: unit3PriceRetail == null && nullToAbsent
          ? const Value.absent()
          : Value(unit3PriceRetail),
      unit3PriceWholesale: unit3PriceWholesale == null && nullToAbsent
          ? const Value.absent()
          : Value(unit3PriceWholesale),
      defaultUnit: Value(defaultUnit),
      isActive: Value(isActive),
      displayOrder: Value(displayOrder),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      columnId: serializer.fromJson<int?>(json['columnId']),
      name: serializer.fromJson<String>(json['name']),
      currency: serializer.fromJson<String>(json['currency']),
      unit1Name: serializer.fromJson<String>(json['unit1Name']),
      unit1Barcode: serializer.fromJson<String?>(json['unit1Barcode']),
      unit1PriceRetail: serializer.fromJson<double>(json['unit1PriceRetail']),
      unit1PriceWholesale:
          serializer.fromJson<double>(json['unit1PriceWholesale']),
      unit2Name: serializer.fromJson<String?>(json['unit2Name']),
      unit2Barcode: serializer.fromJson<String?>(json['unit2Barcode']),
      unit2Factor: serializer.fromJson<double?>(json['unit2Factor']),
      unit2PriceRetail: serializer.fromJson<double?>(json['unit2PriceRetail']),
      unit2PriceWholesale:
          serializer.fromJson<double?>(json['unit2PriceWholesale']),
      unit3Name: serializer.fromJson<String?>(json['unit3Name']),
      unit3Barcode: serializer.fromJson<String?>(json['unit3Barcode']),
      unit3Factor: serializer.fromJson<double?>(json['unit3Factor']),
      unit3PriceRetail: serializer.fromJson<double?>(json['unit3PriceRetail']),
      unit3PriceWholesale:
          serializer.fromJson<double?>(json['unit3PriceWholesale']),
      defaultUnit: serializer.fromJson<int>(json['defaultUnit']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'categoryId': serializer.toJson<int>(categoryId),
      'columnId': serializer.toJson<int?>(columnId),
      'name': serializer.toJson<String>(name),
      'currency': serializer.toJson<String>(currency),
      'unit1Name': serializer.toJson<String>(unit1Name),
      'unit1Barcode': serializer.toJson<String?>(unit1Barcode),
      'unit1PriceRetail': serializer.toJson<double>(unit1PriceRetail),
      'unit1PriceWholesale': serializer.toJson<double>(unit1PriceWholesale),
      'unit2Name': serializer.toJson<String?>(unit2Name),
      'unit2Barcode': serializer.toJson<String?>(unit2Barcode),
      'unit2Factor': serializer.toJson<double?>(unit2Factor),
      'unit2PriceRetail': serializer.toJson<double?>(unit2PriceRetail),
      'unit2PriceWholesale': serializer.toJson<double?>(unit2PriceWholesale),
      'unit3Name': serializer.toJson<String?>(unit3Name),
      'unit3Barcode': serializer.toJson<String?>(unit3Barcode),
      'unit3Factor': serializer.toJson<double?>(unit3Factor),
      'unit3PriceRetail': serializer.toJson<double?>(unit3PriceRetail),
      'unit3PriceWholesale': serializer.toJson<double?>(unit3PriceWholesale),
      'defaultUnit': serializer.toJson<int>(defaultUnit),
      'isActive': serializer.toJson<bool>(isActive),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  Product copyWith(
          {int? id,
          String? code,
          int? categoryId,
          Value<int?> columnId = const Value.absent(),
          String? name,
          String? currency,
          String? unit1Name,
          Value<String?> unit1Barcode = const Value.absent(),
          double? unit1PriceRetail,
          double? unit1PriceWholesale,
          Value<String?> unit2Name = const Value.absent(),
          Value<String?> unit2Barcode = const Value.absent(),
          Value<double?> unit2Factor = const Value.absent(),
          Value<double?> unit2PriceRetail = const Value.absent(),
          Value<double?> unit2PriceWholesale = const Value.absent(),
          Value<String?> unit3Name = const Value.absent(),
          Value<String?> unit3Barcode = const Value.absent(),
          Value<double?> unit3Factor = const Value.absent(),
          Value<double?> unit3PriceRetail = const Value.absent(),
          Value<double?> unit3PriceWholesale = const Value.absent(),
          int? defaultUnit,
          bool? isActive,
          int? displayOrder}) =>
      Product(
        id: id ?? this.id,
        code: code ?? this.code,
        categoryId: categoryId ?? this.categoryId,
        columnId: columnId.present ? columnId.value : this.columnId,
        name: name ?? this.name,
        currency: currency ?? this.currency,
        unit1Name: unit1Name ?? this.unit1Name,
        unit1Barcode:
            unit1Barcode.present ? unit1Barcode.value : this.unit1Barcode,
        unit1PriceRetail: unit1PriceRetail ?? this.unit1PriceRetail,
        unit1PriceWholesale: unit1PriceWholesale ?? this.unit1PriceWholesale,
        unit2Name: unit2Name.present ? unit2Name.value : this.unit2Name,
        unit2Barcode:
            unit2Barcode.present ? unit2Barcode.value : this.unit2Barcode,
        unit2Factor: unit2Factor.present ? unit2Factor.value : this.unit2Factor,
        unit2PriceRetail: unit2PriceRetail.present
            ? unit2PriceRetail.value
            : this.unit2PriceRetail,
        unit2PriceWholesale: unit2PriceWholesale.present
            ? unit2PriceWholesale.value
            : this.unit2PriceWholesale,
        unit3Name: unit3Name.present ? unit3Name.value : this.unit3Name,
        unit3Barcode:
            unit3Barcode.present ? unit3Barcode.value : this.unit3Barcode,
        unit3Factor: unit3Factor.present ? unit3Factor.value : this.unit3Factor,
        unit3PriceRetail: unit3PriceRetail.present
            ? unit3PriceRetail.value
            : this.unit3PriceRetail,
        unit3PriceWholesale: unit3PriceWholesale.present
            ? unit3PriceWholesale.value
            : this.unit3PriceWholesale,
        defaultUnit: defaultUnit ?? this.defaultUnit,
        isActive: isActive ?? this.isActive,
        displayOrder: displayOrder ?? this.displayOrder,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      columnId: data.columnId.present ? data.columnId.value : this.columnId,
      name: data.name.present ? data.name.value : this.name,
      currency: data.currency.present ? data.currency.value : this.currency,
      unit1Name: data.unit1Name.present ? data.unit1Name.value : this.unit1Name,
      unit1Barcode: data.unit1Barcode.present
          ? data.unit1Barcode.value
          : this.unit1Barcode,
      unit1PriceRetail: data.unit1PriceRetail.present
          ? data.unit1PriceRetail.value
          : this.unit1PriceRetail,
      unit1PriceWholesale: data.unit1PriceWholesale.present
          ? data.unit1PriceWholesale.value
          : this.unit1PriceWholesale,
      unit2Name: data.unit2Name.present ? data.unit2Name.value : this.unit2Name,
      unit2Barcode: data.unit2Barcode.present
          ? data.unit2Barcode.value
          : this.unit2Barcode,
      unit2Factor:
          data.unit2Factor.present ? data.unit2Factor.value : this.unit2Factor,
      unit2PriceRetail: data.unit2PriceRetail.present
          ? data.unit2PriceRetail.value
          : this.unit2PriceRetail,
      unit2PriceWholesale: data.unit2PriceWholesale.present
          ? data.unit2PriceWholesale.value
          : this.unit2PriceWholesale,
      unit3Name: data.unit3Name.present ? data.unit3Name.value : this.unit3Name,
      unit3Barcode: data.unit3Barcode.present
          ? data.unit3Barcode.value
          : this.unit3Barcode,
      unit3Factor:
          data.unit3Factor.present ? data.unit3Factor.value : this.unit3Factor,
      unit3PriceRetail: data.unit3PriceRetail.present
          ? data.unit3PriceRetail.value
          : this.unit3PriceRetail,
      unit3PriceWholesale: data.unit3PriceWholesale.present
          ? data.unit3PriceWholesale.value
          : this.unit3PriceWholesale,
      defaultUnit:
          data.defaultUnit.present ? data.defaultUnit.value : this.defaultUnit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('categoryId: $categoryId, ')
          ..write('columnId: $columnId, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('unit1Name: $unit1Name, ')
          ..write('unit1Barcode: $unit1Barcode, ')
          ..write('unit1PriceRetail: $unit1PriceRetail, ')
          ..write('unit1PriceWholesale: $unit1PriceWholesale, ')
          ..write('unit2Name: $unit2Name, ')
          ..write('unit2Barcode: $unit2Barcode, ')
          ..write('unit2Factor: $unit2Factor, ')
          ..write('unit2PriceRetail: $unit2PriceRetail, ')
          ..write('unit2PriceWholesale: $unit2PriceWholesale, ')
          ..write('unit3Name: $unit3Name, ')
          ..write('unit3Barcode: $unit3Barcode, ')
          ..write('unit3Factor: $unit3Factor, ')
          ..write('unit3PriceRetail: $unit3PriceRetail, ')
          ..write('unit3PriceWholesale: $unit3PriceWholesale, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('isActive: $isActive, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        code,
        categoryId,
        columnId,
        name,
        currency,
        unit1Name,
        unit1Barcode,
        unit1PriceRetail,
        unit1PriceWholesale,
        unit2Name,
        unit2Barcode,
        unit2Factor,
        unit2PriceRetail,
        unit2PriceWholesale,
        unit3Name,
        unit3Barcode,
        unit3Factor,
        unit3PriceRetail,
        unit3PriceWholesale,
        defaultUnit,
        isActive,
        displayOrder
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.code == this.code &&
          other.categoryId == this.categoryId &&
          other.columnId == this.columnId &&
          other.name == this.name &&
          other.currency == this.currency &&
          other.unit1Name == this.unit1Name &&
          other.unit1Barcode == this.unit1Barcode &&
          other.unit1PriceRetail == this.unit1PriceRetail &&
          other.unit1PriceWholesale == this.unit1PriceWholesale &&
          other.unit2Name == this.unit2Name &&
          other.unit2Barcode == this.unit2Barcode &&
          other.unit2Factor == this.unit2Factor &&
          other.unit2PriceRetail == this.unit2PriceRetail &&
          other.unit2PriceWholesale == this.unit2PriceWholesale &&
          other.unit3Name == this.unit3Name &&
          other.unit3Barcode == this.unit3Barcode &&
          other.unit3Factor == this.unit3Factor &&
          other.unit3PriceRetail == this.unit3PriceRetail &&
          other.unit3PriceWholesale == this.unit3PriceWholesale &&
          other.defaultUnit == this.defaultUnit &&
          other.isActive == this.isActive &&
          other.displayOrder == this.displayOrder);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> code;
  final Value<int> categoryId;
  final Value<int?> columnId;
  final Value<String> name;
  final Value<String> currency;
  final Value<String> unit1Name;
  final Value<String?> unit1Barcode;
  final Value<double> unit1PriceRetail;
  final Value<double> unit1PriceWholesale;
  final Value<String?> unit2Name;
  final Value<String?> unit2Barcode;
  final Value<double?> unit2Factor;
  final Value<double?> unit2PriceRetail;
  final Value<double?> unit2PriceWholesale;
  final Value<String?> unit3Name;
  final Value<String?> unit3Barcode;
  final Value<double?> unit3Factor;
  final Value<double?> unit3PriceRetail;
  final Value<double?> unit3PriceWholesale;
  final Value<int> defaultUnit;
  final Value<bool> isActive;
  final Value<int> displayOrder;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.columnId = const Value.absent(),
    this.name = const Value.absent(),
    this.currency = const Value.absent(),
    this.unit1Name = const Value.absent(),
    this.unit1Barcode = const Value.absent(),
    this.unit1PriceRetail = const Value.absent(),
    this.unit1PriceWholesale = const Value.absent(),
    this.unit2Name = const Value.absent(),
    this.unit2Barcode = const Value.absent(),
    this.unit2Factor = const Value.absent(),
    this.unit2PriceRetail = const Value.absent(),
    this.unit2PriceWholesale = const Value.absent(),
    this.unit3Name = const Value.absent(),
    this.unit3Barcode = const Value.absent(),
    this.unit3Factor = const Value.absent(),
    this.unit3PriceRetail = const Value.absent(),
    this.unit3PriceWholesale = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required int categoryId,
    this.columnId = const Value.absent(),
    required String name,
    required String currency,
    required String unit1Name,
    this.unit1Barcode = const Value.absent(),
    this.unit1PriceRetail = const Value.absent(),
    this.unit1PriceWholesale = const Value.absent(),
    this.unit2Name = const Value.absent(),
    this.unit2Barcode = const Value.absent(),
    this.unit2Factor = const Value.absent(),
    this.unit2PriceRetail = const Value.absent(),
    this.unit2PriceWholesale = const Value.absent(),
    this.unit3Name = const Value.absent(),
    this.unit3Barcode = const Value.absent(),
    this.unit3Factor = const Value.absent(),
    this.unit3PriceRetail = const Value.absent(),
    this.unit3PriceWholesale = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.displayOrder = const Value.absent(),
  })  : code = Value(code),
        categoryId = Value(categoryId),
        name = Value(name),
        currency = Value(currency),
        unit1Name = Value(unit1Name);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<int>? categoryId,
    Expression<int>? columnId,
    Expression<String>? name,
    Expression<String>? currency,
    Expression<String>? unit1Name,
    Expression<String>? unit1Barcode,
    Expression<double>? unit1PriceRetail,
    Expression<double>? unit1PriceWholesale,
    Expression<String>? unit2Name,
    Expression<String>? unit2Barcode,
    Expression<double>? unit2Factor,
    Expression<double>? unit2PriceRetail,
    Expression<double>? unit2PriceWholesale,
    Expression<String>? unit3Name,
    Expression<String>? unit3Barcode,
    Expression<double>? unit3Factor,
    Expression<double>? unit3PriceRetail,
    Expression<double>? unit3PriceWholesale,
    Expression<int>? defaultUnit,
    Expression<bool>? isActive,
    Expression<int>? displayOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (categoryId != null) 'category_id': categoryId,
      if (columnId != null) 'column_id': columnId,
      if (name != null) 'name': name,
      if (currency != null) 'currency': currency,
      if (unit1Name != null) 'unit1_name': unit1Name,
      if (unit1Barcode != null) 'unit1_barcode': unit1Barcode,
      if (unit1PriceRetail != null) 'unit1_price_retail': unit1PriceRetail,
      if (unit1PriceWholesale != null)
        'unit1_price_wholesale': unit1PriceWholesale,
      if (unit2Name != null) 'unit2_name': unit2Name,
      if (unit2Barcode != null) 'unit2_barcode': unit2Barcode,
      if (unit2Factor != null) 'unit2_factor': unit2Factor,
      if (unit2PriceRetail != null) 'unit2_price_retail': unit2PriceRetail,
      if (unit2PriceWholesale != null)
        'unit2_price_wholesale': unit2PriceWholesale,
      if (unit3Name != null) 'unit3_name': unit3Name,
      if (unit3Barcode != null) 'unit3_barcode': unit3Barcode,
      if (unit3Factor != null) 'unit3_factor': unit3Factor,
      if (unit3PriceRetail != null) 'unit3_price_retail': unit3PriceRetail,
      if (unit3PriceWholesale != null)
        'unit3_price_wholesale': unit3PriceWholesale,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (isActive != null) 'is_active': isActive,
      if (displayOrder != null) 'display_order': displayOrder,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<int>? categoryId,
      Value<int?>? columnId,
      Value<String>? name,
      Value<String>? currency,
      Value<String>? unit1Name,
      Value<String?>? unit1Barcode,
      Value<double>? unit1PriceRetail,
      Value<double>? unit1PriceWholesale,
      Value<String?>? unit2Name,
      Value<String?>? unit2Barcode,
      Value<double?>? unit2Factor,
      Value<double?>? unit2PriceRetail,
      Value<double?>? unit2PriceWholesale,
      Value<String?>? unit3Name,
      Value<String?>? unit3Barcode,
      Value<double?>? unit3Factor,
      Value<double?>? unit3PriceRetail,
      Value<double?>? unit3PriceWholesale,
      Value<int>? defaultUnit,
      Value<bool>? isActive,
      Value<int>? displayOrder}) {
    return ProductsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      categoryId: categoryId ?? this.categoryId,
      columnId: columnId ?? this.columnId,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      unit1Name: unit1Name ?? this.unit1Name,
      unit1Barcode: unit1Barcode ?? this.unit1Barcode,
      unit1PriceRetail: unit1PriceRetail ?? this.unit1PriceRetail,
      unit1PriceWholesale: unit1PriceWholesale ?? this.unit1PriceWholesale,
      unit2Name: unit2Name ?? this.unit2Name,
      unit2Barcode: unit2Barcode ?? this.unit2Barcode,
      unit2Factor: unit2Factor ?? this.unit2Factor,
      unit2PriceRetail: unit2PriceRetail ?? this.unit2PriceRetail,
      unit2PriceWholesale: unit2PriceWholesale ?? this.unit2PriceWholesale,
      unit3Name: unit3Name ?? this.unit3Name,
      unit3Barcode: unit3Barcode ?? this.unit3Barcode,
      unit3Factor: unit3Factor ?? this.unit3Factor,
      unit3PriceRetail: unit3PriceRetail ?? this.unit3PriceRetail,
      unit3PriceWholesale: unit3PriceWholesale ?? this.unit3PriceWholesale,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (columnId.present) {
      map['column_id'] = Variable<int>(columnId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (unit1Name.present) {
      map['unit1_name'] = Variable<String>(unit1Name.value);
    }
    if (unit1Barcode.present) {
      map['unit1_barcode'] = Variable<String>(unit1Barcode.value);
    }
    if (unit1PriceRetail.present) {
      map['unit1_price_retail'] = Variable<double>(unit1PriceRetail.value);
    }
    if (unit1PriceWholesale.present) {
      map['unit1_price_wholesale'] =
          Variable<double>(unit1PriceWholesale.value);
    }
    if (unit2Name.present) {
      map['unit2_name'] = Variable<String>(unit2Name.value);
    }
    if (unit2Barcode.present) {
      map['unit2_barcode'] = Variable<String>(unit2Barcode.value);
    }
    if (unit2Factor.present) {
      map['unit2_factor'] = Variable<double>(unit2Factor.value);
    }
    if (unit2PriceRetail.present) {
      map['unit2_price_retail'] = Variable<double>(unit2PriceRetail.value);
    }
    if (unit2PriceWholesale.present) {
      map['unit2_price_wholesale'] =
          Variable<double>(unit2PriceWholesale.value);
    }
    if (unit3Name.present) {
      map['unit3_name'] = Variable<String>(unit3Name.value);
    }
    if (unit3Barcode.present) {
      map['unit3_barcode'] = Variable<String>(unit3Barcode.value);
    }
    if (unit3Factor.present) {
      map['unit3_factor'] = Variable<double>(unit3Factor.value);
    }
    if (unit3PriceRetail.present) {
      map['unit3_price_retail'] = Variable<double>(unit3PriceRetail.value);
    }
    if (unit3PriceWholesale.present) {
      map['unit3_price_wholesale'] =
          Variable<double>(unit3PriceWholesale.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<int>(defaultUnit.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('categoryId: $categoryId, ')
          ..write('columnId: $columnId, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('unit1Name: $unit1Name, ')
          ..write('unit1Barcode: $unit1Barcode, ')
          ..write('unit1PriceRetail: $unit1PriceRetail, ')
          ..write('unit1PriceWholesale: $unit1PriceWholesale, ')
          ..write('unit2Name: $unit2Name, ')
          ..write('unit2Barcode: $unit2Barcode, ')
          ..write('unit2Factor: $unit2Factor, ')
          ..write('unit2PriceRetail: $unit2PriceRetail, ')
          ..write('unit2PriceWholesale: $unit2PriceWholesale, ')
          ..write('unit3Name: $unit3Name, ')
          ..write('unit3Barcode: $unit3Barcode, ')
          ..write('unit3Factor: $unit3Factor, ')
          ..write('unit3PriceRetail: $unit3PriceRetail, ')
          ..write('unit3PriceWholesale: $unit3PriceWholesale, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('isActive: $isActive, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountTypeMeta =
      const VerificationMeta('accountType');
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
      'account_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('GENERAL'));
  static const VerificationMeta _isSystemMeta =
      const VerificationMeta('isSystem');
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
      'is_system', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_system" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, code, name, currency, accountType, isSystem, isActive, displayOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
          _accountTypeMeta,
          accountType.isAcceptableOrUnknown(
              data['account_type']!, _accountTypeMeta));
    }
    if (data.containsKey('is_system')) {
      context.handle(_isSystemMeta,
          isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      accountType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_type'])!,
      isSystem: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_system'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String code;
  final String name;
  final String currency;
  final String accountType;
  final bool isSystem;
  final bool isActive;
  final int displayOrder;
  const Account(
      {required this.id,
      required this.code,
      required this.name,
      required this.currency,
      required this.accountType,
      required this.isSystem,
      required this.isActive,
      required this.displayOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['currency'] = Variable<String>(currency);
    map['account_type'] = Variable<String>(accountType);
    map['is_system'] = Variable<bool>(isSystem);
    map['is_active'] = Variable<bool>(isActive);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      currency: Value(currency),
      accountType: Value(accountType),
      isSystem: Value(isSystem),
      isActive: Value(isActive),
      displayOrder: Value(displayOrder),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      currency: serializer.fromJson<String>(json['currency']),
      accountType: serializer.fromJson<String>(json['accountType']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'currency': serializer.toJson<String>(currency),
      'accountType': serializer.toJson<String>(accountType),
      'isSystem': serializer.toJson<bool>(isSystem),
      'isActive': serializer.toJson<bool>(isActive),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  Account copyWith(
          {int? id,
          String? code,
          String? name,
          String? currency,
          String? accountType,
          bool? isSystem,
          bool? isActive,
          int? displayOrder}) =>
      Account(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        currency: currency ?? this.currency,
        accountType: accountType ?? this.accountType,
        isSystem: isSystem ?? this.isSystem,
        isActive: isActive ?? this.isActive,
        displayOrder: displayOrder ?? this.displayOrder,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      currency: data.currency.present ? data.currency.value : this.currency,
      accountType:
          data.accountType.present ? data.accountType.value : this.accountType,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('accountType: $accountType, ')
          ..write('isSystem: $isSystem, ')
          ..write('isActive: $isActive, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, code, name, currency, accountType, isSystem, isActive, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.currency == this.currency &&
          other.accountType == this.accountType &&
          other.isSystem == this.isSystem &&
          other.isActive == this.isActive &&
          other.displayOrder == this.displayOrder);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> currency;
  final Value<String> accountType;
  final Value<bool> isSystem;
  final Value<bool> isActive;
  final Value<int> displayOrder;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.currency = const Value.absent(),
    this.accountType = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isActive = const Value.absent(),
    this.displayOrder = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    required String currency,
    this.accountType = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isActive = const Value.absent(),
    this.displayOrder = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        currency = Value(currency);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? currency,
    Expression<String>? accountType,
    Expression<bool>? isSystem,
    Expression<bool>? isActive,
    Expression<int>? displayOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (currency != null) 'currency': currency,
      if (accountType != null) 'account_type': accountType,
      if (isSystem != null) 'is_system': isSystem,
      if (isActive != null) 'is_active': isActive,
      if (displayOrder != null) 'display_order': displayOrder,
    });
  }

  AccountsCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? name,
      Value<String>? currency,
      Value<String>? accountType,
      Value<bool>? isSystem,
      Value<bool>? isActive,
      Value<int>? displayOrder}) {
    return AccountsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      accountType: accountType ?? this.accountType,
      isSystem: isSystem ?? this.isSystem,
      isActive: isActive ?? this.isActive,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('accountType: $accountType, ')
          ..write('isSystem: $isSystem, ')
          ..write('isActive: $isActive, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<int> invoiceNumber = GeneratedColumn<int>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _accountCodeMeta =
      const VerificationMeta('accountCode');
  @override
  late final GeneratedColumn<String> accountCode = GeneratedColumn<String>(
      'account_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _warehouseNameMeta =
      const VerificationMeta('warehouseName');
  @override
  late final GeneratedColumn<String> warehouseName = GeneratedColumn<String>(
      'warehouse_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceNumber,
        type,
        status,
        date,
        customerId,
        accountCode,
        paymentMethod,
        currency,
        exchangeRate,
        warehouseName,
        subtotal,
        discountAmount,
        total,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(Insertable<Invoice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('account_code')) {
      context.handle(
          _accountCodeMeta,
          accountCode.isAcceptableOrUnknown(
              data['account_code']!, _accountCodeMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate']!, _exchangeRateMeta));
    }
    if (data.containsKey('warehouse_name')) {
      context.handle(
          _warehouseNameMeta,
          warehouseName.isAcceptableOrUnknown(
              data['warehouse_name']!, _warehouseNameMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_number'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}customer_id']),
      accountCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_code']),
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      exchangeRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exchange_rate']),
      warehouseName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}warehouse_name']),
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final int id;
  final int invoiceNumber;
  final String type;
  final String status;
  final String date;
  final int? customerId;
  final String? accountCode;
  final String paymentMethod;
  final String currency;
  final double? exchangeRate;
  final String? warehouseName;
  final double subtotal;
  final double discountAmount;
  final double total;
  final String? note;
  const Invoice(
      {required this.id,
      required this.invoiceNumber,
      required this.type,
      required this.status,
      required this.date,
      this.customerId,
      this.accountCode,
      required this.paymentMethod,
      required this.currency,
      this.exchangeRate,
      this.warehouseName,
      required this.subtotal,
      required this.discountAmount,
      required this.total,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_number'] = Variable<int>(invoiceNumber);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    if (!nullToAbsent || accountCode != null) {
      map['account_code'] = Variable<String>(accountCode);
    }
    map['payment_method'] = Variable<String>(paymentMethod);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || exchangeRate != null) {
      map['exchange_rate'] = Variable<double>(exchangeRate);
    }
    if (!nullToAbsent || warehouseName != null) {
      map['warehouse_name'] = Variable<String>(warehouseName);
    }
    map['subtotal'] = Variable<double>(subtotal);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['total'] = Variable<double>(total);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      type: Value(type),
      status: Value(status),
      date: Value(date),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      accountCode: accountCode == null && nullToAbsent
          ? const Value.absent()
          : Value(accountCode),
      paymentMethod: Value(paymentMethod),
      currency: Value(currency),
      exchangeRate: exchangeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRate),
      warehouseName: warehouseName == null && nullToAbsent
          ? const Value.absent()
          : Value(warehouseName),
      subtotal: Value(subtotal),
      discountAmount: Value(discountAmount),
      total: Value(total),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Invoice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<int>(json['id']),
      invoiceNumber: serializer.fromJson<int>(json['invoiceNumber']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      date: serializer.fromJson<String>(json['date']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      accountCode: serializer.fromJson<String?>(json['accountCode']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      currency: serializer.fromJson<String>(json['currency']),
      exchangeRate: serializer.fromJson<double?>(json['exchangeRate']),
      warehouseName: serializer.fromJson<String?>(json['warehouseName']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      total: serializer.fromJson<double>(json['total']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceNumber': serializer.toJson<int>(invoiceNumber),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'date': serializer.toJson<String>(date),
      'customerId': serializer.toJson<int?>(customerId),
      'accountCode': serializer.toJson<String?>(accountCode),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'currency': serializer.toJson<String>(currency),
      'exchangeRate': serializer.toJson<double?>(exchangeRate),
      'warehouseName': serializer.toJson<String?>(warehouseName),
      'subtotal': serializer.toJson<double>(subtotal),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'total': serializer.toJson<double>(total),
      'note': serializer.toJson<String?>(note),
    };
  }

  Invoice copyWith(
          {int? id,
          int? invoiceNumber,
          String? type,
          String? status,
          String? date,
          Value<int?> customerId = const Value.absent(),
          Value<String?> accountCode = const Value.absent(),
          String? paymentMethod,
          String? currency,
          Value<double?> exchangeRate = const Value.absent(),
          Value<String?> warehouseName = const Value.absent(),
          double? subtotal,
          double? discountAmount,
          double? total,
          Value<String?> note = const Value.absent()}) =>
      Invoice(
        id: id ?? this.id,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        type: type ?? this.type,
        status: status ?? this.status,
        date: date ?? this.date,
        customerId: customerId.present ? customerId.value : this.customerId,
        accountCode: accountCode.present ? accountCode.value : this.accountCode,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        currency: currency ?? this.currency,
        exchangeRate:
            exchangeRate.present ? exchangeRate.value : this.exchangeRate,
        warehouseName:
            warehouseName.present ? warehouseName.value : this.warehouseName,
        subtotal: subtotal ?? this.subtotal,
        discountAmount: discountAmount ?? this.discountAmount,
        total: total ?? this.total,
        note: note.present ? note.value : this.note,
      );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      date: data.date.present ? data.date.value : this.date,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      accountCode:
          data.accountCode.present ? data.accountCode.value : this.accountCode,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      currency: data.currency.present ? data.currency.value : this.currency,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      warehouseName: data.warehouseName.present
          ? data.warehouseName.value
          : this.warehouseName,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      total: data.total.present ? data.total.value : this.total,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('customerId: $customerId, ')
          ..write('accountCode: $accountCode, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('warehouseName: $warehouseName, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('total: $total, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      invoiceNumber,
      type,
      status,
      date,
      customerId,
      accountCode,
      paymentMethod,
      currency,
      exchangeRate,
      warehouseName,
      subtotal,
      discountAmount,
      total,
      note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.type == this.type &&
          other.status == this.status &&
          other.date == this.date &&
          other.customerId == this.customerId &&
          other.accountCode == this.accountCode &&
          other.paymentMethod == this.paymentMethod &&
          other.currency == this.currency &&
          other.exchangeRate == this.exchangeRate &&
          other.warehouseName == this.warehouseName &&
          other.subtotal == this.subtotal &&
          other.discountAmount == this.discountAmount &&
          other.total == this.total &&
          other.note == this.note);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<int> id;
  final Value<int> invoiceNumber;
  final Value<String> type;
  final Value<String> status;
  final Value<String> date;
  final Value<int?> customerId;
  final Value<String?> accountCode;
  final Value<String> paymentMethod;
  final Value<String> currency;
  final Value<double?> exchangeRate;
  final Value<String?> warehouseName;
  final Value<double> subtotal;
  final Value<double> discountAmount;
  final Value<double> total;
  final Value<String?> note;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.date = const Value.absent(),
    this.customerId = const Value.absent(),
    this.accountCode = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.currency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.warehouseName = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.total = const Value.absent(),
    this.note = const Value.absent(),
  });
  InvoicesCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceNumber,
    required String type,
    required String status,
    required String date,
    this.customerId = const Value.absent(),
    this.accountCode = const Value.absent(),
    required String paymentMethod,
    required String currency,
    this.exchangeRate = const Value.absent(),
    this.warehouseName = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.total = const Value.absent(),
    this.note = const Value.absent(),
  })  : invoiceNumber = Value(invoiceNumber),
        type = Value(type),
        status = Value(status),
        date = Value(date),
        paymentMethod = Value(paymentMethod),
        currency = Value(currency);
  static Insertable<Invoice> custom({
    Expression<int>? id,
    Expression<int>? invoiceNumber,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? date,
    Expression<int>? customerId,
    Expression<String>? accountCode,
    Expression<String>? paymentMethod,
    Expression<String>? currency,
    Expression<double>? exchangeRate,
    Expression<String>? warehouseName,
    Expression<double>? subtotal,
    Expression<double>? discountAmount,
    Expression<double>? total,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
      if (customerId != null) 'customer_id': customerId,
      if (accountCode != null) 'account_code': accountCode,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (currency != null) 'currency': currency,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (warehouseName != null) 'warehouse_name': warehouseName,
      if (subtotal != null) 'subtotal': subtotal,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (total != null) 'total': total,
      if (note != null) 'note': note,
    });
  }

  InvoicesCompanion copyWith(
      {Value<int>? id,
      Value<int>? invoiceNumber,
      Value<String>? type,
      Value<String>? status,
      Value<String>? date,
      Value<int?>? customerId,
      Value<String?>? accountCode,
      Value<String>? paymentMethod,
      Value<String>? currency,
      Value<double?>? exchangeRate,
      Value<String?>? warehouseName,
      Value<double>? subtotal,
      Value<double>? discountAmount,
      Value<double>? total,
      Value<String?>? note}) {
    return InvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      customerId: customerId ?? this.customerId,
      accountCode: accountCode ?? this.accountCode,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      warehouseName: warehouseName ?? this.warehouseName,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      total: total ?? this.total,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<int>(invoiceNumber.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (accountCode.present) {
      map['account_code'] = Variable<String>(accountCode.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (warehouseName.present) {
      map['warehouse_name'] = Variable<String>(warehouseName.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('customerId: $customerId, ')
          ..write('accountCode: $accountCode, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('warehouseName: $warehouseName, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('total: $total, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $InvoiceLinesTable extends InvoiceLines
    with TableInfo<$InvoiceLinesTable, InvoiceLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _invoiceIdMeta =
      const VerificationMeta('invoiceId');
  @override
  late final GeneratedColumn<int> invoiceId = GeneratedColumn<int>(
      'invoice_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES invoices (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _productCodeMeta =
      const VerificationMeta('productCode');
  @override
  late final GeneratedColumn<String> productCode = GeneratedColumn<String>(
      'product_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _realProductIdMeta =
      const VerificationMeta('realProductId');
  @override
  late final GeneratedColumn<int> realProductId = GeneratedColumn<int>(
      'real_product_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _realProductCodeMeta =
      const VerificationMeta('realProductCode');
  @override
  late final GeneratedColumn<String> realProductCode = GeneratedColumn<String>(
      'real_product_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _realProductNameMeta =
      const VerificationMeta('realProductName');
  @override
  late final GeneratedColumn<String> realProductName = GeneratedColumn<String>(
      'real_product_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitNumberMeta =
      const VerificationMeta('unitNumber');
  @override
  late final GeneratedColumn<int> unitNumber = GeneratedColumn<int>(
      'unit_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitNameMeta =
      const VerificationMeta('unitName');
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
      'unit_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceRetailSnapshotMeta =
      const VerificationMeta('priceRetailSnapshot');
  @override
  late final GeneratedColumn<double> priceRetailSnapshot =
      GeneratedColumn<double>('price_retail_snapshot', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _priceWholesaleSnapshotMeta =
      const VerificationMeta('priceWholesaleSnapshot');
  @override
  late final GeneratedColumn<double> priceWholesaleSnapshot =
      GeneratedColumn<double>('price_wholesale_snapshot', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isGiftMeta = const VerificationMeta('isGift');
  @override
  late final GeneratedColumn<bool> isGift = GeneratedColumn<bool>(
      'is_gift', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_gift" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lineNoteMeta =
      const VerificationMeta('lineNote');
  @override
  late final GeneratedColumn<String> lineNote = GeneratedColumn<String>(
      'line_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lineOrderMeta =
      const VerificationMeta('lineOrder');
  @override
  late final GeneratedColumn<int> lineOrder = GeneratedColumn<int>(
      'line_order', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceId,
        productId,
        productCode,
        productName,
        realProductId,
        realProductCode,
        realProductName,
        unitNumber,
        unitName,
        quantity,
        price,
        priceRetailSnapshot,
        priceWholesaleSnapshot,
        isGift,
        lineNote,
        lineOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_lines';
  @override
  VerificationContext validateIntegrity(Insertable<InvoiceLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_id')) {
      context.handle(_invoiceIdMeta,
          invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta));
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_code')) {
      context.handle(
          _productCodeMeta,
          productCode.isAcceptableOrUnknown(
              data['product_code']!, _productCodeMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    }
    if (data.containsKey('real_product_id')) {
      context.handle(
          _realProductIdMeta,
          realProductId.isAcceptableOrUnknown(
              data['real_product_id']!, _realProductIdMeta));
    }
    if (data.containsKey('real_product_code')) {
      context.handle(
          _realProductCodeMeta,
          realProductCode.isAcceptableOrUnknown(
              data['real_product_code']!, _realProductCodeMeta));
    }
    if (data.containsKey('real_product_name')) {
      context.handle(
          _realProductNameMeta,
          realProductName.isAcceptableOrUnknown(
              data['real_product_name']!, _realProductNameMeta));
    }
    if (data.containsKey('unit_number')) {
      context.handle(
          _unitNumberMeta,
          unitNumber.isAcceptableOrUnknown(
              data['unit_number']!, _unitNumberMeta));
    } else if (isInserting) {
      context.missing(_unitNumberMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(_unitNameMeta,
          unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('price_retail_snapshot')) {
      context.handle(
          _priceRetailSnapshotMeta,
          priceRetailSnapshot.isAcceptableOrUnknown(
              data['price_retail_snapshot']!, _priceRetailSnapshotMeta));
    }
    if (data.containsKey('price_wholesale_snapshot')) {
      context.handle(
          _priceWholesaleSnapshotMeta,
          priceWholesaleSnapshot.isAcceptableOrUnknown(
              data['price_wholesale_snapshot']!, _priceWholesaleSnapshotMeta));
    }
    if (data.containsKey('is_gift')) {
      context.handle(_isGiftMeta,
          isGift.isAcceptableOrUnknown(data['is_gift']!, _isGiftMeta));
    }
    if (data.containsKey('line_note')) {
      context.handle(_lineNoteMeta,
          lineNote.isAcceptableOrUnknown(data['line_note']!, _lineNoteMeta));
    }
    if (data.containsKey('line_order')) {
      context.handle(_lineOrderMeta,
          lineOrder.isAcceptableOrUnknown(data['line_order']!, _lineOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InvoiceLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      invoiceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}invoice_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      productCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_code']),
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name']),
      realProductId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}real_product_id']),
      realProductCode: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}real_product_code']),
      realProductName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}real_product_name']),
      unitNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_number'])!,
      unitName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_name']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      priceRetailSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}price_retail_snapshot']),
      priceWholesaleSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}price_wholesale_snapshot']),
      isGift: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_gift'])!,
      lineNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}line_note']),
      lineOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_order']),
    );
  }

  @override
  $InvoiceLinesTable createAlias(String alias) {
    return $InvoiceLinesTable(attachedDatabase, alias);
  }
}

class InvoiceLine extends DataClass implements Insertable<InvoiceLine> {
  final int id;
  final int invoiceId;
  final int productId;
  final String? productCode;
  final String? productName;
  final int? realProductId;
  final String? realProductCode;
  final String? realProductName;
  final int unitNumber;
  final String? unitName;
  final double quantity;
  final double price;
  final double? priceRetailSnapshot;
  final double? priceWholesaleSnapshot;
  final bool isGift;
  final String? lineNote;
  final int? lineOrder;
  const InvoiceLine(
      {required this.id,
      required this.invoiceId,
      required this.productId,
      this.productCode,
      this.productName,
      this.realProductId,
      this.realProductCode,
      this.realProductName,
      required this.unitNumber,
      this.unitName,
      required this.quantity,
      required this.price,
      this.priceRetailSnapshot,
      this.priceWholesaleSnapshot,
      required this.isGift,
      this.lineNote,
      this.lineOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_id'] = Variable<int>(invoiceId);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || productCode != null) {
      map['product_code'] = Variable<String>(productCode);
    }
    if (!nullToAbsent || productName != null) {
      map['product_name'] = Variable<String>(productName);
    }
    if (!nullToAbsent || realProductId != null) {
      map['real_product_id'] = Variable<int>(realProductId);
    }
    if (!nullToAbsent || realProductCode != null) {
      map['real_product_code'] = Variable<String>(realProductCode);
    }
    if (!nullToAbsent || realProductName != null) {
      map['real_product_name'] = Variable<String>(realProductName);
    }
    map['unit_number'] = Variable<int>(unitNumber);
    if (!nullToAbsent || unitName != null) {
      map['unit_name'] = Variable<String>(unitName);
    }
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || priceRetailSnapshot != null) {
      map['price_retail_snapshot'] = Variable<double>(priceRetailSnapshot);
    }
    if (!nullToAbsent || priceWholesaleSnapshot != null) {
      map['price_wholesale_snapshot'] =
          Variable<double>(priceWholesaleSnapshot);
    }
    map['is_gift'] = Variable<bool>(isGift);
    if (!nullToAbsent || lineNote != null) {
      map['line_note'] = Variable<String>(lineNote);
    }
    if (!nullToAbsent || lineOrder != null) {
      map['line_order'] = Variable<int>(lineOrder);
    }
    return map;
  }

  InvoiceLinesCompanion toCompanion(bool nullToAbsent) {
    return InvoiceLinesCompanion(
      id: Value(id),
      invoiceId: Value(invoiceId),
      productId: Value(productId),
      productCode: productCode == null && nullToAbsent
          ? const Value.absent()
          : Value(productCode),
      productName: productName == null && nullToAbsent
          ? const Value.absent()
          : Value(productName),
      realProductId: realProductId == null && nullToAbsent
          ? const Value.absent()
          : Value(realProductId),
      realProductCode: realProductCode == null && nullToAbsent
          ? const Value.absent()
          : Value(realProductCode),
      realProductName: realProductName == null && nullToAbsent
          ? const Value.absent()
          : Value(realProductName),
      unitNumber: Value(unitNumber),
      unitName: unitName == null && nullToAbsent
          ? const Value.absent()
          : Value(unitName),
      quantity: Value(quantity),
      price: Value(price),
      priceRetailSnapshot: priceRetailSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(priceRetailSnapshot),
      priceWholesaleSnapshot: priceWholesaleSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(priceWholesaleSnapshot),
      isGift: Value(isGift),
      lineNote: lineNote == null && nullToAbsent
          ? const Value.absent()
          : Value(lineNote),
      lineOrder: lineOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(lineOrder),
    );
  }

  factory InvoiceLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceLine(
      id: serializer.fromJson<int>(json['id']),
      invoiceId: serializer.fromJson<int>(json['invoiceId']),
      productId: serializer.fromJson<int>(json['productId']),
      productCode: serializer.fromJson<String?>(json['productCode']),
      productName: serializer.fromJson<String?>(json['productName']),
      realProductId: serializer.fromJson<int?>(json['realProductId']),
      realProductCode: serializer.fromJson<String?>(json['realProductCode']),
      realProductName: serializer.fromJson<String?>(json['realProductName']),
      unitNumber: serializer.fromJson<int>(json['unitNumber']),
      unitName: serializer.fromJson<String?>(json['unitName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      priceRetailSnapshot:
          serializer.fromJson<double?>(json['priceRetailSnapshot']),
      priceWholesaleSnapshot:
          serializer.fromJson<double?>(json['priceWholesaleSnapshot']),
      isGift: serializer.fromJson<bool>(json['isGift']),
      lineNote: serializer.fromJson<String?>(json['lineNote']),
      lineOrder: serializer.fromJson<int?>(json['lineOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceId': serializer.toJson<int>(invoiceId),
      'productId': serializer.toJson<int>(productId),
      'productCode': serializer.toJson<String?>(productCode),
      'productName': serializer.toJson<String?>(productName),
      'realProductId': serializer.toJson<int?>(realProductId),
      'realProductCode': serializer.toJson<String?>(realProductCode),
      'realProductName': serializer.toJson<String?>(realProductName),
      'unitNumber': serializer.toJson<int>(unitNumber),
      'unitName': serializer.toJson<String?>(unitName),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'priceRetailSnapshot': serializer.toJson<double?>(priceRetailSnapshot),
      'priceWholesaleSnapshot':
          serializer.toJson<double?>(priceWholesaleSnapshot),
      'isGift': serializer.toJson<bool>(isGift),
      'lineNote': serializer.toJson<String?>(lineNote),
      'lineOrder': serializer.toJson<int?>(lineOrder),
    };
  }

  InvoiceLine copyWith(
          {int? id,
          int? invoiceId,
          int? productId,
          Value<String?> productCode = const Value.absent(),
          Value<String?> productName = const Value.absent(),
          Value<int?> realProductId = const Value.absent(),
          Value<String?> realProductCode = const Value.absent(),
          Value<String?> realProductName = const Value.absent(),
          int? unitNumber,
          Value<String?> unitName = const Value.absent(),
          double? quantity,
          double? price,
          Value<double?> priceRetailSnapshot = const Value.absent(),
          Value<double?> priceWholesaleSnapshot = const Value.absent(),
          bool? isGift,
          Value<String?> lineNote = const Value.absent(),
          Value<int?> lineOrder = const Value.absent()}) =>
      InvoiceLine(
        id: id ?? this.id,
        invoiceId: invoiceId ?? this.invoiceId,
        productId: productId ?? this.productId,
        productCode: productCode.present ? productCode.value : this.productCode,
        productName: productName.present ? productName.value : this.productName,
        realProductId:
            realProductId.present ? realProductId.value : this.realProductId,
        realProductCode: realProductCode.present
            ? realProductCode.value
            : this.realProductCode,
        realProductName: realProductName.present
            ? realProductName.value
            : this.realProductName,
        unitNumber: unitNumber ?? this.unitNumber,
        unitName: unitName.present ? unitName.value : this.unitName,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        priceRetailSnapshot: priceRetailSnapshot.present
            ? priceRetailSnapshot.value
            : this.priceRetailSnapshot,
        priceWholesaleSnapshot: priceWholesaleSnapshot.present
            ? priceWholesaleSnapshot.value
            : this.priceWholesaleSnapshot,
        isGift: isGift ?? this.isGift,
        lineNote: lineNote.present ? lineNote.value : this.lineNote,
        lineOrder: lineOrder.present ? lineOrder.value : this.lineOrder,
      );
  InvoiceLine copyWithCompanion(InvoiceLinesCompanion data) {
    return InvoiceLine(
      id: data.id.present ? data.id.value : this.id,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productCode:
          data.productCode.present ? data.productCode.value : this.productCode,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      realProductId: data.realProductId.present
          ? data.realProductId.value
          : this.realProductId,
      realProductCode: data.realProductCode.present
          ? data.realProductCode.value
          : this.realProductCode,
      realProductName: data.realProductName.present
          ? data.realProductName.value
          : this.realProductName,
      unitNumber:
          data.unitNumber.present ? data.unitNumber.value : this.unitNumber,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      priceRetailSnapshot: data.priceRetailSnapshot.present
          ? data.priceRetailSnapshot.value
          : this.priceRetailSnapshot,
      priceWholesaleSnapshot: data.priceWholesaleSnapshot.present
          ? data.priceWholesaleSnapshot.value
          : this.priceWholesaleSnapshot,
      isGift: data.isGift.present ? data.isGift.value : this.isGift,
      lineNote: data.lineNote.present ? data.lineNote.value : this.lineNote,
      lineOrder: data.lineOrder.present ? data.lineOrder.value : this.lineOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceLine(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('productId: $productId, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('realProductId: $realProductId, ')
          ..write('realProductCode: $realProductCode, ')
          ..write('realProductName: $realProductName, ')
          ..write('unitNumber: $unitNumber, ')
          ..write('unitName: $unitName, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('priceRetailSnapshot: $priceRetailSnapshot, ')
          ..write('priceWholesaleSnapshot: $priceWholesaleSnapshot, ')
          ..write('isGift: $isGift, ')
          ..write('lineNote: $lineNote, ')
          ..write('lineOrder: $lineOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      invoiceId,
      productId,
      productCode,
      productName,
      realProductId,
      realProductCode,
      realProductName,
      unitNumber,
      unitName,
      quantity,
      price,
      priceRetailSnapshot,
      priceWholesaleSnapshot,
      isGift,
      lineNote,
      lineOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceLine &&
          other.id == this.id &&
          other.invoiceId == this.invoiceId &&
          other.productId == this.productId &&
          other.productCode == this.productCode &&
          other.productName == this.productName &&
          other.realProductId == this.realProductId &&
          other.realProductCode == this.realProductCode &&
          other.realProductName == this.realProductName &&
          other.unitNumber == this.unitNumber &&
          other.unitName == this.unitName &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.priceRetailSnapshot == this.priceRetailSnapshot &&
          other.priceWholesaleSnapshot == this.priceWholesaleSnapshot &&
          other.isGift == this.isGift &&
          other.lineNote == this.lineNote &&
          other.lineOrder == this.lineOrder);
}

class InvoiceLinesCompanion extends UpdateCompanion<InvoiceLine> {
  final Value<int> id;
  final Value<int> invoiceId;
  final Value<int> productId;
  final Value<String?> productCode;
  final Value<String?> productName;
  final Value<int?> realProductId;
  final Value<String?> realProductCode;
  final Value<String?> realProductName;
  final Value<int> unitNumber;
  final Value<String?> unitName;
  final Value<double> quantity;
  final Value<double> price;
  final Value<double?> priceRetailSnapshot;
  final Value<double?> priceWholesaleSnapshot;
  final Value<bool> isGift;
  final Value<String?> lineNote;
  final Value<int?> lineOrder;
  const InvoiceLinesCompanion({
    this.id = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.realProductId = const Value.absent(),
    this.realProductCode = const Value.absent(),
    this.realProductName = const Value.absent(),
    this.unitNumber = const Value.absent(),
    this.unitName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.priceRetailSnapshot = const Value.absent(),
    this.priceWholesaleSnapshot = const Value.absent(),
    this.isGift = const Value.absent(),
    this.lineNote = const Value.absent(),
    this.lineOrder = const Value.absent(),
  });
  InvoiceLinesCompanion.insert({
    this.id = const Value.absent(),
    required int invoiceId,
    required int productId,
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.realProductId = const Value.absent(),
    this.realProductCode = const Value.absent(),
    this.realProductName = const Value.absent(),
    required int unitNumber,
    this.unitName = const Value.absent(),
    required double quantity,
    required double price,
    this.priceRetailSnapshot = const Value.absent(),
    this.priceWholesaleSnapshot = const Value.absent(),
    this.isGift = const Value.absent(),
    this.lineNote = const Value.absent(),
    this.lineOrder = const Value.absent(),
  })  : invoiceId = Value(invoiceId),
        productId = Value(productId),
        unitNumber = Value(unitNumber),
        quantity = Value(quantity),
        price = Value(price);
  static Insertable<InvoiceLine> custom({
    Expression<int>? id,
    Expression<int>? invoiceId,
    Expression<int>? productId,
    Expression<String>? productCode,
    Expression<String>? productName,
    Expression<int>? realProductId,
    Expression<String>? realProductCode,
    Expression<String>? realProductName,
    Expression<int>? unitNumber,
    Expression<String>? unitName,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<double>? priceRetailSnapshot,
    Expression<double>? priceWholesaleSnapshot,
    Expression<bool>? isGift,
    Expression<String>? lineNote,
    Expression<int>? lineOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (productId != null) 'product_id': productId,
      if (productCode != null) 'product_code': productCode,
      if (productName != null) 'product_name': productName,
      if (realProductId != null) 'real_product_id': realProductId,
      if (realProductCode != null) 'real_product_code': realProductCode,
      if (realProductName != null) 'real_product_name': realProductName,
      if (unitNumber != null) 'unit_number': unitNumber,
      if (unitName != null) 'unit_name': unitName,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (priceRetailSnapshot != null)
        'price_retail_snapshot': priceRetailSnapshot,
      if (priceWholesaleSnapshot != null)
        'price_wholesale_snapshot': priceWholesaleSnapshot,
      if (isGift != null) 'is_gift': isGift,
      if (lineNote != null) 'line_note': lineNote,
      if (lineOrder != null) 'line_order': lineOrder,
    });
  }

  InvoiceLinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? invoiceId,
      Value<int>? productId,
      Value<String?>? productCode,
      Value<String?>? productName,
      Value<int?>? realProductId,
      Value<String?>? realProductCode,
      Value<String?>? realProductName,
      Value<int>? unitNumber,
      Value<String?>? unitName,
      Value<double>? quantity,
      Value<double>? price,
      Value<double?>? priceRetailSnapshot,
      Value<double?>? priceWholesaleSnapshot,
      Value<bool>? isGift,
      Value<String?>? lineNote,
      Value<int?>? lineOrder}) {
    return InvoiceLinesCompanion(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      productId: productId ?? this.productId,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      realProductId: realProductId ?? this.realProductId,
      realProductCode: realProductCode ?? this.realProductCode,
      realProductName: realProductName ?? this.realProductName,
      unitNumber: unitNumber ?? this.unitNumber,
      unitName: unitName ?? this.unitName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      priceRetailSnapshot: priceRetailSnapshot ?? this.priceRetailSnapshot,
      priceWholesaleSnapshot:
          priceWholesaleSnapshot ?? this.priceWholesaleSnapshot,
      isGift: isGift ?? this.isGift,
      lineNote: lineNote ?? this.lineNote,
      lineOrder: lineOrder ?? this.lineOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<int>(invoiceId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productCode.present) {
      map['product_code'] = Variable<String>(productCode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (realProductId.present) {
      map['real_product_id'] = Variable<int>(realProductId.value);
    }
    if (realProductCode.present) {
      map['real_product_code'] = Variable<String>(realProductCode.value);
    }
    if (realProductName.present) {
      map['real_product_name'] = Variable<String>(realProductName.value);
    }
    if (unitNumber.present) {
      map['unit_number'] = Variable<int>(unitNumber.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (priceRetailSnapshot.present) {
      map['price_retail_snapshot'] =
          Variable<double>(priceRetailSnapshot.value);
    }
    if (priceWholesaleSnapshot.present) {
      map['price_wholesale_snapshot'] =
          Variable<double>(priceWholesaleSnapshot.value);
    }
    if (isGift.present) {
      map['is_gift'] = Variable<bool>(isGift.value);
    }
    if (lineNote.present) {
      map['line_note'] = Variable<String>(lineNote.value);
    }
    if (lineOrder.present) {
      map['line_order'] = Variable<int>(lineOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceLinesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('productId: $productId, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('realProductId: $realProductId, ')
          ..write('realProductCode: $realProductCode, ')
          ..write('realProductName: $realProductName, ')
          ..write('unitNumber: $unitNumber, ')
          ..write('unitName: $unitName, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('priceRetailSnapshot: $priceRetailSnapshot, ')
          ..write('priceWholesaleSnapshot: $priceWholesaleSnapshot, ')
          ..write('isGift: $isGift, ')
          ..write('lineNote: $lineNote, ')
          ..write('lineOrder: $lineOrder')
          ..write(')'))
        .toString();
  }
}

class $VouchersTable extends Vouchers with TableInfo<$VouchersTable, Voucher> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VouchersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _voucherNumberMeta =
      const VerificationMeta('voucherNumber');
  @override
  late final GeneratedColumn<int> voucherNumber = GeneratedColumn<int>(
      'voucher_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _debitAccountMeta =
      const VerificationMeta('debitAccount');
  @override
  late final GeneratedColumn<String> debitAccount = GeneratedColumn<String>(
      'debit_account', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creditAccountMeta =
      const VerificationMeta('creditAccount');
  @override
  late final GeneratedColumn<String> creditAccount = GeneratedColumn<String>(
      'credit_account', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        voucherNumber,
        type,
        status,
        date,
        debitAccount,
        creditAccount,
        amount,
        currency,
        exchangeRate,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vouchers';
  @override
  VerificationContext validateIntegrity(Insertable<Voucher> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('voucher_number')) {
      context.handle(
          _voucherNumberMeta,
          voucherNumber.isAcceptableOrUnknown(
              data['voucher_number']!, _voucherNumberMeta));
    } else if (isInserting) {
      context.missing(_voucherNumberMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('debit_account')) {
      context.handle(
          _debitAccountMeta,
          debitAccount.isAcceptableOrUnknown(
              data['debit_account']!, _debitAccountMeta));
    } else if (isInserting) {
      context.missing(_debitAccountMeta);
    }
    if (data.containsKey('credit_account')) {
      context.handle(
          _creditAccountMeta,
          creditAccount.isAcceptableOrUnknown(
              data['credit_account']!, _creditAccountMeta));
    } else if (isInserting) {
      context.missing(_creditAccountMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate']!, _exchangeRateMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Voucher map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Voucher(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      voucherNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}voucher_number'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      debitAccount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}debit_account'])!,
      creditAccount: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}credit_account'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      exchangeRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exchange_rate']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $VouchersTable createAlias(String alias) {
    return $VouchersTable(attachedDatabase, alias);
  }
}

class Voucher extends DataClass implements Insertable<Voucher> {
  final int id;
  final int voucherNumber;
  final String type;
  final String status;
  final String date;
  final String debitAccount;
  final String creditAccount;
  final double amount;
  final String currency;
  final double? exchangeRate;
  final String? note;
  const Voucher(
      {required this.id,
      required this.voucherNumber,
      required this.type,
      required this.status,
      required this.date,
      required this.debitAccount,
      required this.creditAccount,
      required this.amount,
      required this.currency,
      this.exchangeRate,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['voucher_number'] = Variable<int>(voucherNumber);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['date'] = Variable<String>(date);
    map['debit_account'] = Variable<String>(debitAccount);
    map['credit_account'] = Variable<String>(creditAccount);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || exchangeRate != null) {
      map['exchange_rate'] = Variable<double>(exchangeRate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  VouchersCompanion toCompanion(bool nullToAbsent) {
    return VouchersCompanion(
      id: Value(id),
      voucherNumber: Value(voucherNumber),
      type: Value(type),
      status: Value(status),
      date: Value(date),
      debitAccount: Value(debitAccount),
      creditAccount: Value(creditAccount),
      amount: Value(amount),
      currency: Value(currency),
      exchangeRate: exchangeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Voucher.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Voucher(
      id: serializer.fromJson<int>(json['id']),
      voucherNumber: serializer.fromJson<int>(json['voucherNumber']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      date: serializer.fromJson<String>(json['date']),
      debitAccount: serializer.fromJson<String>(json['debitAccount']),
      creditAccount: serializer.fromJson<String>(json['creditAccount']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      exchangeRate: serializer.fromJson<double?>(json['exchangeRate']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'voucherNumber': serializer.toJson<int>(voucherNumber),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'date': serializer.toJson<String>(date),
      'debitAccount': serializer.toJson<String>(debitAccount),
      'creditAccount': serializer.toJson<String>(creditAccount),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'exchangeRate': serializer.toJson<double?>(exchangeRate),
      'note': serializer.toJson<String?>(note),
    };
  }

  Voucher copyWith(
          {int? id,
          int? voucherNumber,
          String? type,
          String? status,
          String? date,
          String? debitAccount,
          String? creditAccount,
          double? amount,
          String? currency,
          Value<double?> exchangeRate = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      Voucher(
        id: id ?? this.id,
        voucherNumber: voucherNumber ?? this.voucherNumber,
        type: type ?? this.type,
        status: status ?? this.status,
        date: date ?? this.date,
        debitAccount: debitAccount ?? this.debitAccount,
        creditAccount: creditAccount ?? this.creditAccount,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        exchangeRate:
            exchangeRate.present ? exchangeRate.value : this.exchangeRate,
        note: note.present ? note.value : this.note,
      );
  Voucher copyWithCompanion(VouchersCompanion data) {
    return Voucher(
      id: data.id.present ? data.id.value : this.id,
      voucherNumber: data.voucherNumber.present
          ? data.voucherNumber.value
          : this.voucherNumber,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      date: data.date.present ? data.date.value : this.date,
      debitAccount: data.debitAccount.present
          ? data.debitAccount.value
          : this.debitAccount,
      creditAccount: data.creditAccount.present
          ? data.creditAccount.value
          : this.creditAccount,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Voucher(')
          ..write('id: $id, ')
          ..write('voucherNumber: $voucherNumber, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('debitAccount: $debitAccount, ')
          ..write('creditAccount: $creditAccount, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, voucherNumber, type, status, date,
      debitAccount, creditAccount, amount, currency, exchangeRate, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Voucher &&
          other.id == this.id &&
          other.voucherNumber == this.voucherNumber &&
          other.type == this.type &&
          other.status == this.status &&
          other.date == this.date &&
          other.debitAccount == this.debitAccount &&
          other.creditAccount == this.creditAccount &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.exchangeRate == this.exchangeRate &&
          other.note == this.note);
}

class VouchersCompanion extends UpdateCompanion<Voucher> {
  final Value<int> id;
  final Value<int> voucherNumber;
  final Value<String> type;
  final Value<String> status;
  final Value<String> date;
  final Value<String> debitAccount;
  final Value<String> creditAccount;
  final Value<double> amount;
  final Value<String> currency;
  final Value<double?> exchangeRate;
  final Value<String?> note;
  const VouchersCompanion({
    this.id = const Value.absent(),
    this.voucherNumber = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.date = const Value.absent(),
    this.debitAccount = const Value.absent(),
    this.creditAccount = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.note = const Value.absent(),
  });
  VouchersCompanion.insert({
    this.id = const Value.absent(),
    required int voucherNumber,
    required String type,
    required String status,
    required String date,
    required String debitAccount,
    required String creditAccount,
    required double amount,
    required String currency,
    this.exchangeRate = const Value.absent(),
    this.note = const Value.absent(),
  })  : voucherNumber = Value(voucherNumber),
        type = Value(type),
        status = Value(status),
        date = Value(date),
        debitAccount = Value(debitAccount),
        creditAccount = Value(creditAccount),
        amount = Value(amount),
        currency = Value(currency);
  static Insertable<Voucher> custom({
    Expression<int>? id,
    Expression<int>? voucherNumber,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? date,
    Expression<String>? debitAccount,
    Expression<String>? creditAccount,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<double>? exchangeRate,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (voucherNumber != null) 'voucher_number': voucherNumber,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
      if (debitAccount != null) 'debit_account': debitAccount,
      if (creditAccount != null) 'credit_account': creditAccount,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (note != null) 'note': note,
    });
  }

  VouchersCompanion copyWith(
      {Value<int>? id,
      Value<int>? voucherNumber,
      Value<String>? type,
      Value<String>? status,
      Value<String>? date,
      Value<String>? debitAccount,
      Value<String>? creditAccount,
      Value<double>? amount,
      Value<String>? currency,
      Value<double?>? exchangeRate,
      Value<String?>? note}) {
    return VouchersCompanion(
      id: id ?? this.id,
      voucherNumber: voucherNumber ?? this.voucherNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      debitAccount: debitAccount ?? this.debitAccount,
      creditAccount: creditAccount ?? this.creditAccount,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (voucherNumber.present) {
      map['voucher_number'] = Variable<int>(voucherNumber.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (debitAccount.present) {
      map['debit_account'] = Variable<String>(debitAccount.value);
    }
    if (creditAccount.present) {
      map['credit_account'] = Variable<String>(creditAccount.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VouchersCompanion(')
          ..write('id: $id, ')
          ..write('voucherNumber: $voucherNumber, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('debitAccount: $debitAccount, ')
          ..write('creditAccount: $creditAccount, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $TransfersTable extends Transfers
    with TableInfo<$TransfersTable, Transfer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransfersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transferNumberMeta =
      const VerificationMeta('transferNumber');
  @override
  late final GeneratedColumn<int> transferNumber = GeneratedColumn<int>(
      'transfer_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromWarehouseMeta =
      const VerificationMeta('fromWarehouse');
  @override
  late final GeneratedColumn<String> fromWarehouse = GeneratedColumn<String>(
      'from_warehouse', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _toWarehouseMeta =
      const VerificationMeta('toWarehouse');
  @override
  late final GeneratedColumn<String> toWarehouse = GeneratedColumn<String>(
      'to_warehouse', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalQuantitiesMeta =
      const VerificationMeta('totalQuantities');
  @override
  late final GeneratedColumn<double> totalQuantities = GeneratedColumn<double>(
      'total_quantities', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transferNumber,
        name,
        status,
        date,
        fromWarehouse,
        toWarehouse,
        totalQuantities
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfers';
  @override
  VerificationContext validateIntegrity(Insertable<Transfer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transfer_number')) {
      context.handle(
          _transferNumberMeta,
          transferNumber.isAcceptableOrUnknown(
              data['transfer_number']!, _transferNumberMeta));
    } else if (isInserting) {
      context.missing(_transferNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('from_warehouse')) {
      context.handle(
          _fromWarehouseMeta,
          fromWarehouse.isAcceptableOrUnknown(
              data['from_warehouse']!, _fromWarehouseMeta));
    }
    if (data.containsKey('to_warehouse')) {
      context.handle(
          _toWarehouseMeta,
          toWarehouse.isAcceptableOrUnknown(
              data['to_warehouse']!, _toWarehouseMeta));
    }
    if (data.containsKey('total_quantities')) {
      context.handle(
          _totalQuantitiesMeta,
          totalQuantities.isAcceptableOrUnknown(
              data['total_quantities']!, _totalQuantitiesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transfer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transferNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transfer_number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      fromWarehouse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_warehouse']),
      toWarehouse: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_warehouse']),
      totalQuantities: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_quantities'])!,
    );
  }

  @override
  $TransfersTable createAlias(String alias) {
    return $TransfersTable(attachedDatabase, alias);
  }
}

class Transfer extends DataClass implements Insertable<Transfer> {
  final int id;
  final int transferNumber;
  final String name;
  final String status;
  final String date;
  final String? fromWarehouse;
  final String? toWarehouse;
  final double totalQuantities;
  const Transfer(
      {required this.id,
      required this.transferNumber,
      required this.name,
      required this.status,
      required this.date,
      this.fromWarehouse,
      this.toWarehouse,
      required this.totalQuantities});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transfer_number'] = Variable<int>(transferNumber);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || fromWarehouse != null) {
      map['from_warehouse'] = Variable<String>(fromWarehouse);
    }
    if (!nullToAbsent || toWarehouse != null) {
      map['to_warehouse'] = Variable<String>(toWarehouse);
    }
    map['total_quantities'] = Variable<double>(totalQuantities);
    return map;
  }

  TransfersCompanion toCompanion(bool nullToAbsent) {
    return TransfersCompanion(
      id: Value(id),
      transferNumber: Value(transferNumber),
      name: Value(name),
      status: Value(status),
      date: Value(date),
      fromWarehouse: fromWarehouse == null && nullToAbsent
          ? const Value.absent()
          : Value(fromWarehouse),
      toWarehouse: toWarehouse == null && nullToAbsent
          ? const Value.absent()
          : Value(toWarehouse),
      totalQuantities: Value(totalQuantities),
    );
  }

  factory Transfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transfer(
      id: serializer.fromJson<int>(json['id']),
      transferNumber: serializer.fromJson<int>(json['transferNumber']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      date: serializer.fromJson<String>(json['date']),
      fromWarehouse: serializer.fromJson<String?>(json['fromWarehouse']),
      toWarehouse: serializer.fromJson<String?>(json['toWarehouse']),
      totalQuantities: serializer.fromJson<double>(json['totalQuantities']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transferNumber': serializer.toJson<int>(transferNumber),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'date': serializer.toJson<String>(date),
      'fromWarehouse': serializer.toJson<String?>(fromWarehouse),
      'toWarehouse': serializer.toJson<String?>(toWarehouse),
      'totalQuantities': serializer.toJson<double>(totalQuantities),
    };
  }

  Transfer copyWith(
          {int? id,
          int? transferNumber,
          String? name,
          String? status,
          String? date,
          Value<String?> fromWarehouse = const Value.absent(),
          Value<String?> toWarehouse = const Value.absent(),
          double? totalQuantities}) =>
      Transfer(
        id: id ?? this.id,
        transferNumber: transferNumber ?? this.transferNumber,
        name: name ?? this.name,
        status: status ?? this.status,
        date: date ?? this.date,
        fromWarehouse:
            fromWarehouse.present ? fromWarehouse.value : this.fromWarehouse,
        toWarehouse: toWarehouse.present ? toWarehouse.value : this.toWarehouse,
        totalQuantities: totalQuantities ?? this.totalQuantities,
      );
  Transfer copyWithCompanion(TransfersCompanion data) {
    return Transfer(
      id: data.id.present ? data.id.value : this.id,
      transferNumber: data.transferNumber.present
          ? data.transferNumber.value
          : this.transferNumber,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      date: data.date.present ? data.date.value : this.date,
      fromWarehouse: data.fromWarehouse.present
          ? data.fromWarehouse.value
          : this.fromWarehouse,
      toWarehouse:
          data.toWarehouse.present ? data.toWarehouse.value : this.toWarehouse,
      totalQuantities: data.totalQuantities.present
          ? data.totalQuantities.value
          : this.totalQuantities,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transfer(')
          ..write('id: $id, ')
          ..write('transferNumber: $transferNumber, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('fromWarehouse: $fromWarehouse, ')
          ..write('toWarehouse: $toWarehouse, ')
          ..write('totalQuantities: $totalQuantities')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transferNumber, name, status, date,
      fromWarehouse, toWarehouse, totalQuantities);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transfer &&
          other.id == this.id &&
          other.transferNumber == this.transferNumber &&
          other.name == this.name &&
          other.status == this.status &&
          other.date == this.date &&
          other.fromWarehouse == this.fromWarehouse &&
          other.toWarehouse == this.toWarehouse &&
          other.totalQuantities == this.totalQuantities);
}

class TransfersCompanion extends UpdateCompanion<Transfer> {
  final Value<int> id;
  final Value<int> transferNumber;
  final Value<String> name;
  final Value<String> status;
  final Value<String> date;
  final Value<String?> fromWarehouse;
  final Value<String?> toWarehouse;
  final Value<double> totalQuantities;
  const TransfersCompanion({
    this.id = const Value.absent(),
    this.transferNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.date = const Value.absent(),
    this.fromWarehouse = const Value.absent(),
    this.toWarehouse = const Value.absent(),
    this.totalQuantities = const Value.absent(),
  });
  TransfersCompanion.insert({
    this.id = const Value.absent(),
    required int transferNumber,
    required String name,
    required String status,
    required String date,
    this.fromWarehouse = const Value.absent(),
    this.toWarehouse = const Value.absent(),
    this.totalQuantities = const Value.absent(),
  })  : transferNumber = Value(transferNumber),
        name = Value(name),
        status = Value(status),
        date = Value(date);
  static Insertable<Transfer> custom({
    Expression<int>? id,
    Expression<int>? transferNumber,
    Expression<String>? name,
    Expression<String>? status,
    Expression<String>? date,
    Expression<String>? fromWarehouse,
    Expression<String>? toWarehouse,
    Expression<double>? totalQuantities,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transferNumber != null) 'transfer_number': transferNumber,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
      if (fromWarehouse != null) 'from_warehouse': fromWarehouse,
      if (toWarehouse != null) 'to_warehouse': toWarehouse,
      if (totalQuantities != null) 'total_quantities': totalQuantities,
    });
  }

  TransfersCompanion copyWith(
      {Value<int>? id,
      Value<int>? transferNumber,
      Value<String>? name,
      Value<String>? status,
      Value<String>? date,
      Value<String?>? fromWarehouse,
      Value<String?>? toWarehouse,
      Value<double>? totalQuantities}) {
    return TransfersCompanion(
      id: id ?? this.id,
      transferNumber: transferNumber ?? this.transferNumber,
      name: name ?? this.name,
      status: status ?? this.status,
      date: date ?? this.date,
      fromWarehouse: fromWarehouse ?? this.fromWarehouse,
      toWarehouse: toWarehouse ?? this.toWarehouse,
      totalQuantities: totalQuantities ?? this.totalQuantities,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transferNumber.present) {
      map['transfer_number'] = Variable<int>(transferNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (fromWarehouse.present) {
      map['from_warehouse'] = Variable<String>(fromWarehouse.value);
    }
    if (toWarehouse.present) {
      map['to_warehouse'] = Variable<String>(toWarehouse.value);
    }
    if (totalQuantities.present) {
      map['total_quantities'] = Variable<double>(totalQuantities.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersCompanion(')
          ..write('id: $id, ')
          ..write('transferNumber: $transferNumber, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('fromWarehouse: $fromWarehouse, ')
          ..write('toWarehouse: $toWarehouse, ')
          ..write('totalQuantities: $totalQuantities')
          ..write(')'))
        .toString();
  }
}

class $TransferLinesTable extends TransferLines
    with TableInfo<$TransferLinesTable, TransferLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransferLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _transferIdMeta =
      const VerificationMeta('transferId');
  @override
  late final GeneratedColumn<int> transferId = GeneratedColumn<int>(
      'transfer_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transfers (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _productCodeMeta =
      const VerificationMeta('productCode');
  @override
  late final GeneratedColumn<String> productCode = GeneratedColumn<String>(
      'product_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitNumberMeta =
      const VerificationMeta('unitNumber');
  @override
  late final GeneratedColumn<int> unitNumber = GeneratedColumn<int>(
      'unit_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitNameMeta =
      const VerificationMeta('unitName');
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
      'unit_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transferId,
        productId,
        productCode,
        productName,
        unitNumber,
        unitName,
        quantity
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfer_lines';
  @override
  VerificationContext validateIntegrity(Insertable<TransferLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transfer_id')) {
      context.handle(
          _transferIdMeta,
          transferId.isAcceptableOrUnknown(
              data['transfer_id']!, _transferIdMeta));
    } else if (isInserting) {
      context.missing(_transferIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_code')) {
      context.handle(
          _productCodeMeta,
          productCode.isAcceptableOrUnknown(
              data['product_code']!, _productCodeMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    }
    if (data.containsKey('unit_number')) {
      context.handle(
          _unitNumberMeta,
          unitNumber.isAcceptableOrUnknown(
              data['unit_number']!, _unitNumberMeta));
    } else if (isInserting) {
      context.missing(_unitNumberMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(_unitNameMeta,
          unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransferLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      transferId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transfer_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      productCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_code']),
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name']),
      unitNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_number'])!,
      unitName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_name']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $TransferLinesTable createAlias(String alias) {
    return $TransferLinesTable(attachedDatabase, alias);
  }
}

class TransferLine extends DataClass implements Insertable<TransferLine> {
  final int id;
  final int transferId;
  final int productId;
  final String? productCode;
  final String? productName;
  final int unitNumber;
  final String? unitName;
  final double quantity;
  const TransferLine(
      {required this.id,
      required this.transferId,
      required this.productId,
      this.productCode,
      this.productName,
      required this.unitNumber,
      this.unitName,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transfer_id'] = Variable<int>(transferId);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || productCode != null) {
      map['product_code'] = Variable<String>(productCode);
    }
    if (!nullToAbsent || productName != null) {
      map['product_name'] = Variable<String>(productName);
    }
    map['unit_number'] = Variable<int>(unitNumber);
    if (!nullToAbsent || unitName != null) {
      map['unit_name'] = Variable<String>(unitName);
    }
    map['quantity'] = Variable<double>(quantity);
    return map;
  }

  TransferLinesCompanion toCompanion(bool nullToAbsent) {
    return TransferLinesCompanion(
      id: Value(id),
      transferId: Value(transferId),
      productId: Value(productId),
      productCode: productCode == null && nullToAbsent
          ? const Value.absent()
          : Value(productCode),
      productName: productName == null && nullToAbsent
          ? const Value.absent()
          : Value(productName),
      unitNumber: Value(unitNumber),
      unitName: unitName == null && nullToAbsent
          ? const Value.absent()
          : Value(unitName),
      quantity: Value(quantity),
    );
  }

  factory TransferLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransferLine(
      id: serializer.fromJson<int>(json['id']),
      transferId: serializer.fromJson<int>(json['transferId']),
      productId: serializer.fromJson<int>(json['productId']),
      productCode: serializer.fromJson<String?>(json['productCode']),
      productName: serializer.fromJson<String?>(json['productName']),
      unitNumber: serializer.fromJson<int>(json['unitNumber']),
      unitName: serializer.fromJson<String?>(json['unitName']),
      quantity: serializer.fromJson<double>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transferId': serializer.toJson<int>(transferId),
      'productId': serializer.toJson<int>(productId),
      'productCode': serializer.toJson<String?>(productCode),
      'productName': serializer.toJson<String?>(productName),
      'unitNumber': serializer.toJson<int>(unitNumber),
      'unitName': serializer.toJson<String?>(unitName),
      'quantity': serializer.toJson<double>(quantity),
    };
  }

  TransferLine copyWith(
          {int? id,
          int? transferId,
          int? productId,
          Value<String?> productCode = const Value.absent(),
          Value<String?> productName = const Value.absent(),
          int? unitNumber,
          Value<String?> unitName = const Value.absent(),
          double? quantity}) =>
      TransferLine(
        id: id ?? this.id,
        transferId: transferId ?? this.transferId,
        productId: productId ?? this.productId,
        productCode: productCode.present ? productCode.value : this.productCode,
        productName: productName.present ? productName.value : this.productName,
        unitNumber: unitNumber ?? this.unitNumber,
        unitName: unitName.present ? unitName.value : this.unitName,
        quantity: quantity ?? this.quantity,
      );
  TransferLine copyWithCompanion(TransferLinesCompanion data) {
    return TransferLine(
      id: data.id.present ? data.id.value : this.id,
      transferId:
          data.transferId.present ? data.transferId.value : this.transferId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productCode:
          data.productCode.present ? data.productCode.value : this.productCode,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      unitNumber:
          data.unitNumber.present ? data.unitNumber.value : this.unitNumber,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransferLine(')
          ..write('id: $id, ')
          ..write('transferId: $transferId, ')
          ..write('productId: $productId, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('unitNumber: $unitNumber, ')
          ..write('unitName: $unitName, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transferId, productId, productCode,
      productName, unitNumber, unitName, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferLine &&
          other.id == this.id &&
          other.transferId == this.transferId &&
          other.productId == this.productId &&
          other.productCode == this.productCode &&
          other.productName == this.productName &&
          other.unitNumber == this.unitNumber &&
          other.unitName == this.unitName &&
          other.quantity == this.quantity);
}

class TransferLinesCompanion extends UpdateCompanion<TransferLine> {
  final Value<int> id;
  final Value<int> transferId;
  final Value<int> productId;
  final Value<String?> productCode;
  final Value<String?> productName;
  final Value<int> unitNumber;
  final Value<String?> unitName;
  final Value<double> quantity;
  const TransferLinesCompanion({
    this.id = const Value.absent(),
    this.transferId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    this.unitNumber = const Value.absent(),
    this.unitName = const Value.absent(),
    this.quantity = const Value.absent(),
  });
  TransferLinesCompanion.insert({
    this.id = const Value.absent(),
    required int transferId,
    required int productId,
    this.productCode = const Value.absent(),
    this.productName = const Value.absent(),
    required int unitNumber,
    this.unitName = const Value.absent(),
    required double quantity,
  })  : transferId = Value(transferId),
        productId = Value(productId),
        unitNumber = Value(unitNumber),
        quantity = Value(quantity);
  static Insertable<TransferLine> custom({
    Expression<int>? id,
    Expression<int>? transferId,
    Expression<int>? productId,
    Expression<String>? productCode,
    Expression<String>? productName,
    Expression<int>? unitNumber,
    Expression<String>? unitName,
    Expression<double>? quantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transferId != null) 'transfer_id': transferId,
      if (productId != null) 'product_id': productId,
      if (productCode != null) 'product_code': productCode,
      if (productName != null) 'product_name': productName,
      if (unitNumber != null) 'unit_number': unitNumber,
      if (unitName != null) 'unit_name': unitName,
      if (quantity != null) 'quantity': quantity,
    });
  }

  TransferLinesCompanion copyWith(
      {Value<int>? id,
      Value<int>? transferId,
      Value<int>? productId,
      Value<String?>? productCode,
      Value<String?>? productName,
      Value<int>? unitNumber,
      Value<String?>? unitName,
      Value<double>? quantity}) {
    return TransferLinesCompanion(
      id: id ?? this.id,
      transferId: transferId ?? this.transferId,
      productId: productId ?? this.productId,
      productCode: productCode ?? this.productCode,
      productName: productName ?? this.productName,
      unitNumber: unitNumber ?? this.unitNumber,
      unitName: unitName ?? this.unitName,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transferId.present) {
      map['transfer_id'] = Variable<int>(transferId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productCode.present) {
      map['product_code'] = Variable<String>(productCode.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unitNumber.present) {
      map['unit_number'] = Variable<int>(unitNumber.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransferLinesCompanion(')
          ..write('id: $id, ')
          ..write('transferId: $transferId, ')
          ..write('productId: $productId, ')
          ..write('productCode: $productCode, ')
          ..write('productName: $productName, ')
          ..write('unitNumber: $unitNumber, ')
          ..write('unitName: $unitName, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $WarehousesTable warehouses = $WarehousesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ProductCategoriesTable productCategories =
      $ProductCategoriesTable(this);
  late final $ProductColumnsTable productColumns = $ProductColumnsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceLinesTable invoiceLines = $InvoiceLinesTable(this);
  late final $VouchersTable vouchers = $VouchersTable(this);
  late final $TransfersTable transfers = $TransfersTable(this);
  late final $TransferLinesTable transferLines = $TransferLinesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        settings,
        warehouses,
        customers,
        productCategories,
        productColumns,
        products,
        accounts,
        invoices,
        invoiceLines,
        vouchers,
        transfers,
        transferLines
      ];
}

typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  Value<String?> value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String?> value,
  Value<int> rowid,
});

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SettingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SettingsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String?> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            Value<String?> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
        ));
}

class $$SettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer(super.$state);
  ColumnFilters<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get key => $state.composableBuilder(
      column: $state.table.key,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get value => $state.composableBuilder(
      column: $state.table.value,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$WarehousesTableCreateCompanionBuilder = WarehousesCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$WarehousesTableUpdateCompanionBuilder = WarehousesCompanion Function({
  Value<int> id,
  Value<String> name,
});

class $$WarehousesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WarehousesTable,
    Warehouse,
    $$WarehousesTableFilterComposer,
    $$WarehousesTableOrderingComposer,
    $$WarehousesTableCreateCompanionBuilder,
    $$WarehousesTableUpdateCompanionBuilder> {
  $$WarehousesTableTableManager(_$AppDatabase db, $WarehousesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$WarehousesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$WarehousesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              WarehousesCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              WarehousesCompanion.insert(
            id: id,
            name: name,
          ),
        ));
}

class $$WarehousesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $WarehousesTable> {
  $$WarehousesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$WarehousesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $WarehousesTable> {
  $$WarehousesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String accountCode,
  required String name,
  required String currency,
  Value<String?> phone1,
  Value<String?> phone2,
  Value<String?> email,
  Value<String?> notes,
  Value<String?> country,
  Value<String?> city,
  Value<String?> area,
  Value<String?> neighborhood,
  Value<String?> street,
  required String gender,
  Value<bool> isSent,
  Value<bool> isModified,
  Value<DateTime?> createdAt,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> accountCode,
  Value<String> name,
  Value<String> currency,
  Value<String?> phone1,
  Value<String?> phone2,
  Value<String?> email,
  Value<String?> notes,
  Value<String?> country,
  Value<String?> city,
  Value<String?> area,
  Value<String?> neighborhood,
  Value<String?> street,
  Value<String> gender,
  Value<bool> isSent,
  Value<bool> isModified,
  Value<DateTime?> createdAt,
});

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CustomersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CustomersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> accountCode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> phone1 = const Value.absent(),
            Value<String?> phone2 = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> area = const Value.absent(),
            Value<String?> neighborhood = const Value.absent(),
            Value<String?> street = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<bool> isSent = const Value.absent(),
            Value<bool> isModified = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            accountCode: accountCode,
            name: name,
            currency: currency,
            phone1: phone1,
            phone2: phone2,
            email: email,
            notes: notes,
            country: country,
            city: city,
            area: area,
            neighborhood: neighborhood,
            street: street,
            gender: gender,
            isSent: isSent,
            isModified: isModified,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String accountCode,
            required String name,
            required String currency,
            Value<String?> phone1 = const Value.absent(),
            Value<String?> phone2 = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> area = const Value.absent(),
            Value<String?> neighborhood = const Value.absent(),
            Value<String?> street = const Value.absent(),
            required String gender,
            Value<bool> isSent = const Value.absent(),
            Value<bool> isModified = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            accountCode: accountCode,
            name: name,
            currency: currency,
            phone1: phone1,
            phone2: phone2,
            email: email,
            notes: notes,
            country: country,
            city: city,
            area: area,
            neighborhood: neighborhood,
            street: street,
            gender: gender,
            isSent: isSent,
            isModified: isModified,
            createdAt: createdAt,
          ),
        ));
}

class $$CustomersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get accountCode => $state.composableBuilder(
      column: $state.table.accountCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone1 => $state.composableBuilder(
      column: $state.table.phone1,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get phone2 => $state.composableBuilder(
      column: $state.table.phone2,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get country => $state.composableBuilder(
      column: $state.table.country,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get city => $state.composableBuilder(
      column: $state.table.city,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get area => $state.composableBuilder(
      column: $state.table.area,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get neighborhood => $state.composableBuilder(
      column: $state.table.neighborhood,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get street => $state.composableBuilder(
      column: $state.table.street,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isSent => $state.composableBuilder(
      column: $state.table.isSent,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isModified => $state.composableBuilder(
      column: $state.table.isModified,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter invoicesRefs(
      ComposableFilter Function($$InvoicesTableFilterComposer f) f) {
    final $$InvoicesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.invoices,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder, parentComposers) =>
            $$InvoicesTableFilterComposer(ComposerState(
                $state.db, $state.db.invoices, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get accountCode => $state.composableBuilder(
      column: $state.table.accountCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone1 => $state.composableBuilder(
      column: $state.table.phone1,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get phone2 => $state.composableBuilder(
      column: $state.table.phone2,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get notes => $state.composableBuilder(
      column: $state.table.notes,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get country => $state.composableBuilder(
      column: $state.table.country,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get city => $state.composableBuilder(
      column: $state.table.city,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get area => $state.composableBuilder(
      column: $state.table.area,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get neighborhood => $state.composableBuilder(
      column: $state.table.neighborhood,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get street => $state.composableBuilder(
      column: $state.table.street,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get gender => $state.composableBuilder(
      column: $state.table.gender,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isSent => $state.composableBuilder(
      column: $state.table.isSent,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isModified => $state.composableBuilder(
      column: $state.table.isModified,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ProductCategoriesTableCreateCompanionBuilder
    = ProductCategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<int> gridColumns,
  Value<int> displayOrder,
  Value<bool> isVisible,
});
typedef $$ProductCategoriesTableUpdateCompanionBuilder
    = ProductCategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> gridColumns,
  Value<int> displayOrder,
  Value<bool> isVisible,
});

class $$ProductCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductCategoriesTable,
    ProductCategory,
    $$ProductCategoriesTableFilterComposer,
    $$ProductCategoriesTableOrderingComposer,
    $$ProductCategoriesTableCreateCompanionBuilder,
    $$ProductCategoriesTableUpdateCompanionBuilder> {
  $$ProductCategoriesTableTableManager(
      _$AppDatabase db, $ProductCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProductCategoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$ProductCategoriesTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> gridColumns = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
            Value<bool> isVisible = const Value.absent(),
          }) =>
              ProductCategoriesCompanion(
            id: id,
            name: name,
            gridColumns: gridColumns,
            displayOrder: displayOrder,
            isVisible: isVisible,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<int> gridColumns = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
            Value<bool> isVisible = const Value.absent(),
          }) =>
              ProductCategoriesCompanion.insert(
            id: id,
            name: name,
            gridColumns: gridColumns,
            displayOrder: displayOrder,
            isVisible: isVisible,
          ),
        ));
}

class $$ProductCategoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductCategoriesTable> {
  $$ProductCategoriesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get gridColumns => $state.composableBuilder(
      column: $state.table.gridColumns,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get displayOrder => $state.composableBuilder(
      column: $state.table.displayOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isVisible => $state.composableBuilder(
      column: $state.table.isVisible,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter productColumnsRefs(
      ComposableFilter Function($$ProductColumnsTableFilterComposer f) f) {
    final $$ProductColumnsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.productColumns,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$ProductColumnsTableFilterComposer(ComposerState($state.db,
                $state.db.productColumns, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter productsRefs(
      ComposableFilter Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ProductCategoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductCategoriesTable> {
  $$ProductCategoriesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get gridColumns => $state.composableBuilder(
      column: $state.table.gridColumns,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get displayOrder => $state.composableBuilder(
      column: $state.table.displayOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isVisible => $state.composableBuilder(
      column: $state.table.isVisible,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ProductColumnsTableCreateCompanionBuilder = ProductColumnsCompanion
    Function({
  Value<int> id,
  required int categoryId,
  required String name,
  Value<bool> isVisible,
  Value<int> displayOrder,
});
typedef $$ProductColumnsTableUpdateCompanionBuilder = ProductColumnsCompanion
    Function({
  Value<int> id,
  Value<int> categoryId,
  Value<String> name,
  Value<bool> isVisible,
  Value<int> displayOrder,
});

class $$ProductColumnsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductColumnsTable,
    ProductColumn,
    $$ProductColumnsTableFilterComposer,
    $$ProductColumnsTableOrderingComposer,
    $$ProductColumnsTableCreateCompanionBuilder,
    $$ProductColumnsTableUpdateCompanionBuilder> {
  $$ProductColumnsTableTableManager(
      _$AppDatabase db, $ProductColumnsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProductColumnsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProductColumnsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isVisible = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
          }) =>
              ProductColumnsCompanion(
            id: id,
            categoryId: categoryId,
            name: name,
            isVisible: isVisible,
            displayOrder: displayOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int categoryId,
            required String name,
            Value<bool> isVisible = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
          }) =>
              ProductColumnsCompanion.insert(
            id: id,
            categoryId: categoryId,
            name: name,
            isVisible: isVisible,
            displayOrder: displayOrder,
          ),
        ));
}

class $$ProductColumnsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductColumnsTable> {
  $$ProductColumnsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isVisible => $state.composableBuilder(
      column: $state.table.isVisible,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get displayOrder => $state.composableBuilder(
      column: $state.table.displayOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ProductCategoriesTableFilterComposer get categoryId {
    final $$ProductCategoriesTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $state.db.productCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductCategoriesTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.productCategories,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  ComposableFilter productsRefs(
      ComposableFilter Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.columnId,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ProductColumnsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductColumnsTable> {
  $$ProductColumnsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isVisible => $state.composableBuilder(
      column: $state.table.isVisible,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get displayOrder => $state.composableBuilder(
      column: $state.table.displayOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ProductCategoriesTableOrderingComposer get categoryId {
    final $$ProductCategoriesTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $state.db.productCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductCategoriesTableOrderingComposer(ComposerState(
                    $state.db,
                    $state.db.productCategories,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }
}

typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String code,
  required int categoryId,
  Value<int?> columnId,
  required String name,
  required String currency,
  required String unit1Name,
  Value<String?> unit1Barcode,
  Value<double> unit1PriceRetail,
  Value<double> unit1PriceWholesale,
  Value<String?> unit2Name,
  Value<String?> unit2Barcode,
  Value<double?> unit2Factor,
  Value<double?> unit2PriceRetail,
  Value<double?> unit2PriceWholesale,
  Value<String?> unit3Name,
  Value<String?> unit3Barcode,
  Value<double?> unit3Factor,
  Value<double?> unit3PriceRetail,
  Value<double?> unit3PriceWholesale,
  Value<int> defaultUnit,
  Value<bool> isActive,
  Value<int> displayOrder,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<int> categoryId,
  Value<int?> columnId,
  Value<String> name,
  Value<String> currency,
  Value<String> unit1Name,
  Value<String?> unit1Barcode,
  Value<double> unit1PriceRetail,
  Value<double> unit1PriceWholesale,
  Value<String?> unit2Name,
  Value<String?> unit2Barcode,
  Value<double?> unit2Factor,
  Value<double?> unit2PriceRetail,
  Value<double?> unit2PriceWholesale,
  Value<String?> unit3Name,
  Value<String?> unit3Barcode,
  Value<double?> unit3Factor,
  Value<double?> unit3PriceRetail,
  Value<double?> unit3PriceWholesale,
  Value<int> defaultUnit,
  Value<bool> isActive,
  Value<int> displayOrder,
});

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProductsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProductsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<int?> columnId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> unit1Name = const Value.absent(),
            Value<String?> unit1Barcode = const Value.absent(),
            Value<double> unit1PriceRetail = const Value.absent(),
            Value<double> unit1PriceWholesale = const Value.absent(),
            Value<String?> unit2Name = const Value.absent(),
            Value<String?> unit2Barcode = const Value.absent(),
            Value<double?> unit2Factor = const Value.absent(),
            Value<double?> unit2PriceRetail = const Value.absent(),
            Value<double?> unit2PriceWholesale = const Value.absent(),
            Value<String?> unit3Name = const Value.absent(),
            Value<String?> unit3Barcode = const Value.absent(),
            Value<double?> unit3Factor = const Value.absent(),
            Value<double?> unit3PriceRetail = const Value.absent(),
            Value<double?> unit3PriceWholesale = const Value.absent(),
            Value<int> defaultUnit = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            code: code,
            categoryId: categoryId,
            columnId: columnId,
            name: name,
            currency: currency,
            unit1Name: unit1Name,
            unit1Barcode: unit1Barcode,
            unit1PriceRetail: unit1PriceRetail,
            unit1PriceWholesale: unit1PriceWholesale,
            unit2Name: unit2Name,
            unit2Barcode: unit2Barcode,
            unit2Factor: unit2Factor,
            unit2PriceRetail: unit2PriceRetail,
            unit2PriceWholesale: unit2PriceWholesale,
            unit3Name: unit3Name,
            unit3Barcode: unit3Barcode,
            unit3Factor: unit3Factor,
            unit3PriceRetail: unit3PriceRetail,
            unit3PriceWholesale: unit3PriceWholesale,
            defaultUnit: defaultUnit,
            isActive: isActive,
            displayOrder: displayOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required int categoryId,
            Value<int?> columnId = const Value.absent(),
            required String name,
            required String currency,
            required String unit1Name,
            Value<String?> unit1Barcode = const Value.absent(),
            Value<double> unit1PriceRetail = const Value.absent(),
            Value<double> unit1PriceWholesale = const Value.absent(),
            Value<String?> unit2Name = const Value.absent(),
            Value<String?> unit2Barcode = const Value.absent(),
            Value<double?> unit2Factor = const Value.absent(),
            Value<double?> unit2PriceRetail = const Value.absent(),
            Value<double?> unit2PriceWholesale = const Value.absent(),
            Value<String?> unit3Name = const Value.absent(),
            Value<String?> unit3Barcode = const Value.absent(),
            Value<double?> unit3Factor = const Value.absent(),
            Value<double?> unit3PriceRetail = const Value.absent(),
            Value<double?> unit3PriceWholesale = const Value.absent(),
            Value<int> defaultUnit = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            code: code,
            categoryId: categoryId,
            columnId: columnId,
            name: name,
            currency: currency,
            unit1Name: unit1Name,
            unit1Barcode: unit1Barcode,
            unit1PriceRetail: unit1PriceRetail,
            unit1PriceWholesale: unit1PriceWholesale,
            unit2Name: unit2Name,
            unit2Barcode: unit2Barcode,
            unit2Factor: unit2Factor,
            unit2PriceRetail: unit2PriceRetail,
            unit2PriceWholesale: unit2PriceWholesale,
            unit3Name: unit3Name,
            unit3Barcode: unit3Barcode,
            unit3Factor: unit3Factor,
            unit3PriceRetail: unit3PriceRetail,
            unit3PriceWholesale: unit3PriceWholesale,
            defaultUnit: defaultUnit,
            isActive: isActive,
            displayOrder: displayOrder,
          ),
        ));
}

class $$ProductsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit1Name => $state.composableBuilder(
      column: $state.table.unit1Name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit1Barcode => $state.composableBuilder(
      column: $state.table.unit1Barcode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unit1PriceRetail => $state.composableBuilder(
      column: $state.table.unit1PriceRetail,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unit1PriceWholesale => $state.composableBuilder(
      column: $state.table.unit1PriceWholesale,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit2Name => $state.composableBuilder(
      column: $state.table.unit2Name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit2Barcode => $state.composableBuilder(
      column: $state.table.unit2Barcode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unit2Factor => $state.composableBuilder(
      column: $state.table.unit2Factor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unit2PriceRetail => $state.composableBuilder(
      column: $state.table.unit2PriceRetail,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unit2PriceWholesale => $state.composableBuilder(
      column: $state.table.unit2PriceWholesale,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit3Name => $state.composableBuilder(
      column: $state.table.unit3Name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit3Barcode => $state.composableBuilder(
      column: $state.table.unit3Barcode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unit3Factor => $state.composableBuilder(
      column: $state.table.unit3Factor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unit3PriceRetail => $state.composableBuilder(
      column: $state.table.unit3PriceRetail,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get unit3PriceWholesale => $state.composableBuilder(
      column: $state.table.unit3PriceWholesale,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get defaultUnit => $state.composableBuilder(
      column: $state.table.defaultUnit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get displayOrder => $state.composableBuilder(
      column: $state.table.displayOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ProductCategoriesTableFilterComposer get categoryId {
    final $$ProductCategoriesTableFilterComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $state.db.productCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductCategoriesTableFilterComposer(ComposerState(
                    $state.db,
                    $state.db.productCategories,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  $$ProductColumnsTableFilterComposer get columnId {
    final $$ProductColumnsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.columnId,
        referencedTable: $state.db.productColumns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductColumnsTableFilterComposer(ComposerState($state.db,
                $state.db.productColumns, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter transferLinesRefs(
      ComposableFilter Function($$TransferLinesTableFilterComposer f) f) {
    final $$TransferLinesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.transferLines,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder, parentComposers) =>
            $$TransferLinesTableFilterComposer(ComposerState($state.db,
                $state.db.transferLines, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit1Name => $state.composableBuilder(
      column: $state.table.unit1Name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit1Barcode => $state.composableBuilder(
      column: $state.table.unit1Barcode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unit1PriceRetail => $state.composableBuilder(
      column: $state.table.unit1PriceRetail,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unit1PriceWholesale => $state.composableBuilder(
      column: $state.table.unit1PriceWholesale,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit2Name => $state.composableBuilder(
      column: $state.table.unit2Name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit2Barcode => $state.composableBuilder(
      column: $state.table.unit2Barcode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unit2Factor => $state.composableBuilder(
      column: $state.table.unit2Factor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unit2PriceRetail => $state.composableBuilder(
      column: $state.table.unit2PriceRetail,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unit2PriceWholesale => $state.composableBuilder(
      column: $state.table.unit2PriceWholesale,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit3Name => $state.composableBuilder(
      column: $state.table.unit3Name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit3Barcode => $state.composableBuilder(
      column: $state.table.unit3Barcode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unit3Factor => $state.composableBuilder(
      column: $state.table.unit3Factor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unit3PriceRetail => $state.composableBuilder(
      column: $state.table.unit3PriceRetail,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get unit3PriceWholesale => $state.composableBuilder(
      column: $state.table.unit3PriceWholesale,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get defaultUnit => $state.composableBuilder(
      column: $state.table.defaultUnit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get displayOrder => $state.composableBuilder(
      column: $state.table.displayOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ProductCategoriesTableOrderingComposer get categoryId {
    final $$ProductCategoriesTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $state.db.productCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductCategoriesTableOrderingComposer(ComposerState(
                    $state.db,
                    $state.db.productCategories,
                    joinBuilder,
                    parentComposers)));
    return composer;
  }

  $$ProductColumnsTableOrderingComposer get columnId {
    final $$ProductColumnsTableOrderingComposer composer =
        $state.composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.columnId,
            referencedTable: $state.db.productColumns,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder, parentComposers) =>
                $$ProductColumnsTableOrderingComposer(ComposerState($state.db,
                    $state.db.productColumns, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  required String code,
  required String name,
  required String currency,
  Value<String> accountType,
  Value<bool> isSystem,
  Value<bool> isActive,
  Value<int> displayOrder,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String> currency,
  Value<String> accountType,
  Value<bool> isSystem,
  Value<bool> isActive,
  Value<int> displayOrder,
});

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AccountsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AccountsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> accountType = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            code: code,
            name: name,
            currency: currency,
            accountType: accountType,
            isSystem: isSystem,
            isActive: isActive,
            displayOrder: displayOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String name,
            required String currency,
            Value<String> accountType = const Value.absent(),
            Value<bool> isSystem = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            code: code,
            name: name,
            currency: currency,
            accountType: accountType,
            isSystem: isSystem,
            isActive: isActive,
            displayOrder: displayOrder,
          ),
        ));
}

class $$AccountsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get accountType => $state.composableBuilder(
      column: $state.table.accountType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isSystem => $state.composableBuilder(
      column: $state.table.isSystem,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get displayOrder => $state.composableBuilder(
      column: $state.table.displayOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AccountsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get code => $state.composableBuilder(
      column: $state.table.code,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get accountType => $state.composableBuilder(
      column: $state.table.accountType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isSystem => $state.composableBuilder(
      column: $state.table.isSystem,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get displayOrder => $state.composableBuilder(
      column: $state.table.displayOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$InvoicesTableCreateCompanionBuilder = InvoicesCompanion Function({
  Value<int> id,
  required int invoiceNumber,
  required String type,
  required String status,
  required String date,
  Value<int?> customerId,
  Value<String?> accountCode,
  required String paymentMethod,
  required String currency,
  Value<double?> exchangeRate,
  Value<String?> warehouseName,
  Value<double> subtotal,
  Value<double> discountAmount,
  Value<double> total,
  Value<String?> note,
});
typedef $$InvoicesTableUpdateCompanionBuilder = InvoicesCompanion Function({
  Value<int> id,
  Value<int> invoiceNumber,
  Value<String> type,
  Value<String> status,
  Value<String> date,
  Value<int?> customerId,
  Value<String?> accountCode,
  Value<String> paymentMethod,
  Value<String> currency,
  Value<double?> exchangeRate,
  Value<String?> warehouseName,
  Value<double> subtotal,
  Value<double> discountAmount,
  Value<double> total,
  Value<String?> note,
});

class $$InvoicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoicesTable,
    Invoice,
    $$InvoicesTableFilterComposer,
    $$InvoicesTableOrderingComposer,
    $$InvoicesTableCreateCompanionBuilder,
    $$InvoicesTableUpdateCompanionBuilder> {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$InvoicesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$InvoicesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> invoiceNumber = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int?> customerId = const Value.absent(),
            Value<String?> accountCode = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double?> exchangeRate = const Value.absent(),
            Value<String?> warehouseName = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              InvoicesCompanion(
            id: id,
            invoiceNumber: invoiceNumber,
            type: type,
            status: status,
            date: date,
            customerId: customerId,
            accountCode: accountCode,
            paymentMethod: paymentMethod,
            currency: currency,
            exchangeRate: exchangeRate,
            warehouseName: warehouseName,
            subtotal: subtotal,
            discountAmount: discountAmount,
            total: total,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int invoiceNumber,
            required String type,
            required String status,
            required String date,
            Value<int?> customerId = const Value.absent(),
            Value<String?> accountCode = const Value.absent(),
            required String paymentMethod,
            required String currency,
            Value<double?> exchangeRate = const Value.absent(),
            Value<String?> warehouseName = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              InvoicesCompanion.insert(
            id: id,
            invoiceNumber: invoiceNumber,
            type: type,
            status: status,
            date: date,
            customerId: customerId,
            accountCode: accountCode,
            paymentMethod: paymentMethod,
            currency: currency,
            exchangeRate: exchangeRate,
            warehouseName: warehouseName,
            subtotal: subtotal,
            discountAmount: discountAmount,
            total: total,
            note: note,
          ),
        ));
}

class $$InvoicesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get accountCode => $state.composableBuilder(
      column: $state.table.accountCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get paymentMethod => $state.composableBuilder(
      column: $state.table.paymentMethod,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get exchangeRate => $state.composableBuilder(
      column: $state.table.exchangeRate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get warehouseName => $state.composableBuilder(
      column: $state.table.warehouseName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get discountAmount => $state.composableBuilder(
      column: $state.table.discountAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get total => $state.composableBuilder(
      column: $state.table.total,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $state.db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CustomersTableFilterComposer(ComposerState(
                $state.db, $state.db.customers, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter invoiceLinesRefs(
      ComposableFilter Function($$InvoiceLinesTableFilterComposer f) f) {
    final $$InvoiceLinesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.invoiceLines,
        getReferencedColumn: (t) => t.invoiceId,
        builder: (joinBuilder, parentComposers) =>
            $$InvoiceLinesTableFilterComposer(ComposerState($state.db,
                $state.db.invoiceLines, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$InvoicesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get invoiceNumber => $state.composableBuilder(
      column: $state.table.invoiceNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get accountCode => $state.composableBuilder(
      column: $state.table.accountCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get paymentMethod => $state.composableBuilder(
      column: $state.table.paymentMethod,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get exchangeRate => $state.composableBuilder(
      column: $state.table.exchangeRate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get warehouseName => $state.composableBuilder(
      column: $state.table.warehouseName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get subtotal => $state.composableBuilder(
      column: $state.table.subtotal,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get discountAmount => $state.composableBuilder(
      column: $state.table.discountAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get total => $state.composableBuilder(
      column: $state.table.total,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $state.db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$CustomersTableOrderingComposer(ComposerState(
                $state.db, $state.db.customers, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$InvoiceLinesTableCreateCompanionBuilder = InvoiceLinesCompanion
    Function({
  Value<int> id,
  required int invoiceId,
  required int productId,
  Value<String?> productCode,
  Value<String?> productName,
  Value<int?> realProductId,
  Value<String?> realProductCode,
  Value<String?> realProductName,
  required int unitNumber,
  Value<String?> unitName,
  required double quantity,
  required double price,
  Value<double?> priceRetailSnapshot,
  Value<double?> priceWholesaleSnapshot,
  Value<bool> isGift,
  Value<String?> lineNote,
  Value<int?> lineOrder,
});
typedef $$InvoiceLinesTableUpdateCompanionBuilder = InvoiceLinesCompanion
    Function({
  Value<int> id,
  Value<int> invoiceId,
  Value<int> productId,
  Value<String?> productCode,
  Value<String?> productName,
  Value<int?> realProductId,
  Value<String?> realProductCode,
  Value<String?> realProductName,
  Value<int> unitNumber,
  Value<String?> unitName,
  Value<double> quantity,
  Value<double> price,
  Value<double?> priceRetailSnapshot,
  Value<double?> priceWholesaleSnapshot,
  Value<bool> isGift,
  Value<String?> lineNote,
  Value<int?> lineOrder,
});

class $$InvoiceLinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InvoiceLinesTable,
    InvoiceLine,
    $$InvoiceLinesTableFilterComposer,
    $$InvoiceLinesTableOrderingComposer,
    $$InvoiceLinesTableCreateCompanionBuilder,
    $$InvoiceLinesTableUpdateCompanionBuilder> {
  $$InvoiceLinesTableTableManager(_$AppDatabase db, $InvoiceLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$InvoiceLinesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$InvoiceLinesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> invoiceId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<String?> productCode = const Value.absent(),
            Value<String?> productName = const Value.absent(),
            Value<int?> realProductId = const Value.absent(),
            Value<String?> realProductCode = const Value.absent(),
            Value<String?> realProductName = const Value.absent(),
            Value<int> unitNumber = const Value.absent(),
            Value<String?> unitName = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double?> priceRetailSnapshot = const Value.absent(),
            Value<double?> priceWholesaleSnapshot = const Value.absent(),
            Value<bool> isGift = const Value.absent(),
            Value<String?> lineNote = const Value.absent(),
            Value<int?> lineOrder = const Value.absent(),
          }) =>
              InvoiceLinesCompanion(
            id: id,
            invoiceId: invoiceId,
            productId: productId,
            productCode: productCode,
            productName: productName,
            realProductId: realProductId,
            realProductCode: realProductCode,
            realProductName: realProductName,
            unitNumber: unitNumber,
            unitName: unitName,
            quantity: quantity,
            price: price,
            priceRetailSnapshot: priceRetailSnapshot,
            priceWholesaleSnapshot: priceWholesaleSnapshot,
            isGift: isGift,
            lineNote: lineNote,
            lineOrder: lineOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int invoiceId,
            required int productId,
            Value<String?> productCode = const Value.absent(),
            Value<String?> productName = const Value.absent(),
            Value<int?> realProductId = const Value.absent(),
            Value<String?> realProductCode = const Value.absent(),
            Value<String?> realProductName = const Value.absent(),
            required int unitNumber,
            Value<String?> unitName = const Value.absent(),
            required double quantity,
            required double price,
            Value<double?> priceRetailSnapshot = const Value.absent(),
            Value<double?> priceWholesaleSnapshot = const Value.absent(),
            Value<bool> isGift = const Value.absent(),
            Value<String?> lineNote = const Value.absent(),
            Value<int?> lineOrder = const Value.absent(),
          }) =>
              InvoiceLinesCompanion.insert(
            id: id,
            invoiceId: invoiceId,
            productId: productId,
            productCode: productCode,
            productName: productName,
            realProductId: realProductId,
            realProductCode: realProductCode,
            realProductName: realProductName,
            unitNumber: unitNumber,
            unitName: unitName,
            quantity: quantity,
            price: price,
            priceRetailSnapshot: priceRetailSnapshot,
            priceWholesaleSnapshot: priceWholesaleSnapshot,
            isGift: isGift,
            lineNote: lineNote,
            lineOrder: lineOrder,
          ),
        ));
}

class $$InvoiceLinesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get productCode => $state.composableBuilder(
      column: $state.table.productCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get productName => $state.composableBuilder(
      column: $state.table.productName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get realProductCode => $state.composableBuilder(
      column: $state.table.realProductCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get realProductName => $state.composableBuilder(
      column: $state.table.realProductName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get unitNumber => $state.composableBuilder(
      column: $state.table.unitNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unitName => $state.composableBuilder(
      column: $state.table.unitName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get priceRetailSnapshot => $state.composableBuilder(
      column: $state.table.priceRetailSnapshot,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get priceWholesaleSnapshot => $state.composableBuilder(
      column: $state.table.priceWholesaleSnapshot,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isGift => $state.composableBuilder(
      column: $state.table.isGift,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get lineNote => $state.composableBuilder(
      column: $state.table.lineNote,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get lineOrder => $state.composableBuilder(
      column: $state.table.lineOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $state.db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$InvoicesTableFilterComposer(ComposerState(
                $state.db, $state.db.invoices, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableFilterComposer get realProductId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.realProductId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$InvoiceLinesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $InvoiceLinesTable> {
  $$InvoiceLinesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get productCode => $state.composableBuilder(
      column: $state.table.productCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get productName => $state.composableBuilder(
      column: $state.table.productName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get realProductCode => $state.composableBuilder(
      column: $state.table.realProductCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get realProductName => $state.composableBuilder(
      column: $state.table.realProductName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get unitNumber => $state.composableBuilder(
      column: $state.table.unitNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unitName => $state.composableBuilder(
      column: $state.table.unitName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get priceRetailSnapshot => $state.composableBuilder(
      column: $state.table.priceRetailSnapshot,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get priceWholesaleSnapshot =>
      $state.composableBuilder(
          column: $state.table.priceWholesaleSnapshot,
          builder: (column, joinBuilders) =>
              ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isGift => $state.composableBuilder(
      column: $state.table.isGift,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get lineNote => $state.composableBuilder(
      column: $state.table.lineNote,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get lineOrder => $state.composableBuilder(
      column: $state.table.lineOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.invoiceId,
        referencedTable: $state.db.invoices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$InvoicesTableOrderingComposer(ComposerState(
                $state.db, $state.db.invoices, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableOrderingComposer get realProductId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.realProductId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$VouchersTableCreateCompanionBuilder = VouchersCompanion Function({
  Value<int> id,
  required int voucherNumber,
  required String type,
  required String status,
  required String date,
  required String debitAccount,
  required String creditAccount,
  required double amount,
  required String currency,
  Value<double?> exchangeRate,
  Value<String?> note,
});
typedef $$VouchersTableUpdateCompanionBuilder = VouchersCompanion Function({
  Value<int> id,
  Value<int> voucherNumber,
  Value<String> type,
  Value<String> status,
  Value<String> date,
  Value<String> debitAccount,
  Value<String> creditAccount,
  Value<double> amount,
  Value<String> currency,
  Value<double?> exchangeRate,
  Value<String?> note,
});

class $$VouchersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VouchersTable,
    Voucher,
    $$VouchersTableFilterComposer,
    $$VouchersTableOrderingComposer,
    $$VouchersTableCreateCompanionBuilder,
    $$VouchersTableUpdateCompanionBuilder> {
  $$VouchersTableTableManager(_$AppDatabase db, $VouchersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$VouchersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$VouchersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> voucherNumber = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> debitAccount = const Value.absent(),
            Value<String> creditAccount = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<double?> exchangeRate = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              VouchersCompanion(
            id: id,
            voucherNumber: voucherNumber,
            type: type,
            status: status,
            date: date,
            debitAccount: debitAccount,
            creditAccount: creditAccount,
            amount: amount,
            currency: currency,
            exchangeRate: exchangeRate,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int voucherNumber,
            required String type,
            required String status,
            required String date,
            required String debitAccount,
            required String creditAccount,
            required double amount,
            required String currency,
            Value<double?> exchangeRate = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              VouchersCompanion.insert(
            id: id,
            voucherNumber: voucherNumber,
            type: type,
            status: status,
            date: date,
            debitAccount: debitAccount,
            creditAccount: creditAccount,
            amount: amount,
            currency: currency,
            exchangeRate: exchangeRate,
            note: note,
          ),
        ));
}

class $$VouchersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get voucherNumber => $state.composableBuilder(
      column: $state.table.voucherNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get debitAccount => $state.composableBuilder(
      column: $state.table.debitAccount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get creditAccount => $state.composableBuilder(
      column: $state.table.creditAccount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get exchangeRate => $state.composableBuilder(
      column: $state.table.exchangeRate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$VouchersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $VouchersTable> {
  $$VouchersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get voucherNumber => $state.composableBuilder(
      column: $state.table.voucherNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get debitAccount => $state.composableBuilder(
      column: $state.table.debitAccount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get creditAccount => $state.composableBuilder(
      column: $state.table.creditAccount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get exchangeRate => $state.composableBuilder(
      column: $state.table.exchangeRate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TransfersTableCreateCompanionBuilder = TransfersCompanion Function({
  Value<int> id,
  required int transferNumber,
  required String name,
  required String status,
  required String date,
  Value<String?> fromWarehouse,
  Value<String?> toWarehouse,
  Value<double> totalQuantities,
});
typedef $$TransfersTableUpdateCompanionBuilder = TransfersCompanion Function({
  Value<int> id,
  Value<int> transferNumber,
  Value<String> name,
  Value<String> status,
  Value<String> date,
  Value<String?> fromWarehouse,
  Value<String?> toWarehouse,
  Value<double> totalQuantities,
});

class $$TransfersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransfersTable,
    Transfer,
    $$TransfersTableFilterComposer,
    $$TransfersTableOrderingComposer,
    $$TransfersTableCreateCompanionBuilder,
    $$TransfersTableUpdateCompanionBuilder> {
  $$TransfersTableTableManager(_$AppDatabase db, $TransfersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TransfersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TransfersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> transferNumber = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String?> fromWarehouse = const Value.absent(),
            Value<String?> toWarehouse = const Value.absent(),
            Value<double> totalQuantities = const Value.absent(),
          }) =>
              TransfersCompanion(
            id: id,
            transferNumber: transferNumber,
            name: name,
            status: status,
            date: date,
            fromWarehouse: fromWarehouse,
            toWarehouse: toWarehouse,
            totalQuantities: totalQuantities,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int transferNumber,
            required String name,
            required String status,
            required String date,
            Value<String?> fromWarehouse = const Value.absent(),
            Value<String?> toWarehouse = const Value.absent(),
            Value<double> totalQuantities = const Value.absent(),
          }) =>
              TransfersCompanion.insert(
            id: id,
            transferNumber: transferNumber,
            name: name,
            status: status,
            date: date,
            fromWarehouse: fromWarehouse,
            toWarehouse: toWarehouse,
            totalQuantities: totalQuantities,
          ),
        ));
}

class $$TransfersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get transferNumber => $state.composableBuilder(
      column: $state.table.transferNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fromWarehouse => $state.composableBuilder(
      column: $state.table.fromWarehouse,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get toWarehouse => $state.composableBuilder(
      column: $state.table.toWarehouse,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalQuantities => $state.composableBuilder(
      column: $state.table.totalQuantities,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter transferLinesRefs(
      ComposableFilter Function($$TransferLinesTableFilterComposer f) f) {
    final $$TransferLinesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.transferLines,
        getReferencedColumn: (t) => t.transferId,
        builder: (joinBuilder, parentComposers) =>
            $$TransferLinesTableFilterComposer(ComposerState($state.db,
                $state.db.transferLines, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$TransfersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TransfersTable> {
  $$TransfersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get transferNumber => $state.composableBuilder(
      column: $state.table.transferNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fromWarehouse => $state.composableBuilder(
      column: $state.table.fromWarehouse,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get toWarehouse => $state.composableBuilder(
      column: $state.table.toWarehouse,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalQuantities => $state.composableBuilder(
      column: $state.table.totalQuantities,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TransferLinesTableCreateCompanionBuilder = TransferLinesCompanion
    Function({
  Value<int> id,
  required int transferId,
  required int productId,
  Value<String?> productCode,
  Value<String?> productName,
  required int unitNumber,
  Value<String?> unitName,
  required double quantity,
});
typedef $$TransferLinesTableUpdateCompanionBuilder = TransferLinesCompanion
    Function({
  Value<int> id,
  Value<int> transferId,
  Value<int> productId,
  Value<String?> productCode,
  Value<String?> productName,
  Value<int> unitNumber,
  Value<String?> unitName,
  Value<double> quantity,
});

class $$TransferLinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransferLinesTable,
    TransferLine,
    $$TransferLinesTableFilterComposer,
    $$TransferLinesTableOrderingComposer,
    $$TransferLinesTableCreateCompanionBuilder,
    $$TransferLinesTableUpdateCompanionBuilder> {
  $$TransferLinesTableTableManager(_$AppDatabase db, $TransferLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TransferLinesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TransferLinesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> transferId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<String?> productCode = const Value.absent(),
            Value<String?> productName = const Value.absent(),
            Value<int> unitNumber = const Value.absent(),
            Value<String?> unitName = const Value.absent(),
            Value<double> quantity = const Value.absent(),
          }) =>
              TransferLinesCompanion(
            id: id,
            transferId: transferId,
            productId: productId,
            productCode: productCode,
            productName: productName,
            unitNumber: unitNumber,
            unitName: unitName,
            quantity: quantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int transferId,
            required int productId,
            Value<String?> productCode = const Value.absent(),
            Value<String?> productName = const Value.absent(),
            required int unitNumber,
            Value<String?> unitName = const Value.absent(),
            required double quantity,
          }) =>
              TransferLinesCompanion.insert(
            id: id,
            transferId: transferId,
            productId: productId,
            productCode: productCode,
            productName: productName,
            unitNumber: unitNumber,
            unitName: unitName,
            quantity: quantity,
          ),
        ));
}

class $$TransferLinesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TransferLinesTable> {
  $$TransferLinesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get productCode => $state.composableBuilder(
      column: $state.table.productCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get productName => $state.composableBuilder(
      column: $state.table.productName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get unitNumber => $state.composableBuilder(
      column: $state.table.unitNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unitName => $state.composableBuilder(
      column: $state.table.unitName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$TransfersTableFilterComposer get transferId {
    final $$TransfersTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transferId,
        referencedTable: $state.db.transfers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TransfersTableFilterComposer(ComposerState(
                $state.db, $state.db.transfers, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableFilterComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TransferLinesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TransferLinesTable> {
  $$TransferLinesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get productCode => $state.composableBuilder(
      column: $state.table.productCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get productName => $state.composableBuilder(
      column: $state.table.productName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get unitNumber => $state.composableBuilder(
      column: $state.table.unitNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unitName => $state.composableBuilder(
      column: $state.table.unitName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get quantity => $state.composableBuilder(
      column: $state.table.quantity,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$TransfersTableOrderingComposer get transferId {
    final $$TransfersTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transferId,
        referencedTable: $state.db.transfers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$TransfersTableOrderingComposer(ComposerState(
                $state.db, $state.db.transfers, joinBuilder, parentComposers)));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $state.db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ProductsTableOrderingComposer(ComposerState(
                $state.db, $state.db.products, joinBuilder, parentComposers)));
    return composer;
  }
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$WarehousesTableTableManager get warehouses =>
      $$WarehousesTableTableManager(_db, _db.warehouses);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ProductCategoriesTableTableManager get productCategories =>
      $$ProductCategoriesTableTableManager(_db, _db.productCategories);
  $$ProductColumnsTableTableManager get productColumns =>
      $$ProductColumnsTableTableManager(_db, _db.productColumns);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceLinesTableTableManager get invoiceLines =>
      $$InvoiceLinesTableTableManager(_db, _db.invoiceLines);
  $$VouchersTableTableManager get vouchers =>
      $$VouchersTableTableManager(_db, _db.vouchers);
  $$TransfersTableTableManager get transfers =>
      $$TransfersTableTableManager(_db, _db.transfers);
  $$TransferLinesTableTableManager get transferLines =>
      $$TransferLinesTableTableManager(_db, _db.transferLines);
}
