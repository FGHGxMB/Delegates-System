import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../database/daos/transfers_dao.dart';
import '../../config/app_colors.dart';
import 'transfer_form_screen.dart';
import 'package:go_router/go_router.dart';

class TransfersListScreen extends ConsumerWidget {
  const TransfersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dao = ref.watch(transfersDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل المناقلات'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Transfer>>(
        stream: dao.watchAllTransfers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final transfers = snapshot.data ??[];

          if (transfers.isEmpty) return const Center(child: Text('لا توجد مناقلات.'));

          return ListView.builder(
            padding: const EdgeInsets.all(8).copyWith(bottom: 80),
            itemCount: transfers.length,
            itemBuilder: (context, index) {
              final t = transfers[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.blueAccent, child: Icon(Icons.swap_horiz, color: Colors.white)),
                  title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('التاريخ: ${t.date}'),
                  trailing: Chip(
                    label: Text(t.status == 'DRAFT' ? 'مسودة' : t.status == 'ISSUED' ? 'مُخرجة' : 'مُرسلة', style: const TextStyle(color: Colors.white, fontSize: 10)),
                    backgroundColor: t.status == 'DRAFT' ? AppColors.draftColor : t.status == 'ISSUED' ? AppColors.issuedColor : AppColors.sentColor,
                    visualDensity: VisualDensity.compact,
                  ),
                  onTap: () {
                    context.push('/transfer_form/${t.id}');
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transfer_form/0'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('مناقلة جديدة', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}