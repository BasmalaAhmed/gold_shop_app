import 'package:flutter_test/flutter_test.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';

void main() {
  group('GoldSaleBasket', () {
    GoldSaleCartItem item(String code) {
      return GoldSaleCartItem(
        code: code,
        input: const GoldSaleInput(
          grossWeightMg: 4500,
          stonesWeightMg: 300,
          goldPricePerGramPiasters: 420000,
          laborValue: 12000,
          discountPercent: 10,
          laborPricingType: LaborPricingType.perGram,
        ),
      );
    }

    test('adds two different items and sums their rounded totals', () {
      final basket = GoldSaleCart()
        ..add(item('A-1'))
        ..add(item('B-2'));

      expect(basket.items, hasLength(2));
      expect(basket.totalPiasters, 3631420);
    });

    test('rejects the same code even if letter case differs', () {
      final basket = GoldSaleCart()..add(item('ab-1'));

      expect(() => basket.add(item('AB-1')), throwsStateError);
    });

    test('rejects a third item', () {
      final basket = GoldSaleCart()
        ..add(item('A-1'))
        ..add(item('B-2'));

      expect(() => basket.add(item('C-3')), throwsStateError);
    });
  });
}
