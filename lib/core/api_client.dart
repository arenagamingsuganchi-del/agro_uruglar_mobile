import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/product.dart';

class ApiClient {
  // 10.0.2.2 is the localhost loopback for Android Emulator.
  // 127.0.0.1/localhost is for iOS Simulator.
  static const String baseUrl = 'http://127.0.0.1:5000/api';

  final http.Client _client = http.Client();

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/categories')).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => Category.fromJson(item)).toList();
      }
    } catch (e) {
      // Fallback to local mock data if server is offline
    }
    return _getMockCategories();
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/products')).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((item) => Product.fromJson(item)).toList();
      }
    } catch (e) {
      // Fallback to local mock data if server is offline
    }
    return _getMockProducts();
  }

  List<Category> _getMockCategories() {
    return [
      Category(id: '1', name: "Beda urug'lari", icon: '🌱'),
      Category(id: '2', name: 'Sabzavot urug\'lari', icon: '🥕'),
      Category(id: '3', name: 'Poliz urug\'lari', icon: '🍉'),
      Category(id: '4', name: 'Don mahsulotlari', icon: '🌾'),
      Category(id: '5', name: 'Yem-xashak urug\'lari', icon: '🍀'),
    ];
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: '101',
        name: "Beda urug'i Bolton",
        categoryId: '1',
        categoryName: "Beda urug'lari",
        brand: 'Continental Seeds',
        country: 'Italiya',
        packageSize: '25 kg qop',
        price: 85000,
        imageUrl: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&q=80&w=600',
        description: "Bolton - Italiyaning eng mashhur va serhosil beda navi. Sovuqqa, qurg'oqchilikka chidamli. Yiliga 5-6 martagacha o'rim beradi va oqsil miqdori yuqori.",
        advantages: [
          "O'ta yuqori hosildorlik (yiliga 5-6 o'rim)",
          "Sovuq va qurg'oqchilikka mukammal chidamlilik",
          "Kasalik va zararkunandalarga qarshi tabiiy immunitet",
          "Oqsil va to'yimli moddalarga boy barglar",
        ],
        plantingPeriod: "Avgust - Sentyabr (kuzgi ekish) yoki Mart - Aprel (bahorgi ekish)",
        harvestInfo: "Birinchi o'rim ekishdan keyin 70-80 kunda tayyor bo'ladi.",
        yieldInfo: "Gektaridan o'rtacha 18-22 tonna quruq pichan hosili olinadi.",
        farmerResults: "Buxoro viloyatidagi dehqonlarimiz o'tgan mavsumda har bir o'rimda gektaridan 4 tonnadan ko'p hosil olishdi.",
        isPopular: true,
      ),
      Product(
        id: '102',
        name: "Sabzi urug'i Krasniy Gigant",
        categoryId: '2',
        categoryName: 'Sabzavot urug\'lari',
        brand: 'Nasko Seeds',
        country: 'Ukraina',
        packageSize: '1 kg metall banka',
        price: 120000,
        imageUrl: 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?auto=format&fit=crop&q=80&w=600',
        description: "Krasniy Gigant - kechpishar, yirik va shirin sabzi navi. Sharbat tayyorlash va qishga saqlash uchun juda qulay.",
        advantages: [
          "Yirik va silliq ildizmevalar (22-25 sm)",
          "Ajoyib shirin ta'm va sharbatliligi yuqori",
          "Uzoq muddat chirimay saqlanish xususiyati",
        ],
        plantingPeriod: "Mart - Aprel yoki Iyun - Iyul (kuzgi hosil uchun)",
        harvestInfo: "Ekishdan keyin 110-120 kunda yetiladi.",
        yieldInfo: "Gektaridan 60-80 tonnagacha hosil olish imkoniyati mavjud.",
        farmerResults: "Samarqandlik fermerimiz gektaridan 72 tonna hosil oldi va 6 oy saqlaganda ham sifati buzilmadi.",
        isPopular: true,
      ),
      Product(
        id: '103',
        name: "Tarvuz urug'i Krizbi F1",
        categoryId: '3',
        categoryName: 'Poliz urug\'lari',
        brand: 'Nunhems',
        country: 'Gollandiya',
        packageSize: '1000 dona paket',
        price: 240000,
        imageUrl: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?auto=format&fit=crop&q=80&w=600',
        description: "Krizbi F1 - o'ta ertapishar tarvuz gibridi. Po'sti mustahkam, uzoq masofaga tashishga chidamli va mazasi shirin.",
        advantages: [
          "O'ta ertapishar (58-62 kunda yetiladi)",
          "Tashish (transport) uchun o'ta chidamli po'st",
          "Shakari ko'p va rangi to'q qizil",
        ],
        plantingPeriod: "Aprel boshidan plyonka ostiga ekish",
        harvestInfo: "Nihol unib chiqqandan keyin 60 kunda birinchi hosil uziladi.",
        yieldInfo: "Gektaridan o'rtacha 45-55 tonna shirin tarvuz.",
        farmerResults: "Jizzax viloyatida erta bahorda ekilib, bozorda eng qimmat paytda sotildi.",
        isPopular: false,
      ),
      Product(
        id: '104',
        name: "Makkajo'xori DKC 6761",
        categoryId: '4',
        categoryName: 'Don mahsulotlari',
        brand: 'Dekalb (Bayer)',
        country: 'AQSH',
        packageSize: '80 000 dona qop',
        price: 1850000,
        imageUrl: 'https://images.unsplash.com/photo-1551754655-cd27e38d20f6?auto=format&fit=crop&q=80&w=600',
        description: "Dekalb DKC 6761 - don va silos uchun mo'ljallangan yuqori texnologiyali makkajo'xori gibridi. Issiqqa o'ta chidamli va don to'lishishi a'lo darajada.",
        advantages: [
          "FAO 460 - issiq iqlimga juda mos",
          "Silos uchun ham don uchun ham birdek yuqori natija",
          "Kuchli ildiz tizimi hisobiga yotib qolmaydi",
        ],
        plantingPeriod: "Aprel o'rtalaridan May boshigacha",
        harvestInfo: "120-130 kunda to'liq pishib yetiladi.",
        yieldInfo: "Don hosili gektariga 14-16 tonna, yashil massa 65-75 tonna.",
        farmerResults: "Toshkent viloyatida don yo'nalishida 14.8 tonna hosil qayd etildi.",
        isPopular: true,
      ),
    ];
  }
}
