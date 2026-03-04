import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import '../../config/app_strings.dart';
import '../../database/daos/settings_dao.dart';
import '../../database/daos/invoices_dao.dart';
import '../../database/daos/vouchers_dao.dart';
import '../../widgets/password_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _exchangeRateController = TextEditingController();
  bool _autoLoadPrices = true;
  bool _isLoading = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final dao = ref.read(settingsDaoProvider);
    _exchangeRateController.text = await dao.getValue('exchange_rate') ?? '';
    _autoLoadPrices = (await dao.getValue('auto_load_prices') ?? '1') == '1';
    setState(() => _isLoading = false);
  }

  Future<void> _saveSettings() async {
    final dao = ref.read(settingsDaoProvider);
    await dao.setValue('exchange_rate', _exchangeRateController.text);
    await dao.setValue('auto_load_prices', _autoLoadPrices ? '1' : '0');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.success)));
    }
  }

  // دالة تصدير البيانات وإرسالها للمحاسب مع الحفظ الاحتياطي
  Future<void> _exportDataToAccountant() async {
    // 1. رسالة تأكيدية
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الإرسال', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text(
          'تنبيه: سيتم إرسال جميع الفواتير والسندات غير المرسلة.\n\n'
              'لن تتمكن من إعادة إرسال هذا الملف من هذه الشاشة لاحقاً.\n'
              'هل تريد الاستمرار؟',
          style: TextStyle(height: 1.5),
        ),
        actions:[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('نعم، استمرار'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isExporting = true);

    try {
      // 2. توليد ملف الإكسيل
      final dao = ref.read(settingsDaoProvider);
      final delegateName = await dao.getValue('delegate_name') ?? 'مندوب';

      // إضافة الوقت بالدقائق والثواني لضمان عدم تكرار اسم الملف في نفس اليوم
      final dateStr = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
      final fileName = 'Export_${dateStr}_$delegateName.xlsx';

      var excel = Excel.createExcel();
      // يمكن إضافة أوراق عمل وتنسيقات لاحقاً هنا

      var fileBytes = excel.save();
      if (fileBytes == null) throw Exception("فشل في توليد ملف الإكسيل");

      // حفظ الملف في المسار المؤقت للمشاركة
      final tempDirectory = await getTemporaryDirectory();
      final tempFilePath = '${tempDirectory.path}/$fileName';
      File(tempFilePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      // 3. مشاركة الملف
      final result = await Share.shareXFiles(
        [XFile(tempFilePath)],
        text: 'مرفق ملف حركات المندوب: $delegateName\nتاريخ: $dateStr',
      );

      // 4. إذا تمت عملية المشاركة بنجاح (فتح نافذة المشاركة)
      if (result.status == ShareResultStatus.success) {

        // أ) تحديث حالة البيانات في قاعدة البيانات
        await ref.read(invoicesDaoProvider).markUnsentAsSent();
        await ref.read(vouchersDaoProvider).markUnsentAsSent();

        // ب) حفظ نسخة احتياطية محلية في جهاز المندوب للرجوع إليها
        String backupMessage = '';
        try {
          // نحصل على مجلد المستندات الخاص بالتطبيق
          final docsDirectory = await getApplicationDocumentsDirectory();
          final backupDirPath = '${docsDirectory.path}/Backups';

          final backupDir = Directory(backupDirPath);
          if (!await backupDir.exists()) {
            await backupDir.create(recursive: true);
          }

          final backupFilePath = '$backupDirPath/$fileName';

          // نسخ الملف من المسار المؤقت إلى مسار النسخ الاحتياطية
          await File(tempFilePath).copy(backupFilePath);

          backupMessage = '\nتم حفظ نسخة احتياطية في مجلد المستندات.';
        } catch (backupError) {
          backupMessage = '\n(ملاحظة: فشل حفظ النسخة الاحتياطية محلياً)';
        }

        // ج) إظهار رسالة النجاح
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تمت مشاركة الملف وتحديث حالة البيانات بنجاح!$backupMessage'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5), // مدة أطول ليتمكن من قراءتها
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء التصدير: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children:[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const Text(AppStrings.exchangeRate, style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _exchangeRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: AppStrings.exchangeRateHint,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text(AppStrings.autoLoadPrices, style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _autoLoadPrices,
                    onChanged: (val) => setState(() => _autoLoadPrices = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saveSettings,
                      child: const Text(AppStrings.save),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // زر إرسال البيانات للمحاسب
          SizedBox(
            width: double.infinity,
            height: 56, // زر كبير وواضح
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isExporting ? null : _exportDataToAccountant,
              icon: _isExporting
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.send_to_mobile, size: 28),
              label: Text(
                _isExporting ? 'جاري التصدير...' : 'إرسال البيانات للمحاسب',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // الزر المؤدي للإعدادات المحمية
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final isAuthorized = await showPasswordDialog(context);
                if (isAuthorized && context.mounted) {
                  context.push('/protected_settings');
                }
              },
              icon: const Icon(Icons.lock),
              label: const Text(AppStrings.protectedSettings, style: TextStyle(fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}