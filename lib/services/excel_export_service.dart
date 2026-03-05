import 'dart:io';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../providers/database_provider.dart';
import '../database/daos/settings_dao.dart';

class ExcelExportService {
  final AppDatabase db;
  final SettingsDao settingsDao;

  ExcelExportService(this.db, this.settingsDao);

  Future<File> generateAndExportExcel() async {
    final delegateName = await settingsDao.getValue('delegate_name') ?? 'مندوب';
    final costCenter = await settingsDao.getValue('delegate_cost_center_code') ?? '';
    final sypBox = await settingsDao.getValue('delegate_syp_box_code') ?? '';
    final usdBox = await settingsDao.getValue('delegate_usd_box_code') ?? '';
    final mainAccountPrefix = await settingsDao.getValue('main_account_prefix') ?? '';
    final countryName = await settingsDao.getValue('country_name') ?? '';
    final customerCodePrefix = await settingsDao.getValue('customer_account_code_prefix') ?? '';
    final customerNamePrefix = await settingsDao.getValue('customer_account_name_prefix') ?? '';
    final defaultWarehouse = await settingsDao.getValue('default_warehouse_code') ?? '';
    final password = await settingsDao.getValue('custom_delegate_password') ?? '';

    final invoices = await (db.select(db.invoices)..where((t) => t.status.equals('ISSUED'))).get();
    final invoiceIds = invoices.map((e) => e.id).toList();

    List<InvoiceLine> allLines =[];
    if (invoiceIds.isNotEmpty) {
      allLines = await (db.select(db.invoiceLines)..where((t) => t.invoiceId.isIn(invoiceIds))).get();
    }

    final vouchers = await (db.select(db.vouchers)..where((t) => t.status.equals('ISSUED'))).get();

    // 🔴 التعديل هنا: جلب الزبائن الجدد (isSent == false) أو المعدلين (isModified == true) 🔴
    final customers = await (db.select(db.customers)
      ..where((t) => t.isSent.equals(false) | t.isModified.equals(true))
    ).get();

    final transfers = await (db.select(db.transfers)..where((t) => t.status.equals('ISSUED'))).get();
    final transferIds = transfers.map((e) => e.id).toList();
    List<TransferLine> transferLines =[];
    if (transferIds.isNotEmpty) {
      transferLines = await (db.select(db.transferLines)..where((t) => t.transferId.isIn(transferIds))).get();
    }

    var excel = Excel.createExcel();
    excel.delete('Sheet1');

    void createHeader(Sheet sheet, List<String> headers) {
      sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());
      for (int i = 0; i < headers.length; i++) {
        var cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.cellStyle = CellStyle(bold: true, horizontalAlign: HorizontalAlign.Center);
      }
    }

    // --- Sheet 1: Dashboard ---
    var dashSheet = excel['الملخص'];
    dashSheet.isRTL = true;

    // حساب مجاميع الليرة السورية
    double cashSyp = invoices.where((i) => i.paymentMethod == 'CASH' && i.currency == 'SYP').fold(0.0, (sum, i) => sum + i.total);
    double creditSyp = invoices.where((i) => i.paymentMethod == 'CREDIT' && i.currency == 'SYP').fold(0.0, (sum, i) => sum + i.total);
    double receiptSyp = vouchers.where((v) => v.type == 'RECEIPT' && v.currency == 'SYP').fold(0.0, (sum, v) => sum + v.amount);
    double paymentSyp = vouchers.where((v) => v.type == 'PAYMENT' && v.currency == 'SYP').fold(0.0, (sum, v) => sum + v.amount);

    // حساب مجاميع الدولار
    double cashUsd = invoices.where((i) => i.paymentMethod == 'CASH' && i.currency == 'USD').fold(0.0, (sum, i) => sum + i.total);
    double creditUsd = invoices.where((i) => i.paymentMethod == 'CREDIT' && i.currency == 'USD').fold(0.0, (sum, i) => sum + i.total);
    double receiptUsd = vouchers.where((v) => v.type == 'RECEIPT' && v.currency == 'USD').fold(0.0, (sum, v) => sum + v.amount);
    double paymentUsd = vouchers.where((v) => v.type == 'PAYMENT' && v.currency == 'USD').fold(0.0, (sum, v) => sum + v.amount);

    // إنشاء الترويسة للعملتين
    createHeader(dashSheet,['البيان', 'ليرة سورية (SYP)', 'دولار أمريكي (USD)']);

    // تعبئة البيانات المفصلة
    dashSheet.appendRow([TextCellValue('إجمالي الفواتير النقدية'), DoubleCellValue(cashSyp), DoubleCellValue(cashUsd)]);
    dashSheet.appendRow([TextCellValue('إجمالي الفواتير الآجلة'), DoubleCellValue(creditSyp), DoubleCellValue(creditUsd)]);
    dashSheet.appendRow([TextCellValue('إجمالي مقبوضات السندات'), DoubleCellValue(receiptSyp), DoubleCellValue(receiptUsd)]);
    dashSheet.appendRow([TextCellValue('إجمالي مدفوعات السندات'), DoubleCellValue(paymentSyp), DoubleCellValue(paymentUsd)]);

