import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../database/daos/catalog_dao.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';

class ProductSelectionScreen extends ConsumerStatefulWidget {
  final bool isSingleSelection;

  const ProductSelectionScreen({
    Key? key,
    this.isSingleSelection = false,
  }) : super(key: key);

  @override
  ConsumerState<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends ConsumerState<ProductSelectionScreen> {
  // قائمة لتخزين المواد التي قام المندوب بتحديدها
  final Set<Product> _selectedProducts = {};
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final catalogDao = ref.watch(catalogDaoProvider);

    return StreamBuilder<List<ProductCategory>>(
      stream: catalogDao.watchVisibleCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final categories = snapshot.data ??[];
        if (categories.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('اختيار المواد')),
            body: const Center(child: Text('لا توجد مجموعات مرئية.')),
          );
        }

        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('إضافة مواد للفاتورة'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: categories.map((c) => Tab(text: c.name)).toList(),
              ),
              actions:[
                if (_selectedProducts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Badge(
                        label: Text('${_selectedProducts.length}'),
                        child: const Icon(Icons.shopping_cart),
                      ),
                    ),
                  ),
              ],
            ),
            body: Column(
              children:[
                // شريط البحث
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: AppStrings.search,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  ),
                ),
                // التبويبات (المجموعات)
                Expanded(
                  child: TabBarView(
                    children: categories.map((category) {
                      return _buildCategoryView(context, catalogDao, category.id);
                    }).toList(),
                  ),
                ),
              ],
            ),
            // زر الإضافة النهائي (يظهر فقط إذا تم تحديد مواد)
            floatingActionButton: (!widget.isSingleSelection && _selectedProducts.isNotEmpty)
                ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context, _selectedProducts.toList());
              },
              backgroundColor: AppColors.success,
              icon: const Icon(Icons.check, color: Colors.white),
              label: Text('إضافة ${_selectedProducts.length} مادة', style: const TextStyle(color: Colors.white)),
            )
                : null,
          ),
        );
      },
    );
  }

  // بناء محتوى المجموعة (جلب العواميد المرئية، ثم جلب موادها)
  Widget _buildCategoryView(BuildContext context, CatalogDao dao, int categoryId) {
    return StreamBuilder<List<ProductColumn>>(
      stream: dao.watchVisibleColumnsByCategory(categoryId),
      builder: (context, colSnapshot) {
        if (colSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final columns = colSnapshot.data ??[];
        if (columns.isEmpty) {
          return const Center(child: Text('لا توجد عواميد مرئية في هذه المجموعة.'));
        }

        // بناء قائمة بالعواميد وتحتها موادها
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80), // مساحة للزر العائم
          itemCount: columns.length,
          itemBuilder: (context, index) {
            final column = columns[index];
            return _buildColumnSection(dao, column);
          },
        );
      },
    );
  }

  // بناء قسم العامود والمواد الخاصة به
  Widget _buildColumnSection(CatalogDao dao, ProductColumn column) {
    return StreamBuilder<List<Product>>(
      stream: dao.watchActiveProductsByColumn(column.id),
      builder: (context, prodSnapshot) {
        if (!prodSnapshot.hasData) return const SizedBox.shrink();

        // تطبيق فلتر البحث (إن وجد)
        final products = prodSnapshot.data!.where((p) {
          return p.name.toLowerCase().contains(_searchQuery) ||
              p.code.toLowerCase().contains(_searchQuery);
        }).toList();

        if (products.isEmpty) return const SizedBox.shrink(); // إخفاء العامود إذا لم يكن به مواد أو لم يطابق البحث

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // عنوان العامود (تصميم مميز)
            Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                column.name,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            // قائمة المواد داخل هذا العامود
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final isSelected = _selectedProducts.any((p) => p.id == product.id);

                // 🔴 إذا كان اختياراً فردياً (للمادة المخادعة)
                if (widget.isSingleSelection) {
                  return ListTile(
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('الرمز: ${product.code} | السعر: ${product.unit1PriceRetail}'),
                    trailing: const Icon(Icons.touch_app, color: AppColors.primary),
                    onTap: () {
                      // إرجاع المادة فوراً بمجرد الضغط عليها
                      Navigator.pop(context, [product]);
                    },
                  );
                }

                // 🔴 إذا كان اختياراً متعدداً (لإضافة مواد للفاتورة)
                return CheckboxListTile(
                  title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('الرمز: ${product.code} | السعر: ${product.unit1PriceRetail}'),
                  value: isSelected,
                  activeColor: AppColors.primary,
                  onChanged: (bool? checked) {
                    setState(() {
                      if (checked == true) {
                        _selectedProducts.add(product);
                      } else {
                        _selectedProducts.removeWhere((p) => p.id == product.id);
                      }
                    });
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}