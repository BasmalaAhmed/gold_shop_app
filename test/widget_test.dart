import 'package:flutter_test/flutter_test.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/views/gold_sale_view.dart';
import 'package:gold_shop_app/main.dart';

void main() {
  testWidgets('shows the gold sale screen', (tester) async {
    await tester.pumpWidget(const GoldShopApp());

    await tester.pumpAndSettle();

    expect(find.byType(GoldSaleView), findsOneWidget);
  });
}
