import 'package:gold_shop_app/features/gold_sale/domain/gold_item_status.dart';

import 'gold_sale_calc.dart';

class GoldSaleCartItem {
  const GoldSaleCartItem({
    required this.code,
    required this.input,
    required this.status,
  });

  final String code;
  final GoldSaleInput input;
  final GoldItemStatus status;
}

class GoldSaleCart {
  final GoldSaleCalc _calculator = const GoldSaleCalc();
  final List<GoldSaleCartItem> _items = [];
  int get discountPercent => _discountPercent;

  List<GoldSaleCartItem> get items => List.unmodifiable(_items);

  List<GoldSaleLineResult> get lineResults => List.unmodifiable(
    _items.map(
      (item) => _calculator.calculate(
        item.input,
        discountPercent: _discountPercent,
        supervisorApprovalNumber: _supervisorApprovalNumber,
      ),
    ),
  );

  int get totalPiasters =>
      lineResults.fold(0, (total, line) => total + line.totalPiasters);

  void add(GoldSaleCartItem item) {
    final normalizedCode = _normalizeCode(item.code);

    if (normalizedCode.isEmpty) {
      throw ArgumentError('Item code cannot be empty.');
    }

    if (item.status != GoldItemStatus.available) {
      throw StateError('This item is not available for a normal sale.');
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
    _calculator.calculate(
      item.input,
      discountPercent: _discountPercent,
      supervisorApprovalNumber: _supervisorApprovalNumber,
    );

    _items.add(item);
  }

  void removeByCode(String code) {
    final normalizedCode = _normalizeCode(code);

    _items.removeWhere((item) => _normalizeCode(item.code) == normalizedCode);
  }

  String _normalizeCode(String code) => code.trim().toUpperCase();

  int _discountPercent = 0;
  String? _supervisorApprovalNumber;

  void setDiscount({
    required int discountPercent,
    String? supervisorApprovalNumber,
  }) {
    final approvalNumber = supervisorApprovalNumber?.trim();

    _calculator.validateDiscount(
      discountPercent: discountPercent,
      supervisorApprovalNumber: approvalNumber,
    );

    for (final item in _items) {
      _calculator.calculate(
        item.input,
        discountPercent: discountPercent,
        supervisorApprovalNumber: approvalNumber,
      );
    }

    _supervisorApprovalNumber = approvalNumber == null || approvalNumber.isEmpty
        ? null
        : approvalNumber;
    _discountPercent = discountPercent;
  }
}
