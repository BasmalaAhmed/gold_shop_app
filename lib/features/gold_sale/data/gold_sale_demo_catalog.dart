import 'package:gold_shop_app/features/gold_sale/domain/gold_item_status.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';

class GoldSaleDemoCatalog {
  const GoldSaleDemoCatalog();

  static const Map<String, GoldSaleCartItem> _records = {
    'DEMO-1001': GoldSaleCartItem(
      code: 'DEMO-1001',
      status: GoldItemStatus.available,
      input: GoldSaleInput(
        grossWeightMg: 4500,
        stonesWeightMg: 300,
        karat: 21,
        goldPricePerGramPiasters: 420000,
        laborValue: 12000,
        laborPricingType: LaborPricingType.perGram,
        discountPercent: 10,
      ),
    ),
    'DEMO-1002': GoldSaleCartItem(
      code: 'DEMO-1002',
      status: GoldItemStatus.available,
      input: GoldSaleInput(
        grossWeightMg: 3000,
        stonesWeightMg: 150,
        karat: 18,
        goldPricePerGramPiasters: 360000,
        laborValue: 15000,
        laborPricingType: LaborPricingType.fixed,
        discountPercent: 5,
      ),
    ),
    'DEMO-1003': GoldSaleCartItem(
      code: 'DEMO-1003',
      status: GoldItemStatus.reserved,
      input: GoldSaleInput(
        grossWeightMg: 5000,
        stonesWeightMg: 500,
        karat: 21,
        goldPricePerGramPiasters: 420000,
        laborValue: 12000,
        laborPricingType: LaborPricingType.perGram,
        discountPercent: 0,
      ),
    ),
  };

  List<GoldSaleCartItem> get demoItems => List.unmodifiable(_records.values);

  GoldSaleCartItem? findByCode(String code) {
    final normalizedCode = code.trim().toUpperCase();
    return _records[normalizedCode];
  }
}
