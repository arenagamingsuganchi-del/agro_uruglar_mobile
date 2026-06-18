import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../../core/theme.dart';
import '../../core/models/product.dart';
import '../../repositories/agro_repository.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  String _formatPrice(double price) {
    if (price == 0) return "Kelishilgan narx";
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

  void _makeCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri);
    }
  }

  void _openTelegram(String url) async {
    final uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(uri, mode: launcher.LaunchMode.externalApplication);
    }
  }

  void _showOrderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AgroTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 45,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AgroTheme.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Buyurtma berish / Maslahat",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AgroTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "\"${product.name}\" mahsuloti bo'yicha biz bilan quyidagi aloqa kanallari orqali bog'lanishingiz mumkin:",
                  style: const TextStyle(
                    fontSize: 13,
                    color: AgroTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Call Phone Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _makeCall("+998991234567"); // Mock number matching database
                  },
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: const Text(
                    "Telefon orqali bog'lanish",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AgroTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: AgroTheme.radiusSm),
                  ),
                ),
                const SizedBox(height: 12),
                // Telegram Chat Button
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _openTelegram("https://t.me/agrouruglar");
                  },
                  icon: const Icon(Icons.telegram, color: AgroTheme.accentGold),
                  label: const Text(
                    "Telegram orqali yozish",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AgroTheme.accentGold, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: AgroTheme.radiusSm),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroTheme.background,
      body: Stack(
        children: [
          // Content Scroll View
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom Elastic Header Image
              SliverAppBar(
                expandedHeight: 320,
                pinned: true,
                stretch: true,
                backgroundColor: AgroTheme.background,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Consumer<AgroRepository>(
                          builder: (context, repo, child) {
                            final isFav = repo.isFavorite(product);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? AgroTheme.accentGold : Colors.white,
                              ),
                              onPressed: () => repo.toggleFavorite(product),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay to highlight title
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AgroTheme.background.withOpacity(0.8),
                              AgroTheme.background,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Specs and content
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tag badges
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AgroTheme.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: AgroTheme.primary.withOpacity(0.3)),
                              ),
                              child: Text(
                                product.categoryName,
                                style: const TextStyle(
                                  color: AgroTheme.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AgroTheme.accentGold.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: AgroTheme.accentGold.withOpacity(0.3)),
                              ),
                              child: Text(
                                product.brand,
                                style: const TextStyle(
                                  color: AgroTheme.accentGold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Title and Price
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AgroTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            Text(
                              _formatPrice(product.price),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.extrabold,
                                color: AgroTheme.accentGold,
                              ),
                            ),
                            Text(
                              product.packageSize,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AgroTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: AgroTheme.border),
                        const SizedBox(height: 12),
                        // Description section
                        const Text(
                          "Mahsulot tavsifi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AgroTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AgroTheme.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Advantages section
                        if (product.advantages.isNotEmpty) ...[
                          const Text(
                            "Afzalliklari",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AgroTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...product.advantages.map((adv) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: AgroTheme.primary,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    adv,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AgroTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                          const SizedBox(height: 24),
                        ],
                        // Cultivation and specs grid
                        const Text(
                          "Ekish va Hosildorlik ma'lumotlari",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AgroTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: [
                            _buildSpecCard("Ekish davri", product.plantingPeriod, Icons.calendar_today),
                            _buildSpecCard("Yetilish muddati", product.harvestInfo, Icons.timelapse),
                            _buildSpecCard("Kutilayotgan hosil", product.yieldInfo, Icons.trending_up),
                            _buildSpecCard("Ishlab chiqarilgan", product.country, Icons.public),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Farmer results
                        if (product.farmerResults.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AgroTheme.surface,
                              borderRadius: AgroTheme.radius,
                              border: Border.all(color: AgroTheme.border.withOpacity(0.4)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.emoji_events_outlined, color: AgroTheme.accentGold, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      "Dehqonlarimiz natijalari",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AgroTheme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.farmerResults,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AgroTheme.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 100), // Spacing for bottom button bar
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          // Floating Action Bar at the Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AgroTheme.surface.withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: const Border(top: BorderSide(color: AgroTheme.border, width: 0.5)),
              ),
              child: Row(
                children: [
                  // Call Button
                  IconButton(
                    icon: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: AgroTheme.radiusSm,
                      ),
                      child: const Icon(Icons.phone, color: Colors.white, size: 20),
                    ),
                    onPressed: () => _makeCall("+998991234567"),
                  ),
                  const SizedBox(width: 8),
                  // Chat Button
                  IconButton(
                    icon: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: AgroTheme.radiusSm,
                      ),
                      child: const Icon(Icons.telegram, color: AgroTheme.accentGold, size: 22),
                    ),
                    onPressed: () => _openTelegram("https://t.me/agrouruglar"),
                  ),
                  const SizedBox(width: 12),
                  // Main Order Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AgroTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: AgroTheme.radiusSm,
                          ),
                        ),
                        onPressed: () => _showOrderBottomSheet(context),
                        child: const Text(
                          "BUYURTMA BERISH",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AgroTheme.surface,
        borderRadius: AgroTheme.radiusSm,
        border: Border.all(color: AgroTheme.border.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AgroTheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AgroTheme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AgroTheme.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
