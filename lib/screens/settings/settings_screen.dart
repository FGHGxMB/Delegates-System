import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_strings.dart';
import '../../database/daos/settings_dao.dart';
import '../../widgets/password_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _exchangeRateController = TextEditingController();
  final _whatsappController = TextEditingController();
  bool _autoLoadPrices = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final dao = ref.read(settingsDaoProvider);
    _exchangeRateController.text = await dao.getValue('exchange_rate') ?? '';
    _whatsappController.text = await dao.getValue('whatsapp_number') ?? '';
    _autoLoadPrices = (await dao.getValue('auto_load_prices') ?? '1') == '1';
    setState(() => _isLoading = false);
  }

  Future<void> _saveSettings() async {
    final dao = ref.read(settingsDaoProvider);
    await dao.setValue('exchange_rate', _exchangeRateController.text);
    await dao.setValue('whatsapp_number', _whatsappController.text);
    await dao.setValue('auto_load_prices', _autoLoadPrices ? '1' : '0');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.success)));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(AppStrings.exchangeRate, style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _exchangeRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: AppStrings.exchangeRateHint),
                  ),
                  const SizedBox(height: 16),
                  const Text(AppStrings.whatsappNumber, style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _whatsappController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: '+963...'),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text(AppStrings.autoLoadPrices),
                    value: _autoLoadPrices,
                    onChanged: (val) => setState(() => _autoLoadPrices = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _saveSettings,
                    child: const Text(AppStrings.save),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // الزر المؤدي للإعدادات المحمية
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red[800]),
            onPressed: () async {
              // 1. اطلب كلمة السر للدخول
              final isAuthorized = await showPasswordDialog(context);
              if (isAuthorized && context.mounted) {
                // 2. إذا صحت، ادخل الشاشة المحمية
                context.push('/protected_settings');
              }
            },
            icon: const Icon(Icons.lock),
            label: const Text(AppStrings.protectedSettings),
          )
        ],
      ),
    );
  }
}