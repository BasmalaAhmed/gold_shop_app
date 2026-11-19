import 'gold_item_status.dart';

class GoldSaleProduct {
  const GoldSaleProduct({
    required this.code,
    required this.status,
    required this.grossWeightMg,
    required this.stonesWeightMg,
    required this.karat,
  });

  final String code;
  final GoldItemStatus status;
  final int grossWeightMg;
  final int stonesWeightMg;
  final int karat;
}