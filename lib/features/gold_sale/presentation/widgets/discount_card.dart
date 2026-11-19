import 'package:flutter/material.dart';

class DiscountCard extends StatefulWidget {
  const DiscountCard({
    super.key,
    required this.initialDiscountPercent,
    required this.onApply,
  });

  final int initialDiscountPercent;
  final void Function(int discountPercent, String? approvalNumber) onApply;

  @override
  State<DiscountCard> createState() => _DiscountCardState();
}

class _DiscountCardState extends State<DiscountCard> {
  late final TextEditingController _discountController;
  final _approvalController = TextEditingController();

  String? _error;

  bool get _needsApproval => (int.tryParse(_discountController.text) ?? 0) > 10;

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController(
      text: widget.initialDiscountPercent.toString(),
    );
  }

  @override
  void dispose() {
    _discountController.dispose();
    _approvalController.dispose();
    super.dispose();
  }

  void _applyDiscount() {
    final discountPercent = int.tryParse(_discountController.text.trim());

    if (discountPercent == null ||
        discountPercent < 0 ||
        discountPercent > 100) {
      setState(() {
        _error = 'أدخل نسبة صحيحة من 0 إلى 100.';
      });
      return;
    }

    final approvalNumber = _approvalController.text.trim();

    if (discountPercent > 10 && approvalNumber.isEmpty) {
      setState(() {
        _error = 'رقم موافقة المسؤول مطلوب للخصم فوق 10%.';
      });
      return;
    }

    setState(() {
      _error = null;
    });

    widget.onApply(
      discountPercent,
      discountPercent > 10 ? approvalNumber : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('خصم الفاتورة', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              key: const ValueKey('discountPercentField'),
              controller: _discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'نسبة الخصم',
                suffixText: '%',
              ),
              onChanged: (_) {
                setState(() {
                  _error = null;
                });
              },
            ),
            if (_needsApproval) ...[
              const SizedBox(height: 12),
              TextField(
                key: const ValueKey('approvalNumberField'),
                controller: _approvalController,
                decoration: const InputDecoration(
                  labelText: 'رقم موافقة المسؤول',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _applyDiscount,
              child: const Text('تطبيق الخصم'),
            ),
          ],
        ),
      ),
    );
  }
}
