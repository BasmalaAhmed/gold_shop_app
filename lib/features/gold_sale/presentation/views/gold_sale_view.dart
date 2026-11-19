import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_demo_catalog.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_draft.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_draft_repo.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_record.dart';
import 'package:gold_shop_app/features/gold_sale/data/gold_sale_record_repo.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_item_status.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment_method.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_price_repo.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_product.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_trade_in.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/adaptive_layout.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/cart_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/demo_barcode_sheet.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/discount_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/item_search_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/labor_pricing_dialog.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/payment_card.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/theme_icon.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/trade_in_card.dart';

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
  final _recordRepository = GoldSaleRecordRepo();
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
          tradeIn: draft.tradeIn,
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
      tradeIn: _cart.tradeIn,
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

  Future<void> _completeSale(List<GoldSalePayment> payments) async {
    try {
      _paymentValidator.validate(
        amountDuePiasters: _cart.amountDuePiasters,
        payments: payments,
      );
    } on ArgumentError {
      _showMessage('مجموع المدفوع يجب أن يساوي المستحق بالظبط.');
      return;
    }

    // نتأكد إن القطع لسه متاحة وقت الإتمام (المسودة ممكن تكون قديمة).
    for (final item in _cart.items) {
      final current = _catalog.findByCode(item.code);
      if (current == null || current.status != GoldItemStatus.available) {
        _showMessage('القطعة ${item.code} لم تعد متاحة للبيع.');
        return;
      }
    }

    final record = GoldSaleRecord.fromCart(
      cart: _cart,
      payments: payments,
      recordedAt: DateTime.now(),
    );

    try {
      await _saveQueue; // نستنى أي حفظ مسودة شغال قبل المسح
      await _recordRepository.add(record);
      await _draftRepository.clear();
    } catch (_) {
      if (mounted) _showMessage('تعذر تسجيل البيع.');
      return;
    }
    if (!mounted) return;

    setState(() {
      _cart.clear();
      _cashAmountText = '';
      _otherAmountText = '';
    });
    _showMessage('تم تسجيل البيع.');
  }

  Future<void> _applyTradeIn(
    int weightMg,
    int karat,
    int deductionBasisPoints,
  ) async {
    try {
      final price = await widget.priceRepository.getBuyPricePerGramPiasters(
        karat,
      );
      if (!mounted) return;
      final tradeIn = TradeInInput(
        weightMg: weightMg,
        karat: karat,
        buyPricePerGramPiasters: price,
        deductionBasisPoints: deductionBasisPoints,
      );
      setState(() => _cart.setTradeIn(tradeIn));
      _saveDraft();
      _showMessage('تم تطبيق البدل.');
    } on StateError {
      if (mounted) _showMessage('لا يوجد سعر شراء لهذا العيار.');
    } on ArgumentError {
      if (mounted) {
        _showMessage(
          'بيانات البدل غير صالحة أو قيمته أكبر من أو تساوي الفاتورة.',
        );
      }
    }
  }

  void _removeTradeIn() {
    setState(() => _cart.setTradeIn(null));
    _saveDraft();
    _showMessage('تم إزالة البدل.');
  }

  Future<void> _refreshPrices() async {
    if (_cart.items.isEmpty) return;
    try {
      final refreshed = <GoldSaleCartItem>[];
      for (final item in _cart.items) {
        final old = item.input;
        final price = await widget.priceRepository.getSalePricePerGramPiasters(
          old.karat,
        );
        refreshed.add(
          GoldSaleCartItem(
            code: item.code,
            status: item.status,
            input: GoldSaleInput(
              grossWeightMg: old.grossWeightMg,
              stonesWeightMg: old.stonesWeightMg,
              karat: old.karat,
              goldPricePerGramPiasters: price,
              laborValue: old.laborValue,
              laborPricingType: old.laborPricingType,
            ),
          ),
        );
      }

      TradeInInput? refreshedTradeIn;
      final trade = _cart.tradeIn;
      if (trade != null) {
        refreshedTradeIn = TradeInInput(
          weightMg: trade.weightMg,
          karat: trade.karat,
          buyPricePerGramPiasters: await widget.priceRepository
              .getBuyPricePerGramPiasters(trade.karat),
          deductionBasisPoints: trade.deductionBasisPoints,
        );
      }

      if (!mounted) return;
      setState(() {
        _cart.restore(
          items: refreshed,
          discountPercent: _cart.discountPercent,
          supervisorApprovalNumber: _cart.supervisorApprovalNumber,
          tradeIn: refreshedTradeIn,
        );
      });
      _saveDraft();
      _showMessage('تم تحديث الأسعار.');
    } on StateError {
      if (mounted) _showMessage('تعذر تحديث الأسعار.');
    } on ArgumentError {
      if (mounted) _showMessage('الأسعار الجديدة لا تناسب البدل الحالي.');
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
        actions: [
          IconButton(
            tooltip: 'تحديث الأسعار',
            onPressed: _refreshPrices,
            icon: const Icon(Icons.refresh),
          ),
          ThemeIcon(onThemeToggle: widget.onThemeToggle),
        ],
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
                          TradeInCard(
                            tradeIn: _cart.tradeIn,
                            valuePiasters: _cart.tradeInValuePiasters,
                            onApply: _applyTradeIn,
                            onRemove: _removeTradeIn,
                          ),
                          const SizedBox(height: 16),
                          PaymentCard(
                            amountDuePiasters: _cart.amountDuePiasters,
                            onSubmit: _completeSale,
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
