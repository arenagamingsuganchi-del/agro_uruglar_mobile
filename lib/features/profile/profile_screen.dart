import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../../core/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

  void _showInfoDialog(BuildContext context, String title, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AgroTheme.surface,
          shape: RoundedRectangleBorder(borderRadius: AgroTheme.radius),
          title: Text(
            title,
            style: const TextStyle(color: AgroTheme.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Text(
              text,
              style: const TextStyle(color: AgroTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tushunarli", style: TextStyle(color: AgroTheme.primary)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroTheme.background,
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Welcome Section
            _buildProfileHeader(),
            const SizedBox(height: 24),
            // Contact Settings Cards
            _buildSectionHeader("Aloqa & Qo'llab-quvvatlash"),
            _buildSettingsItem(
              icon: Icons.phone_outlined,
              title: "Biz bilan bog'lanish",
              subtitle: "+998 (99) 123-45-67",
              onTap: () => _makeCall("+998991234567"),
            ),
            _buildSettingsItem(
              icon: Icons.telegram_outlined,
              title: "Telegram kanalimiz",
              subtitle: "@agrouruglar",
              onTap: () => _openTelegram("https://t.me/agrouruglar"),
            ),
            const SizedBox(height: 24),
            // Information Settings Cards
            _buildSectionHeader("Ma'lumotlar"),
            _buildSettingsItem(
              icon: Icons.info_outline,
              title: "Kompaniya haqida",
              subtitle: "Bizning maqsadimiz va yutuqlarimiz",
              onTap: () => _showInfoDialog(
                context,
                "Kompaniya haqida",
                "Agro-Uruglar - O'zbekistonda sifatli, sertifikatlangan va yuqori hosil beruvchi qishloq xo'jaligi urug'larini yetkazib beruvchi yetakchi kompaniya.\n\nBiz Italiya, Gollandiya, Ukraina va AQSH kabi davlatlarning eng yetakchi brendlari bilan to'g'ridan-to'g'ri ishlaymiz. Har bir urug' O'zbekiston iqlimiga moslashtirilgan bo'lib, yuqori hosildorlikni kafolatlaydi.",
              ),
            ),
            _buildSettingsItem(
              icon: Icons.gavel_outlined,
              title: "Foydalanish shartlari",
              subtitle: "Ilovadan foydalanish qoidalari",
              onTap: () => _showInfoDialog(
                context,
                "Foydalanish shartlari",
                "1. Ilova orqali ko'rsatilgan narxlar va mahsulot qoldiqlari o'zgarishi mumkin.\n\n2. Buyurtma berilgandan so'ng, menejerlarimiz ma'lumotlarni tasdiqlash uchun siz bilan bog'lanadi.\n\n3. Barcha xaridlar shartnoma yoki to'lov asosida amalga oshiriladi.",
              ),
            ),
            _buildSettingsItem(
              icon: Icons.security_outlined,
              title: "Maxfiylik siyosati",
              subtitle: "Sizning ma'lumotlaringiz xavfsizligi",
              onTap: () => _showInfoDialog(
                context,
                "Maxfiylik siyosati",
                "Ilova sizning shaxsiy ma'lumotlaringizni (ism, telefon raqami) faqat buyurtmalarni qayta ishlash va aloqaga chiqish maqsadida saqlaydi.\n\nMa'lumotlar uchinchi shaxslarga berilmaydi va shifrlangan holda saqlanadi.",
              ),
            ),
            const SizedBox(height: 120), // Spacing for float bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        color: AgroTheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        border: const Border(bottom: BorderSide(color: AgroTheme.border)),
      ),
      child: Row(
        children: [
          // Logo Icon box
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AgroTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AgroTheme.primary.withOpacity(0.3)),
            ),
            child: const Center(
              child: Text(
                "🌱",
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // User welcome
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Agro Urug'lar",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Premium dehqonchilik bozori",
                style: TextStyle(
                  fontSize: 12,
                  color: AgroTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 10.0),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AgroTheme.primary,
        letterSpacing: 0.5,
      ),
      child: Text(title.toUpperCase()),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: AgroTheme.radiusSm,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AgroTheme.surface,
            borderRadius: AgroTheme.radiusSm,
            border: Border.all(color: AgroTheme.border.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AgroTheme.textSecondary, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AgroTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: AgroTheme.textSecondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AgroTheme.textSecondary,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
