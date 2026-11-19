import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/money_row.dart';

class CartCardItem extends StatelessWidget {
  const CartCardItem({
    super.key,
    required this.item,
    required this.result,
    required this.onRemove,
  });

  final GoldSaleCartItem item;
  final GoldSaleLineResult result;
  final VoidCallback onRemove;

  String _formatWeight(int weightMg) {
    final grams = weightMg ~/ 1000;
    final milligrams = (weightMg % 1000).toString().padLeft(3, '0');
    return '$grams.$milligrams جم';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.code} — ${item.input.karat} قيراط',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    tooltip: 'حذف القطعة',
                    onPressed: onRemove,
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
              Text('الوزن الصافي: ${_formatWeight(result.netWeightMg)}'),
              const SizedBox(height: 8),
              MoneyRow(label: 'قيمة الذهب', amount: result.goldValuePiasters),
              MoneyRow(label: 'الخصم', amount: result.discountPiasters),
              MoneyRow(
                label: 'المصنعية',
                amount: result.laborAfterDiscountPiasters,
              ),
              MoneyRow(label: 'الضريبة', amount: result.taxPiasters),
              Divider(color: Theme.of(context).colorScheme.tertiary),
              MoneyRow(
                label: 'إجمالي القطعة',
                amount: result.totalPiasters,
                bold: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
