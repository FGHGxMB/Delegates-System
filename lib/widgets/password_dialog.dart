import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/password_service.dart';
import '../config/app_strings.dart';

class PasswordDialog extends ConsumerStatefulWidget {
  const PasswordDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<PasswordDialog> createState() => _PasswordDialogState();
}

class _PasswordDialogState extends ConsumerState<PasswordDialog> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  Future<void> _verify() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final passwordService = ref.read(passwordServiceProvider);
    final isCorrect = await passwordService.verifyPassword(_controller.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (isCorrect) {
      Navigator.of(context).pop(true); // كلمة السر صحيحة -> إرجاع true
    } else {
      setState(() => _errorText = AppStrings.wrongPassword);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.passwordRequired),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, letterSpacing: 4),
        decoration: InputDecoration(
          hintText: '****',
          errorText: _errorText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _verify,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text(AppStrings.confirm),
        ),
      ],
    );
  }
}

// 💡 دالة سحرية لنداء نافذة كلمة السر من أي مكان بسطر واحد
Future<bool> showPasswordDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // لا يُغلق عند الضغط في الخارج
    builder: (context) => const PasswordDialog(),
  );
  return result ?? false;
}