import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/models/product.dart';
import '../../repositories/agro_repository.dart';
import '../../widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  final String? initialCategoryId;

  const CatalogScreen({
    super.key,
    this.initialCategoryId,
  });

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoryId;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
  }

  @override
  void didUpdateWidget(covariant CatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategoryId != oldWidget.initialCategoryId) {
      setState(() {
        _selectedCategoryId = widget.initialCategoryId;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroTheme.background,
      appBar: AppBar(
        title: const Text("Katalog"),
        centerTitle: false,
      ),
      body: Consumer<AgroRepository>(
        builder: (context, repo, child) {
          // Search & Filter evaluation logic
          List<Product> displayedProducts = [];
          if (_searchQuery.trim().isNotEmpty) {
            displayedProducts = repo.searchProducts(_searchQuery);
            if (_selectedCategoryId != null) {
              displayedProducts = displayedProducts.where((p) => p.categoryId == _selectedCategoryId).toList();
            }
          } else if (_selectedCategoryId != null) {
            displayedProducts = repo.getProductsByCategory(_selectedCategoryId!);
          } else {
            displayedProducts = repo.products;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AgroTheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AgroTheme.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    style: const TextStyle(color: AgroTheme.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Mahsulot, brend yoki davlat nomi...",
                      hintStyle: const TextStyle(color: AgroTheme.textSecondary, fontSize: 13),
                      prefixIcon: const Icon(Icons.search, color: AgroTheme.textSecondary, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: AgroTheme.textSecondary, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              // Categories horizontally scrollable selector pills
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: repo.categories.length + 1,
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final cat = isAll ? null : repo.categories[index - 1];
                    final isSelected = isAll
                        ? _selectedCategoryId == null
                        : _selectedCategoryId == cat?.id;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = isAll ? null : cat?.id;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AgroTheme.primary : AgroTheme.surface,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isSelected ? AgroTheme.primary : AgroTheme.border,
                            ),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                if (!isAll) ...[
                                  Text(cat!.icon),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  isAll ? "Barchasi 🌿" : cat!.name,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AgroTheme.textSecondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Results info tag
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "${displayedProducts.length} ta mahsulot topildi",
                  style: const TextStyle(
                    fontSize: 12,
                    color: AgroTheme.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Products grid view
              Expanded(
                child: displayedProducts.isEmpty
                    ? const Center(
                        child: Text("Bunday mahsulot topilmadi."),
                      )
                    : GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                        itemCount: displayedProducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(product: displayedProducts[index]);
                        },
                      ),
              ),
              const SizedBox(height: 80), // bottom nav space
            ],
          );
        },
      ),
    );
  }
}
