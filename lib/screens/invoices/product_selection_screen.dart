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
  // استخدام ValueNotifier بدلاً من setState لمنع تحديث الشاشة بالكامل
  final ValueNotifier<Set<Product>> _selectedProductsNotifier = ValueNotifier({});
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier('');
  final TextEditingController _searchController = TextEditingController();

  // تخزين اتصال قاعدة البيانات لمنع إعادة التحميل عند أي تغيير بسيط
  late final Stream<List<ProductCategory>> _categoriesStream;

  @override
  void initState() {
    super.initState();
    // نجلب المجموعات مرة واحدة فقط عند فتح الشاشة
    _categoriesStream = ref.read(catalogDaoProvider).watchVisibleCategories();
  }

  @override
  void dispose() {
    _selectedProductsNotifier.dispose();
    _searchQueryNotifier.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogDao = ref.watch(catalogDaoProvider);

    return StreamBuilder<List<ProductCategory>>(
      stream: _categoriesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
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
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              title: const Text('إضافة مواد للفاتورة'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                tabs: categories.map((c) => Tab(text: c.name)).toList(),
              ),
            ),
            body: Column(
              children:[
                // ─── شريط البحث (مستقل ولا يتأثر بالتحديثات) ───
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppStrings.search,
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    // نحدث النص في المراقب فقط بدون setState
                    onChanged: (val) => _searchQueryNotifier.value = val.toLowerCase(),
                  ),
                ),

                // ─── منطقة المجموعات ───
                Expanded(
                  child: TabBarView(
                    children: categories.map((category) {
                      return _buildCategoryView(catalogDao, category.id);
                    }).toList(),
                  ),
                ),
              ],
            ),

            // ─── زر الإضافة (يستمع للتحديدات فقط ولا يُحدث الشاشة) ───
            floatingActionButton: widget.isSingleSelection
                ? null
                : ValueListenableBuilder<Set<Product>>(
              valueListenable: _selectedProductsNotifier,
              builder: (context, selected, child) {
                if (selected.isEmpty) return const SizedBox.shrink();
                return FloatingActionButton.extended(
                  onPressed: () => Navigator.pop(context, selected.toList()),
                  backgroundColor: AppColors.success,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: Text(
                    'إضافة ${selected.length} مواد',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                );
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
    );
  }

  // ─── بناء العواميد بتمرير موحد (Unified Scroll) ───
  Widget _buildCategoryView(CatalogDao dao, int categoryId) {
    return StreamBuilder<List<ProductColumn>>(
      stream: dao.watchVisibleColumnsByCategory(categoryId),
      builder: (context, colSnapshot) {
        if (colSnapshot.connectionState == ConnectionState.waiting && !colSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final columns = colSnapshot.data ??[];
        if (columns.isEmpty) {
          return const Center(child: Text('لا توجد عواميد مرئية في هذه المجموعة.'));
        }

        // هنا السحر: SingleChildScrollView واحد يلف جميع العواميد لتتحرك معاً
        return SingleChildScrollView(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 80), // مساحة للزر السفلي
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columns.map((column) {
              return Expanded(
                child: _buildColumnSection(dao, column),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ─── بناء العامود الواحد ───
  Widget _buildColumnSection(CatalogDao dao, ProductColumn column) {
    return StreamBuilder<List<Product>>(
      stream: dao.watchActiveProductsByColumn(column.id),
      builder: (context, prodSnapshot) {
        if (!prodSnapshot.hasData) return const SizedBox.shrink();

        // استماع للبحث محلياً داخل العامود فقط
        return ValueListenableBuilder<String>(
          valueListenable: _searchQueryNotifier,
          builder: (context, query, child) {
            final products = prodSnapshot.data!.where((p) {
              return p.name.toLowerCase().contains(query) ||
                  p.code.toLowerCase().contains(query);
            }).toList();

            // إخفاء العامود بالكامل إذا كنا نبحث ولم يطابق أي مادة فيه
            if (query.isNotEmpty && products.isEmpty) return const SizedBox.shrink();

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisSize: MainAxisSize.min, // لا يأخذ مساحة أكبر من حجمه
                children:[
                  // رأس العامود
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.2))),
                    ),
                    child: Text(
                      column.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // قائمة المواد (Column بدلاً من ListView لتتحرك مع الشاشة ككل)
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: products.isEmpty
                          ?[const Padding(padding: EdgeInsets.all(8.0), child: Text('لا يوجد مواد', style: TextStyle(color: Colors.grey)))]
                          : products.map((p) => _buildProductItem(p)).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── بناء بطاقة المادة ───
  Widget _buildProductItem(Product product) {
    // كل مادة تستمع فقط لحالة التحديد الخاصة بها لكي لا تُحدث باقي الشاشة
    return ValueListenableBuilder<Set<Product>>(
      valueListenable: _selectedProductsNotifier,
      builder: (context, selected, child) {
        final isSelected = selected.any((p) => p.id == product.id);

        return Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              if (widget.isSingleSelection) {
                Navigator.pop(context, [product]);
              } else {
                // تحديث قائمة التحديد بصمت
                final newSet = Set<Product>.from(_selectedProductsNotifier.value);
                if (isSelected) {
                  newSet.removeWhere((p) => p.id == product.id);
                } else {
                  newSet.add(product);
                }
                _selectedProductsNotifier.value = newSet;
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.15) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected ?[] :[
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 2, offset: const Offset(0, 1))
                ],
              ),
              child: Text(
                product.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? AppColors.primary : Colors.black87,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}