import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_demo_catalog.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_item_status.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_product.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/adaptive_layout.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/cart_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/demo_barcode_sheet.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/discount_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/item_search_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/labor_pricing_dialog.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/payment_card.dart';

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

  Future<void> _addByCode() async {
    final product = _catalog.findByCode(_codeController.text);

    if (product == null) {
      _showMessage('الكود غير موجود في السجل.');
      return;
    }

    if (product.status != GoldItemStatus.available) {
      _showMessage(_unavailableMessage(product.status));
      return;
    }

    if (_cart.items.any(
      (existing) =>
          existing.code.trim().toUpperCase() ==
          product.code.trim().toUpperCase(),
    )) {
      _showMessage('القطعة مضافة بالفعل.');
      return;
    }

    if (_cart.items.length >= 2) {
      _showMessage('يسمح بإضافة قطعتين كحد أقصى.');
      return;
    }

    final labor = await showLaborPricingDialog(context);
    if (!mounted || labor == null) return;

    final input = GoldSaleInput(
      grossWeightMg: product.grossWeightMg,
      stonesWeightMg: product.stonesWeightMg,
      karat: product.karat,
      goldPricePerGramPiasters: product.goldPricePerGramPiasters,
      laborValue: labor.value,
      laborPricingType: labor.type,
    );

    try {
      setState(() {
        _cart.add(
          GoldSaleCartItem(
            code: product.code,
            status: product.status,
            input: input,
          ),
        );
        _codeController.clear();
      });
    } on StateError {
      _showMessage(
        'لا يمكن إضافة القطعة. تأكد أنها غير مكررة وألا يتجاوز العدد قطعتين.',
      );
    } on ArgumentError {
      _showMessage('بيانات القطعة أو المصنعية غير صالحة.');
    }
  }

  Future<void> _chooseDemoBarcode() async {
    final product = await showModalBottomSheet<GoldSaleProduct>(
      backgroundColor: Color(0XFFE8F7EE),
      context: context,
      useSafeArea: true,
      builder: (_) => DemoBarcodeSheet(items: _catalog.demoItems),
    );

    if (!mounted || product == null) return;

    _codeController.text = product.code;
    await _addByCode();
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

  final _paymentValidator = const GoldSalePaymentValidator();

  void _validatePayments(List<GoldSalePayment> payments) {
    try {
      _paymentValidator.validate(
        amountDuePiasters: _cart.totalPiasters,
        payments: payments,
      );
      _showMessage('مجموع المدفوع مطابق للمستحق.');
    } on ArgumentError {
      _showMessage('مجموع المدفوع يجب أن يساوي المستحق.');
    }
  }

  void _applyDiscount(int discountPercent, String? approvalNumber) {
    try {
      setState(() {
        _cart.setDiscount(
          discountPercent: discountPercent,
          supervisorApprovalNumber: approvalNumber,
        );
      });
      _showMessage('تم تطبيق الخصم على الفاتورة.');
    } on ArgumentError {
      _showMessage('الخصم غير صالح. تأكد من النسبة ورقم موافقة المسؤول.');
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
          paymentPanel: _cart.items.isEmpty
              ? null
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DiscountCard(
                      initialDiscountPercent: _cart.discountPercent,
                      onApply: _applyDiscount,
                    ),
                    const SizedBox(height: 16),
                    PaymentCard(
                      amountDuePiasters: _cart.totalPiasters,
                      onSubmit: _validatePayments,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
