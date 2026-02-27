import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_strings.dart';
import '../../database/daos/catalog_dao.dart';
import '../../database/database.dart';

class ProductSelectionScreen extends ConsumerStatefulWidget {
  final bool isSingleSelection;
  const ProductSelectionScreen({Key? key, this.isSingleSelection = false}) : super(key: key);

  @override
  ConsumerState<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends ConsumerState<ProductSelectionScreen> {
  String _searchQuery = '';
  // قائمة لحفظ المواد المحددة لإضافتها دفعة واحدة
  final Set<Product> _selectedProducts = {};

  @override
  Widget build(BuildContext context) {
    final dao = ref.watch(catalogDaoProvider);

    return FutureBuilder<List<ProductCategory>>(
      future: dao.db.select(dao.db.productCategories).get(),
      builder: (context, catSnapshot) {
        if (!catSnapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final categories = catSnapshot.data!;

        return DefaultTabController(
          length: categories.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('تحديد المواد'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Column(
                  children:[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: InputDecoration(
                          hintText: AppStrings.search,
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                    TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      tabs: categories.map((c) => Tab(text: c.name)).toList(),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: (!widget.isSingleSelection && _selectedProducts.isNotEmpty)
                ? FloatingActionButton.extended(
              onPressed: () => Navigator.pop(context, _selectedProducts.toList()),
              label: Text('إضافة ${_selectedProducts.length} مواد'),
              icon: const Icon(Icons.check),
              backgroundColor: Colors.green,
            )
                : null,
            body: TabBarView(
              children: categories.map((category) {
                return StreamBuilder<List<Product>>(
                  stream: dao.watchActiveProductsByCategory(category.id),
                  builder: (context, prodSnapshot) {
                    if (!prodSnapshot.hasData) return const Center(child: CircularProgressIndicator());
                    var products = prodSnapshot.data!;

                    if (_searchQuery.trim().isNotEmpty) {
                      products = products.where((p) =>
                      p.name.contains(_searchQuery) || p.code.contains(_searchQuery) ||
                          (p.unit1Barcode?.contains(_searchQuery) ?? false) ||
                          (p.unit2Barcode?.contains(_searchQuery) ?? false) ||
                          (p.unit3Barcode?.contains(_searchQuery) ?? false)
                      ).toList();
                    }

                    if (products.isEmpty) return const Center(child: Text('لا توجد مواد'));

                    return GridView.builder(
                      padding: const EdgeInsets.all(8).copyWith(bottom: 80),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: category.gridColumns > 0 ? category.gridColumns : 2,
                        mainAxisExtent: 90, // 👈 ارتفاع ثابت يمنع الخطأ الأحمر تماماً
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final isSelected = _selectedProducts.contains(product);

                        return InkWell(
                          onTap: () {
                            if (widget.isSingleSelection) {
                              Navigator.pop(context, [product]);
                            } else {
                              setState(() {
                                if (isSelected) _selectedProducts.remove(product);
                                else _selectedProducts.add(product);
                              });
                            }
                          },
                          child: Card(
                            color: isSelected ? Colors.blue[100] : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: isSelected ? Colors.blue : Colors.grey.shade300, width: isSelected ? 2 : 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Expanded(
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown, // 👈 يقوم بتصغير الخط تلقائياً إذا كان طويلاً
                                        child: Text(
                                          product.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                        product.code,
                                        style: const TextStyle(color: Colors.grey, fontSize: 10)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}