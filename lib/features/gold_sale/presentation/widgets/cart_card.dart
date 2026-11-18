import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/cart_card_item.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/money_row.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    super.key,
    required this.items,
    required this.results,
    required this.totalPiasters,
    required this.onRemove,
  });

  final List<GoldSaleCartItem> items;
  final List<GoldSaleLineResult> results;
  final int totalPiasters;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0XFFE8F7EE),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'القطع في الفاتورة (${items.length}/2)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'لا يوجد قطع. ابحث بالكود أو اختار باركود.',
                  textAlign: TextAlign.center,
                ),
              )
            else
              for (var index = 0; index < items.length; index++)
                CartCardItem(
                  item: items[index],
                  result: results[index],
                  onRemove: () => onRemove(items[index].code),
                ),
            const Divider(height: 24),
            MoneyRow(
              label: 'إجمالي الفاتورة',
              amount: totalPiasters,
              bold: true,
            ),
          ],
        ),
      ),
    );
  }
}