    // سطر فارغ للترتيب
    dashSheet.appendRow([TextCellValue(''), TextCellValue(''), TextCellValue('')]);

    // إحصائيات عامة (أرقام فقط وليس مبالغ)
    dashSheet.appendRow([TextCellValue('إجمالي الفواتير المُصدرة (عدد)'), IntCellValue(invoices.length), TextCellValue('')]);
    dashSheet.appendRow([TextCellValue('عدد المناقلات المُصدرة (عدد)'), IntCellValue(transfers.length), TextCellValue('')]);
    dashSheet.appendRow([TextCellValue('عدد الزبائن الجدد/المعدلين (عدد)'), IntCellValue(customers.length), TextCellValue('')]);

    String getAccountCode(Invoice invoice) {
      if (invoice.paymentMethod == 'CASH') return invoice.currency == 'SYP' ? sypBox : usdBox;
      // في حال الزبون قديم ولم يتم استدعاؤه في الـ Query، نبحث عنه بشكل آمن
      final customer = customers.firstWhere((c) => c.id == invoice.customerId, orElse: () => const CustomersCompanion() as Customer);
      return customer.id != null ? '$customerCodePrefix${customer.accountCode}' : 'زبون غير محدد';
    }

    String getCustomerName(Invoice invoice) {
      if (invoice.customerId == null) return '';
      final customer = customers.firstWhere((c) => c.id == invoice.customerId, orElse: () => const CustomersCompanion() as Customer);
      return customer.name ?? '';
    }

    // --- Sheet 2 & 3 & 4: Sales, Returns, Gifts ---
    void processInvoiceLines(Sheet sheet, String type, bool isGift) {
      final headers =[
        'رقم الفاتورة', 'تاريخ الفاتورة', 'رمز الحساب', 'اسم الزبون', 'رمز المستودع',
        'رمز المادة', 'الكمية', 'الوحدة', 'السعر', 'طريقة الدفع', 'رمز العملة', 'البيان', 'مركز الكلفة'
      ];
      createHeader(sheet, headers);
      sheet.isRTL = true;

      for (var invoice in invoices.where((i) => i.type == type)) {
        final lines = allLines.where((l) => l.invoiceId == invoice.id && (isGift ? (l.price == 0 || l.isGift) : (l.price > 0 && !l.isGift)));

        String accountCode = getAccountCode(invoice);
        String customerName = getCustomerName(invoice);
        String baseStatement = '${invoice.invoiceNumber} - ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now())}';
        int payMethodCode = invoice.paymentMethod == 'CASH' ? 0 : 1;

        for (var line in lines) {
          // 🔴 التعديل هنا: معالجة المادة المخادعة (البديلة) 🔴
          String exportedProductCode = line.productCode ?? '';
          String exportedStatement = baseStatement;

          if (line.realProductCode != null && line.realProductCode!.isNotEmpty) {
            exportedProductCode = line.realProductCode!;
            exportedStatement = '$baseStatement - لقد بيعت على انها (${line.productName})';
          }

          sheet.appendRow([
            IntCellValue(invoice.invoiceNumber),
            TextCellValue(invoice.date),
            TextCellValue(accountCode),
            TextCellValue(customerName),
            TextCellValue(defaultWarehouse),
            TextCellValue(exportedProductCode), // رمز المادة (الحقيقية أو العادية)
            DoubleCellValue(line.quantity),
            TextCellValue(line.unitName ?? ''),
            DoubleCellValue(line.price),
            IntCellValue(payMethodCode),
            TextCellValue(invoice.currency),
            TextCellValue(exportedStatement), // البيان المعدل
            TextCellValue(costCenter)
          ]);
        }
      }
    }

    processInvoiceLines(excel['المبيعات'], 'SALE', false);
    processInvoiceLines(excel['المرتجعات'], 'RETURN', false);
    processInvoiceLines(excel['الهدايا'], 'SALE', true);

    // --- Sheet 5: Discounts ---
    var discountSheet = excel['الحسميات'];
    discountSheet.isRTL = true;
    createHeader(discountSheet,[
      'رقم الفاتورة', 'تاريخ الفاتورة', 'نوع الفاتورة', 'رمز الحساب', 'اسم الزبون',
      'رمز المستودع', 'قيمة الحسم', 'طريقة الدفع', 'رمز العملة', 'البيان', 'مركز الكلفة'
    ]);

