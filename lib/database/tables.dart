import 'package:drift/drift.dart';

// 1. جدول الإعدادات
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();
  @override
  Set<Column> get primaryKey => {key};
}

// 2. جدول المستودعات (جديد)
class Warehouses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

// 3. جدول الزبائن
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountCode => text().unique()();
  TextColumn get name => text()();
  TextColumn get currency => text()(); // 'SYP' أو 'USD'
  TextColumn get phone1 => text().nullable()();
  TextColumn get phone2 => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get area => text().nullable()();
  TextColumn get neighborhood => text().nullable()();
  TextColumn get street => text().nullable()();
  TextColumn get gender => text()(); // 'M' أو 'F'
  BoolColumn get isSent => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

// 4. جدول مجموعات المواد
class ProductCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
}

// 5. جدول المواد
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  IntColumn get categoryId => integer().references(ProductCategories, #id)();
  TextColumn get name => text()();
  TextColumn get barcode => text().nullable()();
  TextColumn get currency => text()(); // 'SYP' أو 'USD'

  TextColumn get unit1Name => text()();
  RealColumn get unit1PriceRetail => real().withDefault(const Constant(0))();
  RealColumn get unit1PriceWholesale => real().withDefault(const Constant(0))();

  TextColumn get unit2Name => text().nullable()();
  RealColumn get unit2Factor => real().nullable()();
  RealColumn get unit2PriceRetail => real().nullable()();
  RealColumn get unit2PriceWholesale => real().nullable()();

  TextColumn get unit3Name => text().nullable()();
  RealColumn get unit3Factor => real().nullable()();
  RealColumn get unit3PriceRetail => real().nullable()();
  RealColumn get unit3PriceWholesale => real().nullable()();

  IntColumn get defaultUnit => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 6. جدول الحسابات (الصناديق وحسابات النظام)
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  TextColumn get currency => text()(); // 'SYP', 'USD', 'BOTH'
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// 7. جدول الفواتير
class Invoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceNumber => integer()();
  TextColumn get type => text()(); // 'SALE' أو 'RETURN'
  TextColumn get status => text()(); // 'DRAFT', 'ISSUED', 'SENT'
  TextColumn get date => text()(); // YYYY-MM-DD
  IntColumn get customerId => integer().nullable().references(Customers, #id)();
  TextColumn get accountCode => text().nullable()();
  TextColumn get paymentMethod => text()(); // 'CASH' أو 'CREDIT'
  TextColumn get currency => text()(); // 'SYP' أو 'USD'
  RealColumn get exchangeRate => real().nullable()();
  TextColumn get warehouseName => text().nullable()(); // لتخزين اسم المستودع
  RealColumn get subtotal => real().withDefault(const Constant(0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
}

// 8. جدول أقلام الفواتير
class InvoiceLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer().references(Invoices, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get productCode => text().nullable()();
  TextColumn get productName => text().nullable()();
  IntColumn get unitNumber => integer()();
  TextColumn get unitName => text().nullable()();
  RealColumn get quantity => real()();
  RealColumn get price => real()();
  BoolColumn get isGift => boolean().withDefault(const Constant(false))();
  TextColumn get lineNote => text().nullable()();
}

// 9. جدول السندات
class Vouchers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get voucherNumber => integer()();
  TextColumn get type => text()(); // 'RECEIPT' أو 'PAYMENT'
  TextColumn get status => text()(); // 'DRAFT', 'ISSUED', 'SENT'
  TextColumn get date => text()(); // YYYY-MM-DD
  TextColumn get debitAccount => text()();
  TextColumn get creditAccount => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text()();
  RealColumn get exchangeRate => real().nullable()();
  TextColumn get note => text().nullable()();
}

// 10. جدول المناقلات (جديد)
class Transfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transferNumber => integer()();
  TextColumn get name => text()(); // الاسم المولد آلياً (مناقلة يوم...)
  TextColumn get status => text()(); // 'DRAFT', 'ISSUED', 'SENT'
  TextColumn get date => text()(); // YYYY-MM-DD
  TextColumn get fromWarehouse => text().nullable()(); // المستودع المسلم
  TextColumn get toWarehouse => text().nullable()(); // المستودع المستلم
  RealColumn get totalQuantities => real().withDefault(const Constant(0))();
}

// 11. جدول أقلام المناقلات (جديد - بدون أسعار)
class TransferLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transferId => integer().references(Transfers, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get productCode => text().nullable()();
  TextColumn get productName => text().nullable()();
  IntColumn get unitNumber => integer()();
  TextColumn get unitName => text().nullable()();
  RealColumn get quantity => real()();
}