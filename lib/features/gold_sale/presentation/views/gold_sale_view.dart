import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_demo_catalog.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_item_status.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/adaptive_layout.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/cart_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/demo_barcode_sheet.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/item_search_card.dart';

class GoldSaleView extends StatefulWidget {
  const GoldSaleView({super.key});

  @override
  State<GoldSaleView> createState() => _GoldSaleViewState();
}

class _GoldSaleViewState extends State<GoldSaleView> {
  final _codeController = TextEditingController();
  final _catalog = const GoldSaleDemoCatalog();
  final _cart = GoldSaleCart();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _addByCode() {
    final item = _catalog.findByCode(_codeController.text);

    if (item == null) {
      _showMessage('الكود ليس موجود في السجل.');
      return;
    }

    if (item.status != GoldItemStatus.available) {
      _showMessage(_unavailableMessage(item.status));
      return;
    }

    try {
      setState(() {
        _cart.add(item);
        _codeController.clear();
      });
    } on StateError catch (error) {
      final message = error.message.toString();

      if (message.contains('already')) {
        _showMessage('القطعة مضافة بالفعل.');
      } else {
        _showMessage('مسموح إضافة قطعتين كحد أقصى.');
      }
    }
  }

  Future<void> _chooseDemoBarcode() async {
    final item = await showModalBottomSheet<GoldSaleCartItem>(
      context: context,
      useSafeArea: true,
      builder: (_) => DemoBarcodeSheet(items: _catalog.demoItems),
    );

    if (!mounted || item == null) return;

    _codeController.text = item.code;
    _addByCode();
  }

  void _removeByCode(String code) {
    setState(() {
      _cart.removeByCode(code);
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _unavailableMessage(GoldItemStatus status) {
    switch (status) {
      case GoldItemStatus.reserved:
        return 'القطعة محجوزة و غير متاحة للبيع.';
      case GoldItemStatus.sold:
        return 'القطعة مباعة بالفعل.';
      case GoldItemStatus.inWorkshop:
        return 'القطعة في الورشة.';
      case GoldItemStatus.inTransit:
        return 'القطعة في الطريق.';
      case GoldItemStatus.available:
        return 'القطعة متاحة للبيع.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF49111C),
      appBar: AppBar(
        title: const Text('بيع الذهب'),
        centerTitle: true,
        backgroundColor: Color(0XFF49111C),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: AdaptiveLayout(
          searchPanel: ItemSearchCard(
            codeController: _codeController,
            onSearch: _addByCode,
            onChooseDemoBarcode: _chooseDemoBarcode,
          ),
          cartPanel: CartCard(
            items: _cart.items,
            results: _cart.lineResults,
            totalPiasters: _cart.totalPiasters,
            onRemove: _removeByCode,
          ),
        ),
      ),
    );
  }
}
