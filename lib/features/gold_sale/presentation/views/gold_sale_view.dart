import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_demo_catalog.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_draft.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_draft_repo.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_item_status.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment_method.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_price_repo.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_product.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/adaptive_layout.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/cart_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/demo_barcode_sheet.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/discount_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/item_search_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/labor_pricing_dialog.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/payment_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/theme_icon.dart';

class GoldSaleView extends StatefulWidget {
  const GoldSaleView({
    super.key,
    required this.onThemeToggle,
    required this.priceRepository,
  });

  final VoidCallback onThemeToggle;
  final GoldSalePriceRepo priceRepository;

  @override
  State<GoldSaleView> createState() => _GoldSaleViewState();
}

class _GoldSaleViewState extends State<GoldSaleView> {
  final _codeController = TextEditingController();
  final _catalog = const GoldSaleDemoCatalog();
  final _cart = GoldSaleCart();
  String _cashAmountText = '';
  String _otherAmountText = '';
  GoldSalePaymentMethod _otherPaymentMethod = GoldSalePaymentMethod.card;
  final _draftRepository = GoldSaleDraftRepo();
  bool _isLoadingDraft = true;
  Future<void> _saveQueue = Future<void>.value();

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    try {
      final draft = await _draftRepository.load();

      if (draft != null) {
        _cart.restore(
          items: draft.items,
          discountPercent: draft.discountPercent,
          supervisorApprovalNumber: draft.supervisorApprovalNumber,
        );

        _cashAmountText = draft.cashAmountText;
        _otherAmountText = draft.otherAmountText;
        _otherPaymentMethod = draft.otherMethod;
      }
    } catch (_) {
      if (mounted) {
        _showMessage('تعذر استعادة المسودة المحفوظة.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingDraft = false);
      }
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  GoldSaleDraft _currentDraft() {
    return GoldSaleDraft(
      items: _cart.items,
      discountPercent: _cart.discountPercent,
      supervisorApprovalNumber: _cart.supervisorApprovalNumber,
      cashAmountText: _cashAmountText,
      otherAmountText: _otherAmountText,
      otherMethod: _otherPaymentMethod,
    );
  }

  void _saveDraft() {
    final draft = _currentDraft();

    _saveQueue = _saveQueue
        .then<void>((_) => _draftRepository.save(draft))
        .catchError((Object _) {
          if (mounted) {
            _showMessage('تعذر حفظ المسودة.');
          }
        });
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

    final int salePricePerGramPiasters;

    try {
      salePricePerGramPiasters = await widget.priceRepository
          .getSalePricePerGramPiasters(product.karat);
    } on StateError {
      _showMessage('لا يوجد سعر بيع مسجل لهذا العيار.');
      return;
    }

    if (!mounted) return;

    final labor = await showLaborPricingDialog(context);
    if (!mounted || labor == null) return;

    final input = GoldSaleInput(
      grossWeightMg: product.grossWeightMg,
      stonesWeightMg: product.stonesWeightMg,
      karat: product.karat,
      goldPricePerGramPiasters: salePricePerGramPiasters,
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
      _saveDraft();
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
    _saveDraft();
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
      _saveDraft();
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
      _saveDraft();
    } on ArgumentError {
      _showMessage('الخصم غير صالح. تأكد من النسبة ورقم موافقة المسؤول.');
    }
  }

  void _handlePaymentDraftChanged({
    required String cashAmountText,
    required String otherAmountText,
    required GoldSalePaymentMethod otherMethod,
  }) {
    _cashAmountText = cashAmountText;
    _otherAmountText = otherAmountText;
    _otherPaymentMethod = otherMethod;
    _saveDraft();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة بيع الذهب'),
        centerTitle: true,
        actions: [ThemeIcon(onThemeToggle: widget.onThemeToggle)],
      ),
      body: _isLoadingDraft
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                            initialCashAmountText: _cashAmountText,
                            initialOtherAmountText: _otherAmountText,
                            initialOtherMethod: _otherPaymentMethod,
                            onDraftChanged: _handlePaymentDraftChanged,
                          ),
                        ],
                      ),
              ),
            ),
    );
  }
}
