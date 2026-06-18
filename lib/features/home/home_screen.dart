import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../repositories/agro_repository.dart';
import '../../widgets/product_card.dart';
import '../../widgets/skeleton_loader.dart';

class HomeScreen extends StatelessWidget {
  final Function(int, String?) onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroTheme.background,
      body: Consumer<AgroRepository>(
        builder: (context, repo, child) {
          if (repo.isLoading) {
            return const _HomeLoadingState();
          }

          final popular = repo.getPopularProducts();

          return RefreshIndicator(
            onRefresh: () => repo.loadData(),
            color: AgroTheme.primary,
            backgroundColor: AgroTheme.surface,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section Welcome Banner
                  _buildHeroSection(context),
                  const SizedBox(height: 24),
                  // Categories Row
                  _buildCategoriesSection(context, repo),
                  const SizedBox(height: 28),
                  // Featured Products Grid Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.between,
                      children: [
                        const Text(
                          "Ommabop mahsulotlar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AgroTheme.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => onNavigateToTab(1, null), // Go to catalog tab
                          child: const Text(
                            "Barchasi",
                            style: TextStyle(color: AgroTheme.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Grid List
                  if (popular.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Text("Hozircha ommabop mahsulotlar yo'q."),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: popular.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.72,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(product: popular[index]);
                        },
                      ),
                    ),
                  const SizedBox(height: 100), // Navigation spacing
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1625246333195-78d9c38ad449?auto=format&fit=crop&q=80&w=1000"), // Farming background
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.3),
              AgroTheme.background.withOpacity(0.9),
              AgroTheme.background,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Outlined badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AgroTheme.accentGold.withOpacity(0.8), width: 1.2),
              ),
              child: const Text(
                "PREMIUM SIFAT",
                style: TextStyle(
                  color: AgroTheme.accentGold,
                  fontSize: 10,
                  fontWeight: FontWeight.extrabold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Welcome quote
            const Text(
              "Sifatli urug'.\nKo'rinadigan hosil.\nIshonchli tanlov.",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 14),
            // Dummy search input trigger
            GestureDetector(
              onTap: () => onNavigateToTab(1, null), // Redirect to Catalog Search
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AgroTheme.surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AgroTheme.border),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: AgroTheme.textSecondary, size: 20),
                    SizedBox(width: 12),
                    Text(
                      "Urug'lar yoki brendlarni qidirish...",
                      style: TextStyle(color: AgroTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, AgroRepository repo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Kategoriyalar",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AgroTheme.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: repo.categories.length,
            itemBuilder: (context, index) {
              final cat = repo.categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  onTap: () => onNavigateToTab(1, cat.id), // Direct to catalog filters
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AgroTheme.surface,
                      borderRadius: AgroTheme.radiusSm,
                      border: Border.all(color: AgroTheme.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat.icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 6),
                        Text(
                          cat.name,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AgroTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HomeLoadingState extends StatelessWidget {
  const _HomeLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkeletonLoader(width: double.infinity, height: 280, borderRadius: BorderRadius.zero),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SkeletonLoader(width: 140, height: 20),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SkeletonLoader(width: 100, height: 90, borderRadius: AgroTheme.radiusSm),
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SkeletonLoader(width: 180, height: 20),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                SkeletonCard(),
                SkeletonCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
