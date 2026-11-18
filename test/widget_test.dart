import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gold_shop_app/main.dart';

void main() {
  testWidgets('shows the gold sale screen', (tester) async {
    await tester.pumpWidget(const GoldShopApp());

    expect(find.text('بيع الذهب'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}