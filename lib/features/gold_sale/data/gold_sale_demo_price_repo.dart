import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_price_repo.dart';

class GoldSaleDemoPriceRepo implements GoldSalePriceRepo {
  const GoldSaleDemoPriceRepo();

  static const Map<int, int> _salePricesByKarat = {
    24: 560000,
    21: 420000,
    18: 360000,
  };

  @override
  Future<int> getSalePricePerGramPiasters(int karat) async {
    final price = _salePricesByKarat[karat];

    if (price == null) {
      throw StateError('No sale price configured for karat $karat.');
    }

    return price;
  }
}
