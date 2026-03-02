import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../database/daos/vouchers_dao.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import '../../utils/currency_utils.dart';
import 'voucher_form_screen.dart'; // استدعاء شاشة الإضافة والتعديل

class VouchersListScreen extends ConsumerWidget {
  const VouchersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchersDao = ref.watch(vouchersDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل السندات'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Voucher>>(
        stream: vouchersDao.watchAllVouchers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final vouchers = snapshot.data ??[];

          if (vouchers.isEmpty) {
            return const Center(
              child: Text('لا توجد سندات مسجلة حتى الآن.', style: TextStyle(color: Colors.grey, fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8).copyWith(bottom: 80),
            itemCount: vouchers.length,
            itemBuilder: (context, index) {
              final voucher = vouchers[index];
              final isReceipt = voucher.type == 'RECEIPT';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isReceipt ? AppColors.success.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  // أيقونة تميز نوع السند (سهم أخضر للأسفل للقبض، سهم أحمر للأعلى للدفع)
                  leading: CircleAvatar(
                    backgroundColor: isReceipt ? AppColors.success.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                    child: Icon(
                      isReceipt ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isReceipt ? AppColors.success : Colors.redAccent,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text(
                        isReceipt ? 'سند قبض #${voucher.voucherNumber}' : 'سند دفع #${voucher.voucherNumber}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // حالة السند (مسودة، مخرج، مرسل)
                      Chip(
                        label: Text(
                          voucher.status == 'DRAFT' ? AppStrings.invoiceDraft : voucher.status == 'ISSUED' ? AppStrings.invoiceIssued : AppStrings.invoiceSent,
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        backgroundColor: voucher.status == 'DRAFT' ? AppColors.draftColor : voucher.status == 'ISSUED' ? AppColors.issuedColor : AppColors.sentColor,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      const SizedBox(height: 4),
                      Text('التاريخ: ${voucher.date}'),
                      const SizedBox(height: 4),
                      Text(
                        'المبلغ: ${CurrencyUtils.format(voucher.amount)} ${voucher.currency == 'SYP' ? 'ل.س' : '\$'}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isReceipt ? AppColors.success : Colors.redAccent,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // فتح السند للتعديل أو العرض
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VoucherFormScreen(
                          type: voucher.type,
                          voucherId: voucher.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      // ─── زر إضافة سند جديد (مزدوج الخيارات) ───
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showNewVoucherOptions(context);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('سند جديد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ─── نافذة منبثقة لاختيار نوع السند عند الإضافة ───
  void _showNewVoucherOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('اختر نوع السند', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.arrow_downward, color: Colors.white)),
                title: const Text('سند قبض (استلام مبلغ)', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const VoucherFormScreen(type: 'RECEIPT', voucherId: 0)));
                },
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.arrow_upward, color: Colors.white)),
                title: const Text('سند دفع (دفع مبلغ)', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const VoucherFormScreen(type: 'PAYMENT', voucherId: 0)));
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}