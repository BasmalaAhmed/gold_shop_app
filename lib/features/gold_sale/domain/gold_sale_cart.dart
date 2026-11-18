import 'gold_sale_calc.dart';

class GoldSaleCartItem {
  const GoldSaleCartItem({required this.code, required this.input});

  final String code;
  final GoldSaleInput input;
}

class GoldSaleCart {
  final GoldSaleCalc _calculator = const GoldSaleCalc();
  final List<GoldSaleCartItem> _items = [];

  List<GoldSaleCartItem> get items => List.unmodifiable(_items);

  List<GoldSaleLineResult> get lineResults =>
      List.unmodifiable(_items.map((item) => _calculator.calculate(item.input)));

  int get totalPiasters =>
      lineResults.fold(0, (total, line) => total + line.totalPiasters);

  void add(GoldSaleCartItem item) {
    final normalizedCode = _normalizeCode(item.code);

    if (normalizedCode.isEmpty) {
      throw ArgumentError('Item code cannot be empty.');
    }

    final alreadyAdded = _items.any(
      (existing) => _normalizeCode(existing.code) == normalizedCode,
    );

    if (alreadyAdded) {
      throw StateError('This item is already in the sale.');
    }

    if (_items.length >= 2) {
      throw StateError('A sale can contain at most two items.');
    }

    _items.add(item);
  }

  void removeByCode(String code) {
    final normalizedCode = _normalizeCode(code);

    _items.removeWhere((item) => _normalizeCode(item.code) == normalizedCode);
  }

  String _normalizeCode(String code) => code.trim().toUpperCase();
}
