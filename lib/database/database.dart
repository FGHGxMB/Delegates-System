import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// استيراد الجداول التي أنشأناها
import 'tables.dart';

// هذا السطر مهم جداً، يخبر Drift بكتابة كود التوليد في هذا الملف
part 'database.g.dart';

@DriftDatabase(tables: [
  Settings,
  Warehouses,
  Customers,
  ProductCategories,
  Products,
  Accounts,
  Invoices,
  InvoiceLines,
  Vouchers,
  Transfers,
  TransferLines,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // إعدادات تفعيل مفاتيح الربط (Foreign Keys)
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

// دالة تحديد مسار قاعدة البيانات في الهاتف
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    // اسم ملف قاعدة البيانات
    final file = File(p.join(dbFolder.path, 'delegates_app.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}