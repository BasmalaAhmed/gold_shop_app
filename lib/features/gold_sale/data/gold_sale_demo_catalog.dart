import 'package:gold_shop_app/features/gold_sale/domain/gold_item_status.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_product.dart';

class GoldSaleDemoCatalog {
  const GoldSaleDemoCatalog();

  static const Map<String, GoldSaleProduct> _records = {
    'DEMO-1001': GoldSaleProduct(
      code: 'DEMO-1001',
      status: GoldItemStatus.available,
      grossWeightMg: 4500,
      stonesWeightMg: 300,
      karat: 21,
    ),
    'DEMO-1002': GoldSaleProduct(
      code: 'DEMO-1002',
      status: GoldItemStatus.available,
      grossWeightMg: 3000,
      stonesWeightMg: 150,
      karat: 18,
    ),
    'DEMO-1003': GoldSaleProduct(
      code: 'DEMO-1003',
      status: GoldItemStatus.reserved,
      grossWeightMg: 5000,
      stonesWeightMg: 500,
      karat: 21,
    ),
    'DEMO-1004': GoldSaleProduct(
      code: 'DEMO-1004',
      status: GoldItemStatus.sold,
      grossWeightMg: 4000,
      stonesWeightMg: 0,
      karat: 24,
    ),
    'DEMO-1005': GoldSaleProduct(
      code: 'DEMO-1005',
      status: GoldItemStatus.inWorkshop,
      grossWeightMg: 4000,
      stonesWeightMg: 0,
      karat: 21,
    ),
    'DEMO-1006': GoldSaleProduct(
      code: 'DEMO-1006',
      status: GoldItemStatus.inTransit,
      grossWeightMg: 4000,
      stonesWeightMg: 0,
      karat: 18,
    ),
  };

  List<GoldSaleProduct> get demoItems => List.unmodifiable(_records.values);

  GoldSaleProduct? findByCode(String code) =>
      _records[code.trim().toUpperCase()];
}
