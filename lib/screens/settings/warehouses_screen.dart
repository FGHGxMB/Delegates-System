import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/warehouses_dao.dart';
import '../../database/database.dart';

class WarehousesScreen extends ConsumerWidget {
  const WarehousesScreen({Key? key}) : super(key: key);

  // دالة إظهار نافذة إضافة مستودع
  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.newWarehouse),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: AppStrings.warehouseName),
          autofocus: true,
        ),
        actions:[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final dao = ref.read(warehousesDaoProvider);
                await dao.addWarehouse(controller.text.trim());
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text(AppStrings.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dao = ref.watch(warehousesDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.manageWarehouses),
        backgroundColor: Colors.red[800], // إبقاء اللون الأحمر لتمييز قسم الحماية
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Warehouse>>(
        stream: dao.watchAllWarehouses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final warehouses = snapshot.data ??[];

          if (warehouses.isEmpty) {
            return const Center(child: Text(AppStrings.noData));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: warehouses.length,
            itemBuilder: (context, index) {
              final warehouse = warehouses[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.store, color: AppColors.primary),
                  title: Text(warehouse.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: () async {
                      // نافذة تأكيد الحذف
                      final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(AppStrings.warning),
                            content: const Text(AppStrings.deleteWarehouseConfirm),
                            actions:[
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text(AppStrings.no)),
                              FilledButton(
                                  style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(AppStrings.yes)
                              ),
                            ],
                          )
                      );

                      if (confirm == true) {
                        await dao.deleteWarehouse(warehouse.id);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}