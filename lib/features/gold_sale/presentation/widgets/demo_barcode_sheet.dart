import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_item_status.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';

class DemoBarcodeSheet extends StatelessWidget {
  const DemoBarcodeSheet({super.key, required this.items});

  final List<GoldSaleCartItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text('اختيار باركود'),
          for (final item in items)
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: Text(item.code),
              subtitle: Text(_statusLabel(item.status)),
              onTap: () => Navigator.of(context).pop(item),
            ),
        ],
      ),
    );
  }

  String _statusLabel(GoldItemStatus status) {
    switch (status) {
      case GoldItemStatus.available:
        return 'متاحة';
      case GoldItemStatus.reserved:
        return 'محجوزة';
      case GoldItemStatus.sold:
        return 'مباعة';
      case GoldItemStatus.inWorkshop:
        return 'في الورشة';
      case GoldItemStatus.inTransit:
        return 'في الطريق';
    }
  }
}
