import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gold_shop_app/core/theme/app_theme.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_demo_price_repo.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/views/gold_sale_view.dart';

void main() {
  runApp(const GoldShopApp());
}

class GoldShopApp extends StatefulWidget {
  const GoldShopApp({super.key});

  @override
  State<GoldShopApp> createState() => _GoldShopAppState();
}

class _GoldShopAppState extends State<GoldShopApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بيع الذهب',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: _themeMode,
      darkTheme: AppTheme.darkTheme,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: GoldSaleView(onThemeToggle: _toggleTheme, priceRepository: const GoldSaleDemoPriceRepo(),),
    );
  }
}
