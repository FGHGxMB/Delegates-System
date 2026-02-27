import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../database/database.dart';
import '../../database/daos/catalog_dao.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';
import 'products_screen.dart';

class ColumnsScreen extends ConsumerWidget {
  final int categoryId;
  final String categoryName;

  const ColumnsScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogDao = ref.watch(catalogDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('عواميد: $categoryName'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<ProductColumn>>(
        stream: catalogDao.watchColumnsByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final columns = snapshot.data ??[];

          if (columns.isEmpty) {
            return const Center(child: Text('لا توجد عواميد. أضف عاموداً جديداً.'));
          }

          return ReorderableListView.builder(
            itemCount: columns.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = columns.removeAt(oldIndex);
              columns.insert(newIndex, item);
              catalogDao.updateColumnsOrder(columns); // ترتيب العواميد
            },
            itemBuilder: (context, index) {
              final column = columns[index];
              return Card(
                key: ValueKey(column.id),
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: column.isVisible ? Colors.white : Colors.grey.shade300,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: const Icon(Icons.drag_indicator, color: Colors.grey),
                  title: Text(
                    column.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: column.isVisible ? null : TextDecoration.lineThrough,
                      color: column.isVisible ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                  subtitle: Text(
                      column.isVisible ? 'مرئي' : 'مخفي',
                      style: TextStyle(color: column.isVisible ? Colors.green : Colors.red)
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      // زر الإخفاء / الإظهار
                      IconButton(
                        icon: Icon(column.isVisible ? Icons.visibility : Icons.visibility_off, color: Colors.blue),
                        onPressed: () => catalogDao.toggleColumnVisibility(column),
                      ),
                      // زر الحذف
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDeleteColumn(context, catalogDao, column),
                      ),
                    ],
                  ),
                  onTap: () {
                    // الانتقال الحقيقي لشاشة المواد التابعة لهذا العامود
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsScreen(
                          categoryId: categoryId,
                          columnId: column.id,
                          columnName: column.name,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddColumnDialog(context, catalogDao),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('عامود جديد', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // نافذة إضافة عامود
  void _showAddColumnDialog(BuildContext context, CatalogDao dao) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إضافة عامود جديد'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'اسم العامود',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions:[
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                await dao.addColumn(categoryId, name); // إضافة العامود للمجموعة المحددة
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text(AppStrings.add),
          ),
        ],
      ),
    );
  }

  // نافذة تأكيد الحذف
  void _confirmDeleteColumn(BuildContext context, CatalogDao dao, ProductColumn column) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.warning),
        content: Text('هل أنت متأكد من حذف العامود "${column.name}"؟\nلا يمكن الحذف إذا كان يحتوي على مواد.'),
        actions:[
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text(AppStrings.no)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final success = await dao.deleteColumn(column.id);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('لا يمكن حذف العامود لأنه يحتوي على مواد!'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text(AppStrings.yes),
          ),
        ],
      ),
    );
  }
}