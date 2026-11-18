import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/views/gold_sale_view.dart';

void main() {
  runApp(const GoldShopApp());
}

class GoldShopApp extends StatelessWidget {
  const GoldShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بيع الذهب',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: GoldSaleView(),
    );
  }
}
