import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_trade_in.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/utils/mg_parser.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/utils/piaster_parser.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/widgets/money_row.dart';

class TradeInCard extends StatefulWidget {
  const TradeInCard({
    super.key,
    required this.tradeIn,
    required this.valuePiasters,
    required this.onApply,
    required this.onRemove,
  });

  final TradeInInput? tradeIn;
  final int valuePiasters;
  final void Function(int weightMg, int karat, int deductionBasisPoints) onApply;
  final VoidCallback onRemove;

  @override
  State<TradeInCard> createState() => _TradeInCardState();
}

class _TradeInCardState extends State<TradeInCard> {

  final _weightController = TextEditingController();
  final _deductionController = TextEditingController();
  int _karat = 21;
  String? _error;

  static String _fmt(int value, int scale) {
    final digits = scale == 1000 ? 3 : 2;
    return '${value ~/ scale}.${(value % scale).toString().padLeft(digits, '0')}';
  }

  @override
  void initState() {
    super.initState();
    final t = widget.tradeIn;
    if (t != null) {
      _weightController.text = _fmt(t.weightMg, 1000);
      _deductionController.text = _fmt(t.deductionBasisPoints, 100);
      if (supportedKarats.contains(t.karat)) _karat = t.karat;
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _deductionController.dispose();
    super.dispose();
  }

  void _apply() {
    final weight = parseMgs(_weightController.text);
    final deductionText = _deductionController.text.trim();
    final deduction = deductionText.isEmpty ? 0 : parsePiasters(deductionText);

    if (weight == null || weight <= 0) {
      setState(
        () => _error = 'أدخل وزنًا صحيحًا بالجرام (حد أقصى 3 خانات عشرية).',
      );
      return;
    }
    if (deduction == null || deduction >= 10000) {
      setState(() => _error = 'نسبة الخصم من 0 إلى أقل من 100%.');
      return;
    }

    setState(() => _error = null);
    widget.onApply(weight, _karat, deduction);
  }

  void _remove() {
    _weightController.clear();
    _deductionController.clear();
    setState(() => _error = null);
    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    const numeric = TextInputType.numberWithOptions(decimal: true);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'البدل (دهب قديم)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('tradeInWeightField'),
              controller: _weightController,
              keyboardType: numeric,
              decoration: const InputDecoration(
                labelText: 'الوزن',
                suffixText: 'جم',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              key: const ValueKey('tradeInKaratField'),
              initialValue: _karat,
              decoration: const InputDecoration(labelText: 'العيار'),
              items: [
                for (final k in supportedKarats)
                  DropdownMenuItem(value: k, child: Text('$k قيراط')),
              ],
              onChanged: (value) => setState(() => _karat = value ?? _karat),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('tradeInDeductionField'),
              controller: _deductionController,
              keyboardType: numeric,
              decoration: const InputDecoration(
                labelText: 'خصم من الوزن (اختياري)',
                suffixText: '%',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (widget.valuePiasters > 0) ...[
              const SizedBox(height: 8),
              MoneyRow(
                label: 'قيمة البدل',
                amount: widget.valuePiasters,
                bold: true,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _apply,
                    child: const Text('تطبيق البدل'),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(onPressed: _remove, child: const Text('إزالة')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
