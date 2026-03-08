import 'dart:io';
import 'dart:convert'; // 🔴 مطلوب لتحويل أسماء المستخدمين
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:archive/archive.dart'; // 🔴 لضغط وفك ضغط النسخة الشاملة
import 'package:shared_preferences/shared_preferences.dart'; // 🔴 للوصول للأسماء

import '../../config/app_strings.dart';
import '../../database/daos/settings_dao.dart';
import '../../database/daos/invoices_dao.dart';
import '../../database/daos/vouchers_dao.dart';
import '../../database/daos/customers_dao.dart';
import '../../database/daos/transfers_dao.dart';
import '../../widgets/password_dialog.dart';
import '../../services/excel_export_service.dart';
import '../../utils/user_manager.dart';
import '../../providers/database_provider.dart';

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
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.success)));
  }

  // ─── 1. التصدير والنسخ الاحتياطي (نسخة شاملة لكل التطبيق) ───
  Future<void> _exportDataToAccountant() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الإرسال', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text('تنبيه: سيتم إرسال جميع الحركات وأخذ نسخة احتياطية شاملة للتطبيق.\nهل تريد الاستمرار؟', style: TextStyle(height: 1.5)),
        actions:[
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.green), onPressed: () => Navigator.pop(context, true), child: const Text('نعم، استمرار')),
        ],
      ),
    );

    if (confirm != true) return;
    setState(() => _isExporting = true);

    try {
      // أ) توليد الإكسيل (للمندوب الحالي فقط) ليرسله للمحاسب
      final exportService = ref.read(excelExportServiceProvider);
      final excelFile = await exportService.generateAndExportExcel();

      // ب) 🔴 السحر هنا: بناء نسخة احتياطية شاملة (Full App Backup)
      final archive = Archive();
      final dbFolder = await getApplicationDocumentsDirectory();

      // 1. إضافة كل قواعد البيانات (.sqlite) للأرشيف
      final files = dbFolder.listSync();
      for (var file in files) {
        if (file is File && file.path.endsWith('.sqlite')) {
          final bytes = await file.readAsBytes();
          final fileName = file.path.split('/').last;
          archive.addFile(ArchiveFile(fileName, bytes.length, bytes));
        }
      }

      // 2. إضافة إعدادات المستخدمين (الأسماء) للأرشيف
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString('app_users_list') ?? '{}';
      final currentActive = prefs.getString('current_active_user_id') ?? 'default_user';
      final configMap = {'app_users_list': usersJson, 'current_active_user_id': currentActive};
      final configBytes = utf8.encode(jsonEncode(configMap));
      archive.addFile(ArchiveFile('app_config.json', configBytes.length, configBytes));

      // 3. ضغط الأرشيف وحفظه في ملف .bak
      final zipBytes = ZipEncoder().encode(archive);
      final tempDir = await getTemporaryDirectory();
      final delegateName = await ref.read(settingsDaoProvider).getValue('delegate_name') ?? 'تطبيق_المناديب';
      final dateStr = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
      final backupFileName = 'FullBackup_${delegateName}_$dateStr.bak';

      final backupFile = File('${tempDir.path}/$backupFileName');
      await backupFile.writeAsBytes(zipBytes!);

      // ج) مشاركة الإكسيل والنسخة معاً
      final result = await Share.shareXFiles([XFile(excelFile.path), XFile(backupFile.path)],
        text: 'مرفق ملف الحركات للمندوب الحالي، ونسخة احتياطية (شاملة) للتطبيق بالكامل\nتاريخ: $dateStr',
      );

      if (result.status == ShareResultStatus.success) {
        // تحديث حالة البيانات للمندوب الحالي فقط
        await ref.read(invoicesDaoProvider).markUnsentAsSent();
        await ref.read(vouchersDaoProvider).markUnsentAsSent();
        await ref.read(customersDaoProvider).markUnsentAsSent();
        await ref.read(transfersDaoProvider).markUnsentAsSent();

        // د) حفظ النسخة في ملفات التنزيلات
        try {
          await Permission.storage.request();
          String publicPath = '/storage/emulated/0/Download/نسخ_تطبيق_المناديب';
          final publicDir = Directory(publicPath);
          if (!await publicDir.exists()) await publicDir.create(recursive: true);

          await excelFile.copy('$publicPath/${excelFile.path.split('/').last}');
          await backupFile.copy('$publicPath/$backupFileName');
        } catch (_) {}

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم أخذ نسخة شاملة (لكل المستخدمين) بنجاح!'), backgroundColor: Colors.green));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  // ─── 2. استعادة النسخة الشاملة ───
  Future<void> _restoreBackup() async {
    final isAuthorized = await showPasswordDialog(context);
    if (!isAuthorized || !mounted) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles(dialogTitle: 'اختر ملف النسخة الاحتياطية (.bak)');
    if (result == null || result.files.single.path == null) return;

    File pickedFile = File(result.files.single.path!);
    if (!pickedFile.path.endsWith('.bak')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الملف غير صالح! يجب أن ينتهي بـ .bak'), backgroundColor: Colors.red));
      return;
    }

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('استعادة شاملة', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text(
          'تحذير خطير!\n\n'
              'سيتم مسح كل شيء في التطبيق حالياً (جميع المستخدمين، الزبائن، الفواتير) واستبداله بالنسخة الاحتياطية.\n\n'
              'هل أنت متأكد؟',
          style: TextStyle(height: 1.5),
        ),
        actions:[
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(context, true), child: const Text('استعادة ومسح الحالي')),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

      // 1. إيقاف قاعدة البيانات الحالية
      await ref.read(databaseProvider).close();

      // 2. قراءة وفك ضغط الملف
      final bytes = await pickedFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final dbFolder = await getApplicationDocumentsDirectory();

      // 3. تنظيف قواعد البيانات القديمة لتجنب التضارب
      final oldFiles = dbFolder.listSync();
      for (var f in oldFiles) {
        if (f is File && f.path.endsWith('.sqlite')) await f.delete();
      }

      // 4. استخراج الملفات الجديدة من الأرشيف
      for (final file in archive) {
        if (file.name == 'app_config.json') {
          // استعادة أسماء المستخدمين والمستخدم النشط
          final configString = utf8.decode(file.content as List<int>);
          final configMap = jsonDecode(configString);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('app_users_list', configMap['app_users_list']);
          await prefs.setString('current_active_user_id', configMap['current_active_user_id']);

          // تحديث Riverpod باسم المستخدم المستعاد
          ref.read(currentUserIdProvider.notifier).state = configMap['current_active_user_id'];
        } else if (file.name.endsWith('.sqlite')) {
          // استعادة قواعد بيانات المستخدمين
          final outPath = '${dbFolder.path}/${file.name}';
          await File(outPath).writeAsBytes(file.content as List<int>);
        }
      }

      // 5. إعادة تشغيل محرك قاعدة البيانات بالمعلومات الجديدة
      ref.invalidate(databaseProvider);

      if (mounted) {
        Navigator.pop(context); // إغلاق دائرة التحميل
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الاستعادة الشاملة بنجاح!'), backgroundColor: Colors.green));
        _loadSettings();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشلت الاستعادة: الملف تالف أو غير صالح.'), backgroundColor: Colors.red));
      }
    }
  }

  // ─── 3. إدارة المستخدمين (التبديل والإنشاء) ───
  Future<void> _manageUsers() async {
    final isAuthorized = await showPasswordDialog(context);
    if (!isAuthorized || !mounted) return;

    Map<String, String> users = await UserManager.getUsers();
    String currentUserId = await UserManager.getCurrentUserId();

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                    const Padding(padding: EdgeInsets.all(16.0), child: Text('إدارة المناديب (مساحات العمل)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                    const Divider(),

                    Expanded(
                      flex: 0,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                        child: ListView(
                          children: users.entries.map((entry) {
                            bool isActive = entry.key == currentUserId;
                            return ListTile(
                              leading: Icon(isActive ? Icons.check_circle : Icons.person, color: isActive ? Colors.green : Colors.grey),
                              title: Text(entry.value, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                              subtitle: isActive ? const Text('نشط حالياً', style: TextStyle(color: Colors.green, fontSize: 12)) : null,
                              tileColor: isActive ? Colors.green.shade50 : null,
                              onTap: () async {
                                if (isActive) return;
                                await UserManager.setCurrentUser(entry.key);
                                ref.read(currentUserIdProvider.notifier).state = entry.key;
                                ref.invalidate(databaseProvider);
                                if (context.mounted) {
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم التبديل إلى: ${entry.value}'), backgroundColor: Colors.blue));
                                  _loadSettings();
                                }
                              },
                              trailing: isActive ? null : IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await UserManager.deleteUser(entry.key);
                                  // حذف ملف الداتا بيز الخاص به لتوفير المساحة
                                  final dbFolder = await getApplicationDocumentsDirectory();
                                  final file = File('${dbFolder.path}/${entry.key}.sqlite');
                                  if (await file.exists()) await file.delete();

                                  setSheetState(() { users.remove(entry.key); });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final newNameCtrl = TextEditingController();
                          final String? newName = await showDialog<String>(
                              context: ctx,
                              builder: (c) => AlertDialog(
                                title: const Text('إضافة مندوب جديد'),
                                content: TextField(controller: newNameCtrl, autofocus: true, decoration: const InputDecoration(hintText: 'اسم المندوب')),
                                actions:[
                                  TextButton(onPressed: () => Navigator.pop(c), child: const Text('إلغاء')),
                                  FilledButton(onPressed: () => Navigator.pop(c, newNameCtrl.text.trim()), child: const Text('إضافة')),
                                ],
                              )
                          );

                          if (newName != null && newName.isNotEmpty) {
                            final newId = await UserManager.addUser(newName);
                            setSheetState(() { users[newId] = newName; });
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('إنشاء مساحة عمل لمندوب جديد'),
                        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(40)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
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
                    decoration: const InputDecoration(hintText: AppStrings.exchangeRateHint, border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text(AppStrings.autoLoadPrices, style: TextStyle(fontWeight: FontWeight.bold)),
                    value: _autoLoadPrices,
                    onChanged: (val) => setState(() => _autoLoadPrices = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(width: double.infinity, child: FilledButton(onPressed: _saveSettings, child: const Text(AppStrings.save))),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity, height: 56,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.green[700], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _isExporting ? null : _exportDataToAccountant,
              icon: _isExporting ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.send_to_mobile, size: 28),
              label: Text(_isExporting ? 'جاري التصدير والنسخ...' : 'إرسال الإكسيل ونسخ التطبيق', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity, height: 50,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.red[800], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                final isAuthorized = await showPasswordDialog(context);
                if (isAuthorized && context.mounted) context.push('/protected_settings');
              },
              icon: const Icon(Icons.settings_applications),
              label: const Text(AppStrings.protectedSettings, style: TextStyle(fontSize: 16)),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity, height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue.shade800, side: BorderSide(color: Colors.blue.shade800), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _manageUsers,
              icon: const Icon(Icons.switch_account),
              label: const Text('إدارة مساحات العمل (المستخدمين)', style: TextStyle(fontSize: 16)),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity, height: 50,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.orange.shade800, side: BorderSide(color: Colors.orange.shade800), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _restoreBackup,
              icon: const Icon(Icons.restore),
              label: const Text('استعادة نسخة احتياطية شاملة', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}