import 'package:flutter_test/flutter_test.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';

void main() {
  group('GoldSaleCalc', () {
    const calculator = GoldSaleCalc();

    test('calculates the required gold sale example', () {
      const input = GoldSaleInput(
        grossWeightMg: 4500,
        stonesWeightMg: 300,
        goldPricePerGramPiasters: 420000,
        laborValue: 12000,
        discountPercent: 10,
        laborPricingType: LaborPricingType.perGram,
      );

      final result = calculator.calculate(input);

      expect(result.netWeightMg, 4200);
      expect(result.goldValuePiasters, 1764000);
      expect(result.laborBeforeDiscountPiasters, 50400);
      expect(result.discountPiasters, 5040);
      expect(result.laborAfterDiscountPiasters, 45360);
      expect(result.taxPiasters, 6350);
      expect(result.totalPiasters, 1815710);
    });

    test('rejects stones weight equal to gross weight', () {
      const input = GoldSaleInput(
        grossWeightMg: 4500,
        stonesWeightMg: 4500,
        goldPricePerGramPiasters: 420000,
        laborValue: 12000,
        discountPercent: 10,
        laborPricingType: LaborPricingType.perGram,
      );

      expect(() => calculator.calculate(input), throwsArgumentError);
    });

    test('rejects discount above 10% without supervisor approval', () {
      const input = GoldSaleInput(
        grossWeightMg: 4500,
        stonesWeightMg: 300,
        goldPricePerGramPiasters: 420000,
        laborValue: 12000,
        discountPercent: 11,
        laborPricingType: LaborPricingType.perGram,
      );

      expect(() => calculator.calculate(input), throwsArgumentError);
    });

    test('accepts discount above 10% with supervisor approval number', () {
      const input = GoldSaleInput(
        grossWeightMg: 4500,
        stonesWeightMg: 300,
        goldPricePerGramPiasters: 420000,
        laborValue: 12000,
        discountPercent: 11,
        laborPricingType: LaborPricingType.perGram,
        supervisorApprovalNumber: 'APR-123',
      );

      expect(() => calculator.calculate(input), returnsNormally);
    });

    test('rejects zero gross weight', () {
      const input = GoldSaleInput(
        grossWeightMg: 0,
        stonesWeightMg: 0,
        goldPricePerGramPiasters: 420000,
        laborValue: 12000,
        discountPercent: 10,
        laborPricingType: LaborPricingType.perGram,
      );

      expect(() => calculator.calculate(input), throwsArgumentError);
    });

    test('rejects negative stones weight', () {
      const input = GoldSaleInput(
        grossWeightMg: 4500,
        stonesWeightMg: -1,
        goldPricePerGramPiasters: 420000,
        laborValue: 12000,
        discountPercent: 10,
        laborPricingType: LaborPricingType.perGram,
      );

      expect(() => calculator.calculate(input), throwsArgumentError);
    });

    test('rejects negative gold price', () {
      const input = GoldSaleInput(
        grossWeightMg: 4500,
        stonesWeightMg: 300,
        goldPricePerGramPiasters: -1,
        laborValue: 12000,
        discountPercent: 10,
        laborPricingType: LaborPricingType.perGram,
      );

      expect(() => calculator.calculate(input), throwsArgumentError);
    });

    test('rejects negative labor value', () {
      const input = GoldSaleInput(
        grossWeightMg: 4500,
        stonesWeightMg: 300,
        goldPricePerGramPiasters: 420000,
        laborValue: -1,
        discountPercent: 10,
        laborPricingType: LaborPricingType.perGram,
      );

      expect(() => calculator.calculate(input), throwsArgumentError);
    });
  });
}
