import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'repositories/agro_repository.dart';
import 'features/navigation/navigation_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AgroRepository()..loadData()),
      ],
      child: const AgroApp(),
    ),
  );
}

class AgroApp extends StatelessWidget {
  const AgroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agro Urug'lar",
      debugShowCheckedModeBanner: false,
      theme: AgroTheme.darkTheme,
      home: const NavigationShell(),
    );
  }
}
