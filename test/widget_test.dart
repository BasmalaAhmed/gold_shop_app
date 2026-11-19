import 'package:flutter_test/flutter_test.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/views/gold_sale_view.dart';
import 'package:gold_shop_app/main.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });
  testWidgets('shows the gold sale screen', (tester) async {
    await tester.pumpWidget(const GoldShopApp());

    await tester.pumpAndSettle();

    expect(find.byType(GoldSaleView), findsOneWidget);
  });
}
