import 'package:drift/drift.dart';
import '../database.dart';

// ============================================================================
// 1. هياكل البيانات (Data Classes) لتسهيل كتابة "القاموس"
// ============================================================================
class SeedCategory {
  final String name;
  final int gridColumns;
  final List<SeedColumn> columns;

  SeedCategory({
    required this.name,
    this.gridColumns = 2,
    required this.columns,
  });
}

class SeedColumn {
  final String name;
  final List<SeedProduct> products;

  SeedColumn({required this.name, required this.products});
}

class SeedProduct {
  final String code;
  final String name;
  final String currency;
  final int defaultUnit; // 👈 لتحديد الوحدة الافتراضية للبيع

  // الوحدة 1 (إجبارية)
  final String unit1Name;
  final String? unit1Barcode;
  final double unit1PriceRetail;
  final double unit1PriceWholesale;

  // الوحدة 2 (اختيارية)
  final String? unit2Name;
  final String? unit2Barcode;
  final double? unit2Factor;
  final double? unit2PriceRetail;
  final double? unit2PriceWholesale;

  // الوحدة 3 (اختيارية)
  final String? unit3Name;
  final String? unit3Barcode;
  final double? unit3Factor;
  final double? unit3PriceRetail;
  final double? unit3PriceWholesale;

  SeedProduct({
    required this.code,
    required this.name,
    this.currency = 'SYP',
    this.defaultUnit = 1, // افتراضياً ستكون الوحدة الأولى هي التي تظهر للبيع

    required this.unit1Name,
    this.unit1Barcode,
    required this.unit1PriceRetail,
    this.unit1PriceWholesale = 0,

    this.unit2Name,
    this.unit2Barcode,
    this.unit2Factor,
    this.unit2PriceRetail = 0,
    this.unit2PriceWholesale = 0,

    this.unit3Name,
    this.unit3Barcode,
    this.unit3Factor,
    this.unit3PriceRetail = 0,
    this.unit3PriceWholesale = 0,
  });
}

// ============================================================================
// 2. محرك الإدخال (Database Seeder)
// ============================================================================
class DatabaseSeeder {
  final AppDatabase db;

  DatabaseSeeder(this.db);

