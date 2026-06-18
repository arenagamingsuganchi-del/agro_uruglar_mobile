import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../core/models/product.dart';
import '../repositories/agro_repository.dart';
import '../features/details/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  String _formatPrice(double price) {
    if (price == 0) return "Kelishilgan narx";
    // Formats 85000 to "85 000 so'm"
    final buffer = StringBuffer();
    final str = price.toInt().toString();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(' ');
      }
    }
    return '${buffer.toString().split('').reversed.join()} so\'m';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AgroTheme.surface,
          borderRadius: AgroTheme.radius,
          border: Border.all(color: AgroTheme.border),
          boxShadow: AgroTheme.shadows,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and badges
            Expanded(
              child: Stack(
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Dark tint gradient overlay for text readability on card tops
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Country badge top-left
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white24, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.country == 'Italiya' ? '🇮🇹' : 
                            product.country == 'Ukraina' ? '🇺🇦' : 
                            product.country == 'Gollandiya' ? '🇳🇱' : '🇺🇿',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.country,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite button top-right
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Consumer<AgroRepository>(
                      builder: (context, repo, child) {
                        final isFav = repo.isFavorite(product);
                        return ClipOval(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? AgroTheme.accentGold : Colors.white,
                                size: 18,
                              ),
                              onPressed: () => repo.toggleFavorite(product),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Brand row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Expanded(
                        child: Text(
                          product.brand.toUpperCase(),
                          style: const TextStyle(
                            color: AgroTheme.textSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AgroTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: AgroTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  // Price and Order arrow row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.packageSize,
                              style: TextStyle(
                                color: AgroTheme.textSecondary.withOpacity(0.7),
                                fontSize: 9,
                              ),
                            ),
                            Text(
                              _formatPrice(product.price),
                              style: const TextStyle(
                                color: AgroTheme.accentGold,
                                fontSize: 13,
                                fontWeight: FontWeight.extrabold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AgroTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
