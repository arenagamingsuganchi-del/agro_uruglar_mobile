import 'package:flutter/foundation.dart';
import '../core/api_client.dart';
import '../core/models/product.dart';

class AgroRepository with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();

  List<Product> _products = [];
  List<Category> _categories = [];
  final Set<String> _favoriteIds = {};
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  List<Product> get favorites {
    return _products.where((p) => _favoriteIds.contains(p.id)).toList();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Fetch concurrently or sequentially
      _categories = await _apiClient.fetchCategories();
      _products = await _apiClient.fetchProducts();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading repository data: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favoriteIds.contains(product.id);
  }

  List<Product> getProductsByCategory(String categoryId) {
    return _products.where((p) => p.categoryId == categoryId).toList();
  }

  List<Product> getPopularProducts() {
    return _products.where((p) => p.isPopular).toList();
  }

  List<Product> searchProducts(String query) {
    if (query.trim().isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _products.where((p) {
      return p.name.toLowerCase().contains(lowerQuery) ||
             p.brand.toLowerCase().contains(lowerQuery) ||
             p.categoryName.toLowerCase().contains(lowerQuery) ||
             p.country.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
