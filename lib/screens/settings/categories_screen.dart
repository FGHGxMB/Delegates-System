import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_strings.dart';
import '../../config/app_colors.dart';
import '../../database/daos/catalog_dao.dart';
import '../../database/database.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(catalogDaoProvider).initDefaultCategories());
  }

  Future<void> _showCategoryDialog({ProductCategory? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    int columns = existing?.gridColumns ?? 2;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(existing == null ? AppStrings.newCategory : AppStrings.editCategory),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: AppStrings.category),
              ),
              const SizedBox(height: 16),
              const Text(AppStrings.columnsCount, style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // [تحديث] إضافة الرقم 1 للخيارات
              SegmentedButton<int>(
                segments: const[
                  ButtonSegment(value: 1, label: Text('1')),
                  ButtonSegment(value: 2, label: Text('2')),
                  ButtonSegment(value: 3, label: Text('3')),
                  ButtonSegment(value: 4, label: Text('4')),
                ],
                selected: {columns},
                onSelectionChanged: (Set<int> newSelection) {
                  setStateDialog(() => columns = newSelection.first);
                },
              ),
            ],
          ),
          actions:[
            TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.cancel)),
            FilledButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) return;

                try {
                  final dao = ref.read(catalogDaoProvider);
                  if (existing == null) {
                    await dao.addCategory(nameController.text.trim(), columns);
                  } else {
                    await dao.updateCategory(existing.copyWith(
                      name: nameController.text.trim(),
                      gridColumns: columns,
                    ));
                  }
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  print('خطأ في قاعدة البيانات: $e'); // سيكشف لنا الخطأ في الكونسول
                }
              },
              child: const Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dao = ref.watch(catalogDaoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.manageCategories),
        backgroundColor: Colors.red[800],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children:[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(AppStrings.dragToReorder, style: TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: StreamBuilder<List<ProductCategory>>(
              stream: dao.watchCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final categories = snapshot.data!;

                if (categories.isEmpty) return const Center(child: Text(AppStrings.noData));

                return ReorderableListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: categories.length,
                  onReorder: (oldIndex, newIndex) async {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = categories.removeAt(oldIndex);
                    categories.insert(newIndex, item);
                    await dao.updateCategoriesOrder(categories);
                  },
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Card(
                      key: ValueKey(cat.id),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: ListTile(
                        leading: const Icon(Icons.drag_handle, color: Colors.grey),
                        title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${AppStrings.columnsCount}: ${cat.gridColumns}'),
                        onTap: () {
                          // الدخول لشاشة المواد وتمرير ID واسم المجموعة
                          context.push('/category_products/${cat.id}/${cat.name}');
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.primary),
                              onPressed: () => _showCategoryDialog(existing: cat),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.error),
                              onPressed: () async {
                                final success = await dao.deleteCategory(cat.id);
                                if (!success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(AppStrings.categoryNotEmpty), backgroundColor: Colors.red),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}