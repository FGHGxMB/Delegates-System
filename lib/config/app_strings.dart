class AppStrings {
  // ─── عام ──────────────────────────────
  static const appName = 'المندوب التجاري';
  static const save = 'حفظ';
  static const cancel = 'إلغاء';
  static const delete = 'حذف';
  static const edit = 'تعديل';
  static const add = 'إضافة';
  static const confirm = 'تأكيد';
  static const search = 'بحث...';
  static const filter = 'تصفية';
  static const reset = 'إعادة تعيين';
  static const noData = 'لا توجد بيانات';
  static const loading = 'جارٍ التحميل...';
  static const error = 'حدث خطأ';
  static const success = 'تمت العملية بنجاح';
  static const warning = 'تحذير';
  static const yes = 'نعم';
  static const no = 'لا';
  static const close = 'إغلاق';
  static const back = 'رجوع';
  static const share = 'مشاركة';
  static const print = 'طباعة';

  // ─── الشاشة الرئيسية ──────────────────
  static const homeTitle = 'الشاشة الرئيسية';
  static const todaySummary = 'ملخص اليوم';
  static const exchangeRate = 'سعر الصرف';
  static const exchangeRateHint = 'ل.س لكل \$1';
  static const totalCashCollected = 'إجمالي النقد المحصّل';
  static const totalDebtCollected = 'إجمالي الديون المحصّلة';
  static const totalNewDebt = 'إجمالي الديون الجديدة';
  static const salesInvoicesCount = 'فواتير المبيعات';
  static const returnInvoicesCount = 'فواتير المرتجعات';
  static const receiptVouchersCount = 'سندات القبض';
  static const paymentVouchersCount = 'سندات الدفع';
  static const transfersCount = 'المناقلات المُخرجة'; // إضافة للمناقلات
  static const cashBoxSYP = 'الصندوق (ل.س)';
  static const cashBoxUSD = 'الصندوق (\$)';
  static const sendDailyReport = 'إرسال التقرير اليومي';
  static const sendDailyReportConfirm = 'هل تريد إرسال تقرير اليوم إلى المحاسب؟';

  // ─── الفواتير ─────────────────────────
  static const invoices = 'الفواتير';
  static const salesInvoice = 'فاتورة مبيعات';
  static const returnInvoice = 'فاتورة مرتجعات';
  static const newSalesInvoice = 'فاتورة مبيعات جديدة';
  static const newReturnInvoice = 'فاتورة مرتجعات جديدة';
  static const invoiceNumber = 'رقم الفاتورة';
  static const invoiceDate = 'تاريخ الفاتورة';
  static const customer = 'الزبون';
  static const selectCustomer = 'اختر الزبون';
  static const paymentMethod = 'طريقة الدفع';
  static const cash = 'نقدي';
  static const credit = 'آجل';
  static const currency = 'العملة';
  static const totalAmount = 'الإجمالي';
  static const discountAmount = 'الحسم';
  static const netAmount = 'الصافي';
  static const invoiceNote = 'ملاحظة الفاتورة';
  static const addProducts = 'إضافة مواد';
  static const scanBarcode = 'مسح باركود';
  static const invoiceDraft = 'مسودة';
  static const invoiceIssued = 'مُخرجة';
  static const invoiceSent = 'مُرسلة';
  static const issueInvoice = 'تخريج الفاتورة';
  static const cannotDeleteSentInvoice = 'لا يمكن حذف فاتورة مُرسلة';
  static const cannotEditSentInvoice = 'لا يمكن التعديل على فاتورة مُرسلة';
  static const lineNote = 'ملاحظة القلم';
  static const markAsGift = 'جعل المادة هدية';
  static const removeGift = 'إلغاء الهدية';
  static const giftItem = 'هدية';
  static const itemOptions = 'خيارات المادة';
  static const invoiceTotal = 'مجموع الفاتورة';
  static const quantity = 'الكمية';
  static const unit = 'الوحدة';
  static const price = 'السعر';
  static const autoLoadPrices = 'تحميل الأسعار تلقائياً';
  static const loadNextBarcode = 'تحميل مادة أخرى';
  static const noBarcodeFound = 'لم يُعثر على مادة بهذا الباركود';

  // ─── المناقلات (جديد) ─────────────────
  static const transfers = 'المناقلات';
  static const newTransfer = 'مناقلة جديدة';
  static const transferNumber = 'رقم المناقلة';
  static const transferDate = 'التاريخ';
  static const transferName = 'اسم المناقلة';
  static const totalQuantities = 'إجمالي الكميات';
  static const transferPrefix = 'مناقلة يوم';
  static const cannotEditSentTransfer = 'لا يمكن تعديل مناقلة مُرسلة';
  static const cannotDeleteSentTransfer = 'لا يمكن حذف مناقلة مُرسلة';

  // ─── السندات ─────────────────────────
  static const vouchers = 'السندات';
  static const receiptVoucher = 'سند قبض';
  static const paymentVoucher = 'سند دفع';
  static const newReceiptVoucher = 'سند قبض جديد';
  static const newPaymentVoucher = 'سند دفع جديد';
  static const voucherNumber = 'رقم السند';
  static const voucherDate = 'تاريخ السند';
  static const debitAccount = 'الحساب المدين';
  static const creditAccount = 'الحساب الدائن';
  static const amount = 'المبلغ';
  static const voucherNote = 'بيان السند';

  // ─── الزبائن ─────────────────────────
  static const customers = 'الزبائن';
  static const newCustomer = 'زبون جديد';
  static const customerName = 'اسم الزبون';
  static const accountCode = 'رمز الحساب';
  static const phone1 = 'الهاتف 1';
  static const phone2 = 'الهاتف 2';
  static const email = 'البريد الإلكتروني';
  static const notes = 'ملاحظات';
  static const city = 'المدينة';
  static const area = 'المنطقة';
  static const neighborhood = 'الحي';
  static const street = 'الشارع';
  static const gender = 'الجنس';
  static const male = 'ذكر';
  static const female = 'أنثى';
  static const selectCity = 'اختر المدينة';
  static const searchArea = 'ابحث أو اكتب المنطقة';
  static const customerMovement = 'حركة الحساب';
  static const customerInvoices = 'فواتير الزبون';
  static const totalPurchases = 'إجمالي المشتريات';

  // ─── المواد ──────────────────────────
  static const products = 'المواد';
  static const newProduct = 'مادة جديدة';
  static const productName = 'اسم المادة';
  static const productCode = 'رمز المادة';
  static const barcode = 'الباركود';
  static const category = 'المجموعة';
  static const newCategory = 'مجموعة جديدة';
  static const unit1 = 'الوحدة الأولى';
  static const unit2 = 'الوحدة الثانية';
  static const unit3 = 'الوحدة الثالثة';
  static const addUnit2 = 'إضافة وحدة ثانية';
  static const addUnit3 = 'إضافة وحدة ثالثة';
  static const conversionFactor2 = 'تساوي كم من الوحدة الأولى';
  static const conversionFactor3 = 'تساوي كم من الوحدة الأولى';
  static const priceRetail = 'سعر المستهلك';
  static const priceWholesale = 'سعر المحل';
  static const defaultUnit = 'الوحدة الافتراضية';
  static const productCurrency = 'عملة المادة';
  static const cannotDeleteUsedProduct = 'لا يمكن حذف مادة مستخدمة في فاتورة';
  static const wholesalePriceHint = 'الحد الأدنى';

  // ─── قوائم الأسعار (الوهمية/للمندوب فقط) ───
  static const priceLists = 'قوائم الأسعار';
  static const newPriceList = 'قائمة جديدة';
  static const priceListName = 'اسم القائمة';
  static const showPrices = 'إظهار الأسعار';
  static const showTotal = 'إظهار الإجمالي';
  static const shareAsImage = 'مشاركة كصورة';
  static const shareAsPdf = 'مشاركة كـ PDF';

  // ─── التقارير ────────────────────────
  static const reports = 'التقارير';
  static const inventoryMovement = 'جرد حركة المواد';
  static const totalSold = 'إجمالي المباع';
  static const totalReturned = 'إجمالي المرتجع';
  static const netSold = 'الصافي المباع';
  static const totalRevenue = 'إجمالي الإيرادات';
  static const fromDate = 'من تاريخ';
  static const toDate = 'إلى تاريخ';

  // ─── الإعدادات ───────────────────────
  static const settings = 'الإعدادات';
  static const defaultSettings = 'الإعدادات الافتراضية';
  static const warehouseCode = 'رمز المستودع';
  static const mainAccountCode = 'رمز الحساب الرئيسي';
  static const defaultCountry = 'الدولة الافتراضية';
  static const defaultCity = 'المدينة الافتراضية';
  static const accounts = 'الحسابات';
  static const addAccount = 'إضافة حساب';
  static const accountName = 'اسم الحساب';
  static const passwordRequired = 'أدخل كلمة السر للمتابعة';
  static const wrongPassword = 'كلمة السر غير صحيحة';
  static const cities = 'المدن';
  static const whatsappNumber = 'رقم الواتساب (المحاسب)';

  // ─── النسخ الاحتياطي ─────────────────
  static const backup = 'النسخ الاحتياطي';
  static const createBackup = 'إنشاء نسخة احتياطية';
  static const restoreBackup = 'استعادة نسخة احتياطية';
  static const backupList = 'النسخ الاحتياطية المتاحة';
  static const backupCreated = 'تم إنشاء النسخة الاحتياطية';
  static const restoreConfirm = 'سيتم حذف جميع البيانات الحالية واستعادة النسخة المختارة. هل تريد المتابعة؟';
  static const restoreSuccess = 'تمت الاستعادة بنجاح';
  static const backupFileName = 'اسم النسخة الاحتياطية';

  // ─── رسائل التحقق ────────────────────
  static const fieldRequired = 'هذا الحقل مطلوب';
  static const invalidNumber = 'أدخل رقماً صحيحاً';
  static const documentNoProducts = 'لا يمكن الحفظ بدون مواد';
  static const creditInvoiceNeedsCustomer = 'الفاتورة الآجلة تحتاج تحديد الزبون';
  static const currencyMismatch = 'عملة الفاتورة لا تتطابق مع عملة الزبون';

  // ─── المستودعات والإعدادات المحمية (تحديثات) ───
  static const protectedSettings = 'الإعدادات المتقدمة (محمية)';
  static const enterPasswordToSave = 'أدخل كلمة السر لحفظ التعديلات';
  static const warehouses = 'المستودعات (الرئيسية وسيارات المندوبين)';
  static const newWarehouse = 'إضافة مستودع';
  static const warehouseNameTitle = 'اسم المستودع';
  static const defaultWarehouse = 'المستودع الافتراضي للمندوب';
  static const fromWarehouse = 'من مستودع (المُسلِّم)';
  static const toWarehouse = 'إلى مستودع (المُستلِم)';
  static const selectFromWarehouse = 'اختر المستودع المُسلِّم';
  static const selectToWarehouse = 'اختر المستودع المُستلِم';
  static const transferWarehousesRequired = 'لا يمكن تخريج المناقلة دون تحديد المستودع المُسلِّم والمُستلِم';

  // ─── إعدادات المندوب والمجموعات (تحديثات) ───
  static const delegatePassword = 'كلمة سر المندوب (اختياري)';
  static const delegatePasswordHint = 'اترك الحقل فارغاً لإلغاء الصلاحية';
  static const manageCategories = 'إدارة المجموعات والمواد';
  static const gridColumnsCount = 'عدد الأعمدة لعرض المواد';

  // ─── المستودعات (إضافات) ───
  static const manageWarehouses = 'إدارة المستودعات';
  static const addWarehousePrompt = 'أدخل اسم المستودع الجديد (أو سيارة المندوب)';
  static const warehouseName = 'اسم المستودع';
  static const deleteWarehouseConfirm = 'هل أنت متأكد من حذف هذا المستودع؟';

  // ─── المجموعات (إضافات السحب والإفلات) ───
  static const editCategory = 'تعديل المجموعة';
  static const columnsCount = 'عدد الأعمدة';
  static const dragToReorder = 'اضغط مطولاً للسحب وتغيير الترتيب';
  static const categoryNotEmpty = 'لا يمكن حذف مجموعة تحتوي على مواد!';
  static const manageProducts = 'إدارة مواد المجموعة';

  // ─── المواد (إضافات) ───
  static const basicInfo = 'المعلومات الأساسية';
  static const enableUnit2 = 'تفعيل الوحدة الثانية';
  static const enableUnit3 = 'تفعيل الوحدة الثالثة';
  static const deleteProductConfirm = 'هل أنت متأكد من حذف هذه المادة نهائياً؟';

  // ─── شاشة إضافة المادة (الوحش) ───
  static const editProduct = 'تعديل المادة';
  static const productCurrencyWarning = 'لا يمكن تغيير عملة مادة مستخدمة في فواتير سابقة';

  // ─── الحسابات (إضافات) ───
  static const manageAccounts = 'إدارة الحسابات';
  static const systemAccount = 'حساب نظام';
  static const cannotDeleteSystemAccount = 'لا يمكن حذف حساب النظام لأنه أساسي للتطبيق';

  // ─── رسائل التحقق (جديد) ───
  static const nameAlreadyExists = 'هذا الاسم موجود مسبقاً!';
  static const codeAlreadyExists = 'هذا الرمز موجود مسبقاً!';
  static const cannotDeleteHasTransactions = 'لا يمكن الحذف! يوجد حركات مالية (فواتير/سندات) مرتبطة به.';
  static const mainAccountPrefix = 'رمز الحساب الرئيسي (يُدمج مع رمز الزبون في الإكسيل)';
  static const nameOrCodeExists = 'الاسم أو الرمز مستخدم مسبقاً، يرجى تغييره!';
}