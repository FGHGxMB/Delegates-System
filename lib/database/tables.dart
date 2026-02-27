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
  TextColumn get accountCode => text().unique()(); // أصبح يخزن فقط (001, 002)
  TextColumn get name => text()();
  TextColumn get currency => text()();
  TextColumn get phone1 => text().nullable()();
  TextColumn get phone2 => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get country => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get area => text().nullable()();
  TextColumn get neighborhood => text().nullable()();
  TextColumn get street => text().nullable()();
  TextColumn get gender => text()();
  BoolColumn get isSent => boolean().withDefault(const Constant(false))();
  BoolColumn get isModified => boolean().withDefault(const Constant(false))(); // [جديد] للتفريق في الإكسيل
  DateTimeColumn get createdAt => dateTime().nullable()();
}

// 4. جدول مجموعات المواد
class ProductCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get gridColumns => integer().withDefault(const Constant(2))();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
}

// 5. جدول المواد
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  IntColumn get categoryId => integer().references(ProductCategories, #id)();
  IntColumn get columnId => integer().nullable().customConstraint('REFERENCES product_columns(id)')();
  TextColumn get name => text()();
  TextColumn get currency => text()(); // 'SYP' أو 'USD'

  // الوحدة الأولى
  TextColumn get unit1Name => text()();
  TextColumn get unit1Barcode => text().nullable()(); // [جديد] باركود الوحدة الأولى
  RealColumn get unit1PriceRetail => real().withDefault(const Constant(0))();
  RealColumn get unit1PriceWholesale => real().withDefault(const Constant(0))();

  // الوحدة الثانية
  TextColumn get unit2Name => text().nullable()();
  TextColumn get unit2Barcode => text().nullable()(); // [جديد] باركود الوحدة الثانية
  RealColumn get unit2Factor => real().nullable()();
  RealColumn get unit2PriceRetail => real().nullable()();
  RealColumn get unit2PriceWholesale => real().nullable()();

  // الوحدة الثالثة
  TextColumn get unit3Name => text().nullable()();
  TextColumn get unit3Barcode => text().nullable()(); //[جديد] باركود الوحدة الثالثة
  RealColumn get unit3Factor => real().nullable()();
  RealColumn get unit3PriceRetail => real().nullable()();
  RealColumn get unit3PriceWholesale => real().nullable()();

  IntColumn get defaultUnit => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
}

// 6. جدول الحسابات (الصناديق وحسابات النظام والمصاريف)
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  TextColumn get currency => text()(); // 'SYP', 'USD', 'BOTH'
  TextColumn get accountType => text().withDefault(const Constant('GENERAL'))(); // 'CASH', 'EXPENSE', 'REVENUE', 'GENERAL'
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))(); // للترتيب والسحب
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

  // المادة الظاهرة في الفاتورة للزبون
  IntColumn get productId => integer().references(Products, #id)();
  TextColumn get productCode => text().nullable()();
  TextColumn get productName => text().nullable()();

  // [جديد] المادة الحقيقية (التي سُلمت فعلياً) - فارغة إذا لم يتم التبديل
  IntColumn get realProductId => integer().nullable().references(Products, #id)();
  TextColumn get realProductCode => text().nullable()();
  TextColumn get realProductName => text().nullable()();

  IntColumn get unitNumber => integer()();
  TextColumn get unitName => text().nullable()();
  RealColumn get quantity => real()();
  RealColumn get price => real()();

  // لقطة لأسعار المادة وقت الفاتورة (للمرجعية والتحليلات)
  RealColumn get priceRetailSnapshot => real().nullable()();
  RealColumn get priceWholesaleSnapshot => real().nullable()();

  BoolColumn get isGift => boolean().withDefault(const Constant(false))();
  TextColumn get lineNote => text().nullable()();
  IntColumn get lineOrder => integer().nullable()();
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

// 12. جدول العواميد الخاصة بالمواد
class ProductColumns extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().customConstraint('REFERENCES product_categories(id)')(); // ارتباط بالمجموعة
  TextColumn get name => text()();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))(); // ميزة الإخفاء
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
}