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
  final ValueNotifier<Set<Product>> _selectedProductsNotifier = ValueNotifier({});
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier('');
  final TextEditingController _searchController = TextEditingController();

  late final Stream<List<ProductCategory>> _categoriesStream;

  @override
  void initState() {
    super.initState();
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
            backgroundColor: Colors.white,
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
                // ─── شريط البحث ───
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppStrings.search,
                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    onChanged: (val) => _searchQueryNotifier.value = val.trim().toLowerCase(),
                  ),
                ),

                // ─── منطقة الجداول (الشبكة) ───
                Expanded(
                  child: TabBarView(
                    children: categories.map((category) {
                      return _buildCategoryTable(catalogDao, category.id);
                    }).toList(),
                  ),
                ),
              ],
            ),

            // ─── زر الإضافة السفلي ───
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

  // ─── بناء الجدول الشبيه بالفاتورة الورقية ───
  Widget _buildCategoryTable(CatalogDao dao, int categoryId) {
    return StreamBuilder<List<ProductColumn>>(
      stream: dao.watchVisibleColumnsByCategory(categoryId),
      builder: (context, colSnapshot) {
        if (!colSnapshot.hasData) return const Center(child: CircularProgressIndicator());
        final columns = colSnapshot.data ??[];
        if (columns.isEmpty) return const Center(child: Text('لا توجد عواميد.'));

        return StreamBuilder<List<Product>>(
          stream: dao.watchActiveProductsByCategory(categoryId),
          builder: (context, prodSnapshot) {
            if (!prodSnapshot.hasData) return const Center(child: CircularProgressIndicator());
            final allProducts = prodSnapshot.data ??[];

            return ValueListenableBuilder<String>(
              valueListenable: _searchQueryNotifier,
              builder: (context, query, child) {

                // 1. تصفية المواد وتوزيعها على العواميد الخاصة بها
                Map<int, List<Product>> groupedProducts = {};
                for (var col in columns) {
                  groupedProducts[col.id] =[];
                }

                for (var p in allProducts) {
                  if (groupedProducts.containsKey(p.columnId)) {
                    // تطبيق البحث إذا وجد
                    if (query.isEmpty || p.name.toLowerCase().contains(query) || p.code.toLowerCase().contains(query)) {
                      groupedProducts[p.columnId]!.add(p);
                    }
                  }
                }

                // 2. إيجاد أطول عامود لتحديد عدد صفوف الجدول
                int maxRows = 0;
                for (var list in groupedProducts.values) {
                  if (list.length > maxRows) maxRows = list.length;
                }

                if (maxRows == 0) return const Center(child: Text('لا توجد مواد مطابقة للبحث.'));

                // 3. بناء الجدول
                return Container(
                  margin: const EdgeInsets.all(8.0).copyWith(bottom: 80), // هوامش وإطار عام للجدول
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600, width: 1.5),
                    borderRadius: BorderRadius.circular(4), // حواف خفيفة جداً
                  ),
                  child: Column(
                    children:[
                      // ─── ترويسة الجدول (أسماء العواميد) ───
                      Container(
                        color: Colors.grey.shade300,
                        child: Row(
                          children: columns.map((col) {
                            bool isLast = col == columns.last;
                            return Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  border: isLast ? null : Border(left: BorderSide(color: Colors.grey.shade600, width: 1)),
                                ),
                                child: Text(
                                  col.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(height: 1, thickness: 1.5, color: Colors.grey.shade600),

                      // ─── صفوف الجدول (مبنية بـ ListView لأداء صاروخي) ───
                      Expanded(
                        child: ListView.builder(
                          itemCount: maxRows,
                          itemBuilder: (context, rowIndex) {
                            // تلوين الصفوف بالتناوب (Zebra Striping) لراحة العين
                            bool isEvenRow = rowIndex % 2 == 0;
                            Color rowColor = isEvenRow ? Colors.white : Colors.blueGrey.shade50;

                            return Container(
                              color: rowColor,
                              child: IntrinsicHeight( // لجعل الخلايا بنفس الطول
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: columns.map((col) {
                                    bool isLast = col == columns.last;
                                    final list = groupedProducts[col.id]!;

                                    Widget cellContent = const SizedBox.shrink();
                                    if (rowIndex < list.length) {
                                      cellContent = _buildTableCell(list[rowIndex]);
                                    }

                                    return Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: isLast ? null : Border(left: BorderSide(color: Colors.grey.shade400, width: 1)),
                                        ),
                                        child: cellContent,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ─── بناء الخلية الواحدة (اسم المادة القابل للضغط) ───
  Widget _buildTableCell(Product product) {
    return ValueListenableBuilder<Set<Product>>(
      valueListenable: _selectedProductsNotifier,
      builder: (context, selected, child) {
        final isSelected = selected.any((p) => p.id == product.id);

        return InkWell(
          onTap: () {
            if (widget.isSingleSelection) {
              Navigator.pop(context, [product]);
            } else {
              final newSet = Set<Product>.from(_selectedProductsNotifier.value);
              if (isSelected) {
                newSet.removeWhere((p) => p.id == product.id);
              } else {
                newSet.add(product);
              }
              _selectedProductsNotifier.value = newSet;
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            // إذا كانت محددة، نعطيها لوناً مميزاً
            color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              maxLines: 1, // سطر واحد كما طلبت
              overflow: TextOverflow.ellipsis, // وضع نقاط إذا كان الاسم طويلاً جداً
              style: TextStyle(
                fontSize: 11, // خط أصغر ومناسب للجداول
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }
}