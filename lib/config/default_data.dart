class DefaultData {
  static const List<String> cities =[
    'دمشق', 'ريف دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية', 'طرطوس', 'دير الزور', 'الرقة', 'الحسكة', 'القنيطرة', 'السويداء', 'درعا', 'إدلب',
  ];
  static const List<String> productCategories = ['الظروف', 'الأكيال', 'العلب والأكياس'];
  static const int defaultCityIndex = 0;
  static const String defaultCountry = 'سوريا';

  // ─── [جديد] رمز الحساب الرئيسي للزبائن ───
  static const String defaultMainAccountPrefix = '12101';

  static const List<Map<String, String>> defaultAccounts =[
    {'code': 'CASH_SYP', 'name': 'الصندوق (ل.س)', 'currency': 'SYP', 'type': 'CASH'},
    {'code': 'CASH_USD', 'name': 'الصندوق (\$)', 'currency': 'USD', 'type': 'CASH'},
    {'code': 'REV_MISC', 'name': 'إيرادات مختلفة', 'currency': 'BOTH', 'type': 'REVENUE'},
    {'code': 'EXP_MISC', 'name': 'مصروفات مختلفة', 'currency': 'BOTH', 'type': 'EXPENSE'},
  ];
}