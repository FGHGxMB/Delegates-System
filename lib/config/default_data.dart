class DefaultData {
  // ─── المدن الافتراضية ─────────────────
  static const List<String> cities = [
    'دمشق', 'ريف دمشق', 'حلب', 'حمص', 'حماة',
    'اللاذقية', 'طرطوس', 'دير الزور', 'الرقة',
    'الحسكة', 'القنيطرة', 'السويداء', 'درعا', 'إدلب',
  ];

  // ─── مجموعات المواد الافتراضية ───────
  static const List<String> productCategories = [
    'الظروف',
    'الأكيال',
    'العلب والأكياس',
  ];

  // ─── المدينة الافتراضية ──
  static const int defaultCityIndex = 0; // دمشق

  // ─── الدولة الافتراضية ───────────────
  static const String defaultCountry = 'سوريا';

  // ─── رمز المستودع الافتراضي ──────────
  static const String defaultWarehouseCode = 'W01';

  // ─── رمز الحساب الرئيسي للزبائن ──────
  static const String defaultMainAccountPrefix = '120';

  // ─── حسابات النظام الافتراضية ─────────
  static const List<Map<String, String>> defaultAccounts = [
    {'code': 'CASH_SYP', 'name': 'الصندوق (ل.س)', 'currency': 'SYP'},
    {'code': 'CASH_USD', 'name': 'الصندوق (\$)', 'currency': 'USD'},
    {'code': 'SALES',    'name': 'حساب المبيعات',  'currency': 'BOTH'},
    {'code': 'RETURNS',  'name': 'حساب المرتجعات', 'currency': 'BOTH'},
  ];

  // ─── إعدادات الفاتورة ────────────────
  static const bool defaultAutoLoadPrices = true;

  // ─── رقم واتساب المحاسب ──────────────
  static const String defaultAccountantWhatsApp = '+963900000000'; // يجب تعديله لاحقاً
}