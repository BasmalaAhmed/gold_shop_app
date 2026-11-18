import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/discount_card.dart';

void main() {
  testWidgets('shows approval number field when discount exceeds 10%', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DiscountCard(
            initialDiscountPercent: 0,
            onApply: _ignoreDiscount,
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('discountPercentField')),
      '11',
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('approvalNumberField')), findsOneWidget);
  });
}

void _ignoreDiscount(int discountPercent, String? approvalNumber) {}