  // --------------------------------------------------------------------------
  // 📖 القاموس الخاص بك (ضع كل موادك هنا بترتيب مريح للعين)
  // --------------------------------------------------------------------------
  final List<SeedCategory> _initialData = [
    // 📦 المجموعة الأولى
    SeedCategory(
      name: 'الظروف',
      gridColumns: 3,
      columns: [
        // 🗂️ العمود الأول
        SeedColumn(name: 'العمود الأول', products: [
          SeedProduct(code: '001', name: 'ظرف صنوبر 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013001', unit1PriceRetail: 8000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 48000, ),
          SeedProduct(code: '002', name: 'ظرف فستق 20غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013002', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '003', name: 'ظرف حبة الهال 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013004', unit1PriceRetail: 5000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 30000, ),
          SeedProduct(code: '004', name: 'ظرف هيل ناعم 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013005', unit1PriceRetail: 5000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 30000, ),
          SeedProduct(code: '005', name: 'ظرف محلب حب 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013006', unit1PriceRetail: 5000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 30000, ),
          SeedProduct(code: '006', name: 'ظرف محلب ناعم 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013007', unit1PriceRetail: 5000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 30000, ),
          SeedProduct(code: '007', name: 'ظرف جوزة الطيب 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013008', unit1PriceRetail: 3500, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 21000, ),
          SeedProduct(code: '008', name: 'ظرف جوزة الطيب ناعم 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013009', unit1PriceRetail: 3500, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 21000, ),
          SeedProduct(code: '009', name: 'ظرف فلفل ابيض 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013010', unit1PriceRetail: 3000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 18000, ),
          SeedProduct(code: '010', name: 'ظرف كبش قرنفل 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013011', unit1PriceRetail: 4000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 24000, ),
          SeedProduct(code: '011', name: 'ظرف قرنفل ناعم 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013012', unit1PriceRetail: 4000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 24000, ),
          SeedProduct(code: '012', name: 'ظرف كاجو 20غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013014', unit1PriceRetail: 4000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 24000, ),
          SeedProduct(code: '013', name: 'ظرف زنجبيل ناعم 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013015', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '014', name: 'ظرف زنجبيل حب 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013016', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '015', name: 'ظرف عصفر 7غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013017', unit1PriceRetail: 2500, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 15000, ),
          SeedProduct(code: '016', name: 'ظرف لوز حب 20غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013018', unit1PriceRetail: 4000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 24000, ),
          SeedProduct(code: '017', name: 'ظرف لوز مقشور 20غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013019', unit1PriceRetail: 4000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 24000, ),
          SeedProduct(code: '018', name: 'ظرف ملح صيني 20غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013020', unit1PriceRetail: 1000, unit2Name: 'طرد', unit2Factor: 15, unit2PriceRetail: 15000, ),
          SeedProduct(code: '019', name: 'ظرف ليمون اسود 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013021', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 20000, ),
          SeedProduct(code: '020', name: 'ظرف ليمون يابس 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013022', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 20000, ),
          SeedProduct(code: '021', name: 'ظرف فلفل اسود 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013023', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 20000, ),
          SeedProduct(code: '022', name: 'ظرف فلفل حب 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013024', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 20000, ),
          SeedProduct(code: '023', name: 'ظرف خولنجان حب 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013025', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '195', name: 'ظرف خولنجان ناعم 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013026', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '024', name: 'ظرف نكهة الجبنة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013027', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '025', name: 'ظرف نكهة الخل 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013028', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '026', name: 'ظرف نكهة الكتشب 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013029', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '029', name: 'ظرف صفار البيض 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013084', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 20000, ),
          SeedProduct(code: '030', name: 'ظرف صفار الزعفران 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013085', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 20000, ),
          SeedProduct(code: '031', name: 'ظرف ورق غار 10غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013086', unit1PriceRetail: 1000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 10000, ),
        ]),

        // 🗂️ العمود الثاني
        SeedColumn(name: 'العمود الثاني', products: [
          SeedProduct(code: '032', name: 'ظرف فليفة حمرا 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013033', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '033', name: 'ظرف شطة حدة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013034', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '034', name: 'ظرف شطة حمرا 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013035', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '035', name: 'ظرف حبة البركة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013036', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '036', name: 'ظرف قرفة عيدان 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013037', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '037', name: 'ظرف قرفة ناعمة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013038', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '038', name: 'ظرف نعنع يابس 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013039', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '039', name: 'ظرف خميرة 20غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013040', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 9000, ),
          SeedProduct(code: '040', name: 'ظرف اشلميش 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013041', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '041', name: 'ظرف سماق 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013042', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '042', name: 'ظرف كركم/ورص 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013043', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '043', name: 'ظرف جوز هند 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013044', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 20000, ),
          SeedProduct(code: '044', name: 'ظرف يانسون حب 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013045', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '045', name: 'ظرف يانسون ناعم 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013046', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '046', name: 'ظرف كاكاو 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013047', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '047', name: 'ظرف شمرا ناعمة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013048', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '048', name: 'ظرف شمر حب 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013049', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '049', name: 'ظرف كعك مطحون 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013050', unit1PriceRetail: 0, unit2Name: 'طرد', unit2Factor: 10, ),
          SeedProduct(code: '050', name: 'ظرف اوريكانوا 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013051', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '051', name: 'ظرف ذرة بوشار 50غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013052', unit1PriceRetail: 1000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 10000, ),
          SeedProduct(code: '052', name: 'ظرف قلي 25غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013053', unit1PriceRetail: 1000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 10000, ),
          SeedProduct(code: '053', name: 'ظرف كربونة 25غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013054', unit1PriceRetail: 1000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 10000, ),
          SeedProduct(code: '054', name: 'ظرف كمون ناعم 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013055', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '055', name: 'ظرف كمون حب 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013056', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '056', name: 'ظرف سمسم 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013057', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 20000, ),
          SeedProduct(code: '057', name: 'ظرف سكر نبات 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013058', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '058', name: 'ظرف كزبرة ناعمة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013059', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '059', name: 'ظرف كزبرة حب 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013060', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '064', name: 'ظرف حمض الليمون 20غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013090', unit1PriceRetail: 1000, unit2Name: 'طرد', unit2Factor: 15, unit2PriceRetail: 15000, ),
          SeedProduct(code: '065', name: 'ظرف نشاء ناعم 40غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013087', unit1PriceRetail: 1000, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 10000, ),
          SeedProduct(code: '066', name: 'ظرف نشاء حب 35غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013088', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
        ]),

        // 🗂️ العمود الثالث
        SeedColumn(name: 'الهمود الثالث', products: [
          SeedProduct(code: '067', name: 'ظرف كاري 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013063', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '068', name: 'ظرف بهارات كبسة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013064', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '069', name: 'ظرف بهارات سمك 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013065', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '070', name: 'ظرف بهارات بيضاء 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013066', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '071', name: 'ظرف بهارات شيش 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013067', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '072', name: 'ظرف بهارات فروج 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013068', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '073', name: 'ظرف بهارات شاورما 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013069', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '074', name: 'ظرف بهارات دجاج 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013070', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '075', name: 'ظرف بهارات الاوزي 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013071', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '076', name: 'ظرف بهارات ماجي 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013072', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '077', name: 'ظرف بهارات سجق 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013073', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '078', name: 'ظرف بهارات كبة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013074', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '079', name: 'ظرف بهارات لحمة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013075', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '080', name: 'ظرف بهارات برياني 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013076', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '081', name: 'ظرف بهارات فلافل 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013077', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '082', name: 'ظرف بهارات مشاوي 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013078', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '083', name: 'ظرف بهارات بيتزا 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013079', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '084', name: 'ظرف بهارات مشكلة 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013080', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '085', name: 'ظرف بهارات مندي 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013081', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '086', name: 'ظرف بهارات بطاطا 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013082', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '087', name: 'ظرف بهارات بروستد 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1Barcode: '748013083', unit1PriceRetail: 1500, unit2Name: 'طرد', unit2Factor: 10, unit2PriceRetail: 15000, ),
          SeedProduct(code: '088', name: 'ظرف كبسة خليجية 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '089', name: 'ظرف حلبة 25غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1PriceRetail: 2000, unit2Name: 'طرد', unit2Factor: 6, unit2PriceRetail: 12000, ),
          SeedProduct(code: '181', name: 'ظرف بصل 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1PriceRetail: 0, unit2Name: 'طرد', unit2Factor: 10, ),
          SeedProduct(code: '182', name: 'ظرف ثوم 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1PriceRetail: 0, unit2Name: 'طرد', unit2Factor: 10, ),
          SeedProduct(code: '193', name: 'ظرف باربيكيو 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1PriceRetail: 0, unit2Name: 'طرد', unit2Factor: 6, ),
          SeedProduct(code: '192', name: 'ظرف ببريكا 15غ', currency: 'SYP', defaultUnit: 2, unit1Name: 'ظرف', unit1PriceRetail: 0, unit2Name: 'طرد', unit2Factor: 10, ),
        ]),
      ],
    ),

    // 📦 المجموعة الثانية
    SeedCategory(
      name: 'الأكيال',
      gridColumns: 3,
      columns: [
        // 🗂️ العمود الأول
        SeedColumn(name: 'العمود الأول', products: [
          SeedProduct(code: '090', name: 'كيلو صنوبر', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '091', name: 'كيلو فستق', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 2,),
          SeedProduct(code: '092', name: 'كيلو حبة الهال', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 36,),
          SeedProduct(code: '093', name: 'كيلو هيل ناعم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 36,),
          SeedProduct(code: '094', name: 'كيلو محلب حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 33,),
          SeedProduct(code: '095', name: 'كيلو محلب ناعم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 33,),
          SeedProduct(code: '096', name: 'كيلو جوزة الطيب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 12,),
          SeedProduct(code: '097', name: 'كيلو جوزة الطيب ناعم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 12,),
          SeedProduct(code: '098', name: 'كيلو فلفل ابيض', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 15,),
          SeedProduct(code: '099', name: 'كيلو كبش قرنفل', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 12,),
          SeedProduct(code: '100', name: 'كيلو قرنفل ناعم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 12,),
          SeedProduct(code: '101', name: 'كيلو جوز', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 6.5,),
          SeedProduct(code: '102', name: 'كيلو كاجو', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 9,),
          SeedProduct(code: '103', name: 'كيلو زنجبيل ناعم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 5.25,),
          SeedProduct(code: '104', name: 'كيلو زنجبيل حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 5,),
          SeedProduct(code: '105', name: 'كيلو عصفر', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 14,),
          SeedProduct(code: '106', name: 'كيلو لوز حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 9.5,),
          SeedProduct(code: '107', name: 'كيلو لوز مقشور', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 9.9,),
          SeedProduct(code: '108', name: 'كيلو ملح صيني', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 1.5,),
          SeedProduct(code: '109', name: 'كيلو ليمون اسود', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4,),
          SeedProduct(code: '110', name: 'كيلو ليمون يابس', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '111', name: 'كيلو فلفل اسود', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 8,),
          SeedProduct(code: '112', name: 'كيلو فلفل حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 7.5,),
          SeedProduct(code: '113', name: 'كيلو خولنجان حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 5,),
          SeedProduct(code: '114', name: 'كيلو خولنجان ناعم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 5,),
          SeedProduct(code: '115', name: 'كيلو نكهة الجبنة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 6,),
          SeedProduct(code: '116', name: 'كيلو نكهة الخل', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 6,),
          SeedProduct(code: '117', name: 'كيلو نكهة الكتشب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 6,),
          SeedProduct(code: '118', name: 'كيلو صفار البيض', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 6,),
          SeedProduct(code: '119', name: 'كيلو صفار الزعفران', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 6,),
          SeedProduct(code: '120', name: 'كيلو ورق غار', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 2.5,),
        ]),

        // 🗂️ العمود الثاني
        SeedColumn(name: 'العمود الثاني', products: [
          SeedProduct(code: '121', name: 'كيلو فليفة حمرا', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4,),
          SeedProduct(code: '122', name: 'كيلو شطة حدة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4,),
          SeedProduct(code: '123', name: 'كيلو شطة حمرا', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '124', name: 'كيلو حبة البركة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4.2,),
          SeedProduct(code: '125', name: 'كيلو قرفة عيدان', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.7,),
          SeedProduct(code: '126', name: 'كيلو قرفة ناعمة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.7,),
          SeedProduct(code: '127', name: 'كيلو نعنع يابس', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '128', name: 'كيلو خميرة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '129', name: 'كيلو اشلميش', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4,),
          SeedProduct(code: '130', name: 'كيلو سماق', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 5,),
          SeedProduct(code: '131', name: 'كيلو كركم/ورص', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '132', name: 'كيلو جوز هند', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4.9,),
          SeedProduct(code: '133', name: 'كيلو يانسون حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4,),
          SeedProduct(code: '134', name: 'كيلو يانسون ناعم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4,),
          SeedProduct(code: '135', name: 'كيلو كاكاو', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 6,),
          SeedProduct(code: '136', name: 'كيلو شمرا ناعمة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '137', name: 'كيلو شمر حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '138', name: 'كيلو كعك مطحون', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '139', name: 'كيلو اوريكانوا', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4.5,),
          SeedProduct(code: '140', name: 'كيلو ذرة بوشار', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 0.8,),
          SeedProduct(code: '141', name: 'كيلو قلي', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 0.8,),
          SeedProduct(code: '142', name: 'كيلو كربونة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 0.8,),
          SeedProduct(code: '143', name: 'كيلو كمون ناعم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4.5,),
          SeedProduct(code: '144', name: 'كيلو كمون حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4.7,),
          SeedProduct(code: '145', name: 'كيلو سمسم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 2.5,),
          SeedProduct(code: '146', name: 'كيلو سكر نبات', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 5.25,),
          SeedProduct(code: '147', name: 'كيلو كزبرة ناعمة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 1.8,),
          SeedProduct(code: '148', name: 'كيلو كزبرة حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 1.8,),
          SeedProduct(code: '185', name: 'كيلو ملوخية', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '149', name: 'كيلو حمض الليمون', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 1,),
          SeedProduct(code: '150', name: 'كيلو نشاء ناعم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 0.7,),
          SeedProduct(code: '151', name: 'كيلو نشاء حب', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 0.94,),
        ]),

        // 🗂️ العمود الثالث
        SeedColumn(name: 'الهمود الثالث', products: [
          SeedProduct(code: '152', name: 'كيلو كاري', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.3,),
          SeedProduct(code: '153', name: 'كيلو بهارات كبسة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.3,),
          SeedProduct(code: '154', name: 'كيلو بهارات سمك', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.3,),
          SeedProduct(code: '155', name: 'كيلو بهارات بيضاء', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.3,),
          SeedProduct(code: '156', name: 'كيلو بهارات شيش', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.3,),
          SeedProduct(code: '157', name: 'كيلو بهارات فروج', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.3,),
          SeedProduct(code: '158', name: 'كيلو بهارات شاورما', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.3,),
          SeedProduct(code: '159', name: 'كيلو بهارات دجاج', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.3,),
          SeedProduct(code: '160', name: 'كيلو بهارات الاوزي', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '161', name: 'كيلو بهارات ماجي', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 1.8,),
          SeedProduct(code: '162', name: 'كيلو بهارات سجق', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '163', name: 'كيلو بهارات كبة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '164', name: 'كيلو بهارات لحمة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '165', name: 'كيلو بهارات برياني', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3,),
          SeedProduct(code: '166', name: 'كيلو بهارات فلافل', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3,),
          SeedProduct(code: '167', name: 'كيلو بهارات مشاوي', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '168', name: 'كيلو بهارات بيتزا', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4.5,),
          SeedProduct(code: '169', name: 'كيلو بهارات مشكلة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4,),
          SeedProduct(code: '170', name: 'كيلو بهارات مندي', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '171', name: 'كيلو بهارات بطاطا', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.7,),
          SeedProduct(code: '172', name: 'كيلو بهارات بروستد', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 3.5,),
          SeedProduct(code: '173', name: 'كيلو كبسة خليجية', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '174', name: 'كيلو حلبة', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '175', name: 'كيلو شيبس', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 1.4,),
          SeedProduct(code: '176', name: 'كيلو شوفان', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '177', name: 'كيلو بصل', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4.5,),
          SeedProduct(code: '178', name: 'كيلو ثوم', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, unit1PriceWholesale: 4.5,),
          SeedProduct(code: '183', name: 'كيلو شطة صيني', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '187', name: 'كيلو زعتر', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '194', name: 'كيلو باربيكيو', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
          SeedProduct(code: '191', name: 'كيلو ببريكا', currency: 'USD', unit1Name: 'كغ', unit1PriceRetail: 0, ),
        ]),
      ],
    ),

    // 📦 المجموعة الثالثة
    SeedCategory(
      name: 'العلب و الأكياس',
      gridColumns: 1,
      columns: [
        // 🗂️ العمود الأول
        SeedColumn(name: 'العمود الأول', products: [
          SeedProduct(code: '061', name: 'كيس ملوخية 150غ', currency: 'SYP', unit1Name: 'كيس', unit1Barcode: '748013094', unit1PriceRetail: 0, unit1PriceWholesale: 17000,),
          SeedProduct(code: '062', name: 'كيس ملوخية 200غ', currency: 'SYP', unit1Name: 'كيس', unit1Barcode: '748013093', unit1PriceRetail: 0, unit1PriceWholesale: 19500,),
          SeedProduct(code: '063', name: 'علبة ملوخية 150غ', currency: 'SYP', unit1Name: 'علبة', unit1Barcode: '748013091', unit1PriceRetail: 0, unit1PriceWholesale: 19000,),
          SeedProduct(code: '027', name: 'كيس بابونج 50غ', currency: 'SYP', unit1Name: 'كيس', unit1Barcode: '748013031', unit1PriceRetail: 0, unit1PriceWholesale: 9000,),
          SeedProduct(code: '028', name: 'كيس زهورات مشكلة 80غ', currency: 'SYP', unit1Name: 'كيس', unit1Barcode: '748013092', unit1PriceRetail: 0, unit1PriceWholesale: 5000,),
          SeedProduct(code: '189', name: 'كيس مليسة 80غ', currency: 'SYP', unit1Name: 'كيس', unit1Barcode: '748013089', unit1PriceRetail: 0, unit1PriceWholesale: 7000,),
          SeedProduct(code: '188', name: 'كيس كركديه 50غ', currency: 'SYP', unit1Name: 'كيس', unit1PriceRetail: 0, unit1PriceWholesale: 8000,),
        ]),
      ],
    ),
  ];

  // --------------------------------------------------------------------------
  // ⚙️ محرك الإدخال الأوتوماتيكي (لا تعدل هنا شيء، هو يقرأ القاموس ويدخله)
  // --------------------------------------------------------------------------
  Future<void> seedInitialData() async {
    await db.transaction(() async {
      int categoryOrder = 0; // عداد لترتيب المجموعات

      for (var cat in _initialData) {
        // إدخال المجموعة
        final catId = await db
            .into(db.productCategories)
            .insert(
              ProductCategoriesCompanion.insert(
                name: cat.name,
                gridColumns: Value(cat.gridColumns),
                displayOrder: Value(categoryOrder),
                isVisible: const Value(true),
              ),
            );

        int columnOrder = 0; // عداد لترتيب الأعمدة داخل المجموعة

        for (var col in cat.columns) {
          // إدخال العمود
          final colId = await db
              .into(db.productColumns)
              .insert(
                ProductColumnsCompanion.insert(
                  categoryId: catId,
                  name: col.name,
                  displayOrder: Value(columnOrder),
                  isVisible: const Value(true),
                ),
              );

          int productOrder = 0; // عداد لترتيب المواد داخل العمود

          for (var prod in col.products) {
            // إدخال المادة
            await db
                .into(db.products)
                .insert(
                  ProductsCompanion.insert(
                    categoryId: catId,
                    columnId: Value(colId),
                    displayOrder: Value(productOrder),

                    code: prod.code,
                    name: prod.name,
                    currency: prod.currency,
                    defaultUnit: Value(prod.defaultUnit),
                    // 👈 تحديد الوحدة الافتراضية
                    isActive: const Value(true),

                    // الوحدة الأولى
                    unit1Name: prod.unit1Name,
                    unit1Barcode: Value(prod.unit1Barcode),
                    unit1PriceRetail: Value(prod.unit1PriceRetail),
                    unit1PriceWholesale: Value(prod.unit1PriceWholesale),

                    // الوحدة الثانية (نتحقق إن كانت موجودة)
                    unit2Name: Value(prod.unit2Name),
                    unit2Barcode: Value(prod.unit2Barcode),
                    unit2Factor: Value(prod.unit2Factor),
                    unit2PriceRetail: Value(prod.unit2PriceRetail),
                    unit2PriceWholesale: Value(prod.unit2PriceWholesale),

                    // الوحدة الثالثة
                    unit3Name: Value(prod.unit3Name),
                    unit3Barcode: Value(prod.unit3Barcode),
                    unit3Factor: Value(prod.unit3Factor),
                    unit3PriceRetail: Value(prod.unit3PriceRetail),
                    unit3PriceWholesale: Value(prod.unit3PriceWholesale),
                  ),
                );

            productOrder++; // زيادة ترتيب المادة
          }
          columnOrder++; // زيادة ترتيب العمود
        }
        categoryOrder++; // زيادة ترتيب المجموعة
      }
    }); // نهاية الـ Transaction
  }
}
