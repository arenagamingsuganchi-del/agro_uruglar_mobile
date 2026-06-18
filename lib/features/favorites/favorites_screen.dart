import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../repositories/agro_repository.dart';
import '../../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroTheme.background,
      appBar: AppBar(
        title: const Text("Saralanganlar"),
        centerTitle: false,
      ),
      body: Consumer<AgroRepository>(
        builder: (context, repo, child) {
          final favs = repo.favorites;

          if (favs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: AgroTheme.textSecondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Saralangan mahsulotlar yo'q",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AgroTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "O'zingizga ma'qul bo'lgan urug'larni\nsaralanganlar ro'yxatiga qo'shing.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AgroTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            itemCount: favs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return ProductCard(product: favs[index]);
            },
          );
        },
      ),
    );
  }
}