    for (var invoice in invoices.where((i) => i.discountAmount > 0)) {
      String accountCode = getAccountCode(invoice);
      String customerName = getCustomerName(invoice);
      String statement = 'حسم فاتورة رقم ${invoice.invoiceNumber}';
      int payMethodCode = invoice.paymentMethod == 'CASH' ? 0 : 1;
      String invoiceType = invoice.type == 'SALE' ? 'مبيعات' : 'مرتجع';

      discountSheet.appendRow([
        IntCellValue(invoice.invoiceNumber),
        TextCellValue(invoice.date),
        TextCellValue(invoiceType),
        TextCellValue(accountCode),
        TextCellValue(customerName),
        TextCellValue(defaultWarehouse),
        DoubleCellValue(invoice.discountAmount),
        IntCellValue(payMethodCode),
        TextCellValue(invoice.currency),
        TextCellValue(statement),
        TextCellValue(costCenter)
      ]);
    }

    // --- Sheet 6 & 7: Vouchers ---
    void processVouchers(Sheet sheet, String type) {
      createHeader(sheet,['المدين', 'الدائن', 'المبلغ', 'مركز الكلفة', 'البيان']);
      sheet.isRTL = true;
      for (var v in vouchers.where((v) => v.type == type)) {
        sheet.appendRow([
          TextCellValue(v.debitAccount),
          TextCellValue(v.creditAccount),
          DoubleCellValue(v.amount),
          TextCellValue(costCenter),
          TextCellValue(v.note ?? '')
        ]);
      }
    }
    processVouchers(excel['سندات القبض'], 'RECEIPT');
    processVouchers(excel['سندات الدفع'], 'PAYMENT');

    // --- Sheet 8: Customers ---
    var custSheet = excel['الزبائن'];
    custSheet.isRTL = true;
    // 🔴 التعديل هنا: إضافة عمود "الحالة" 🔴
    createHeader(custSheet,[
      'رمز الحساب الرئيسي', 'رمز العملة', 'هاتف 1', 'هاتف 2', 'البريد', 'ملاحظات',
      'الدولة', 'المدينة', 'الحي', 'الشارع', 'الجنس', 'رمز الزبون', 'اسم الزبون', 'الحالة'
    ]);
    for (var c in customers) {
      String status = c.isSent ? 'معدل' : 'جديد'; // منطق تحديد الحالة

      custSheet.appendRow([
        TextCellValue(mainAccountPrefix),
        TextCellValue(c.currency),
        TextCellValue(c.phone1 ?? ''),
        TextCellValue(c.phone2 ?? ''),
        TextCellValue(c.email ?? ''),
        TextCellValue(c.notes ?? ''),
        TextCellValue(countryName),
        TextCellValue(c.city ?? ''),
        TextCellValue(c.area ?? ''),
        TextCellValue(c.street ?? ''),
        TextCellValue(c.gender),
        TextCellValue('$customerCodePrefix${c.accountCode}'),
        TextCellValue('$customerNamePrefix${c.name}'),
        TextCellValue(status), // وضع الحالة هنا
      ]);
    }

    // --- Sheet 9: Transfers ---
    var transSheet = excel['المناقلات'];
    transSheet.isRTL = true;
    int rowIndex = 0;
    for (var transfer in transfers) {
      transSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue('البيان');
      transSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = TextCellValue('${transfer.name} - ${transfer.date}');
      rowIndex++;

      transSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue('رمز المادة');
      transSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = TextCellValue('الكمية');
      rowIndex++;

      var tLines = transferLines.where((l) => l.transferId == transfer.id);
      for (var line in tLines) {
        transSheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex)).value = TextCellValue(line.productCode ?? '');
        transSheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex)).value = DoubleCellValue(line.quantity);
        rowIndex++;
      }
      rowIndex++;
    }

    var excelBytes = excel.save();
    if (excelBytes == null) throw Exception("فشل في توليد ملف الإكسيل");

    final dateStr = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
    final baseFileName = '${delegateName}_$dateStr';
    final tempDir = await getTemporaryDirectory();

    if (password.isNotEmpty) {
      final archive = Archive();
      archive.addFile(ArchiveFile('$baseFileName.xlsx', excelBytes.length, excelBytes));
      final zipEncoder = ZipEncoder();
      final zipBytes = zipEncoder.encode(archive);

      final zipFile = File('${tempDir.path}/$baseFileName.zip');
      await zipFile.writeAsBytes(zipBytes!);
      return zipFile;
    } else {
      final excelFile = File('${tempDir.path}/$baseFileName.xlsx');
      await excelFile.writeAsBytes(excelBytes);
      return excelFile;
    }
  }
}

final excelExportServiceProvider = Provider<ExcelExportService>((ref) {
  final db = ref.watch(databaseProvider);
  final settingsDao = ref.watch(settingsDaoProvider);
  return ExcelExportService(db, settingsDao);
});