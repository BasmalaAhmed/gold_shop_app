import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment_method.dart';

import '../utils/piaster_parser.dart';
import 'money_row.dart';

typedef PaymentDraftChanged =
    void Function({
      required String cashAmountText,
      required String otherAmountText,
      required GoldSalePaymentMethod otherMethod,
    });

class PaymentCard extends StatefulWidget {
  const PaymentCard({
    super.key,
    required this.amountDuePiasters,
    required this.onSubmit,
    this.initialCashAmountText = '',
    this.initialOtherAmountText = '',
    this.initialOtherMethod = GoldSalePaymentMethod.card,
    required this.onDraftChanged,
  });

  final int amountDuePiasters;
  final ValueChanged<List<GoldSalePayment>> onSubmit;
  final String initialCashAmountText;
  final String initialOtherAmountText;
  final GoldSalePaymentMethod initialOtherMethod;
  final PaymentDraftChanged onDraftChanged;

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  final _cashController = TextEditingController();
  final _otherController = TextEditingController();

  GoldSalePaymentMethod _otherMethod = GoldSalePaymentMethod.card;
  String? _inputError;

  @override
  void initState() {
    super.initState();
    _cashController.text = widget.initialCashAmountText;
    _otherController.text = widget.initialOtherAmountText;
    _otherMethod = widget.initialOtherMethod;
  }

  @override
  void dispose() {
    _cashController.dispose();
    _otherController.dispose();
    super.dispose();
  }

  void _submit() {
    final cashText = _cashController.text.trim();
    final otherText = _otherController.text.trim();

    final cashPiasters = cashText.isEmpty ? 0 : parsePiasters(cashText);
    final otherPiasters = otherText.isEmpty ? 0 : parsePiasters(otherText);

    if (cashPiasters == null || otherPiasters == null) {
      setState(() {
        _inputError = 'اكتب مبلغًا صحيحًا بحد أقصى خانتين عشريتين.';
      });
      return;
    }

    setState(() {
      _inputError = null;
    });

    final payments = <GoldSalePayment>[];

    if (cashPiasters > 0) {
      payments.add(
        GoldSalePayment(
          method: GoldSalePaymentMethod.cash,
          amountPiasters: cashPiasters,
        ),
      );
    }

    if (otherPiasters > 0) {
      payments.add(
        GoldSalePayment(method: _otherMethod, amountPiasters: otherPiasters),
      );
    }

    widget.onSubmit(payments);
  }

  void _notifyDraftChanged() {
    widget.onDraftChanged(
      cashAmountText: _cashController.text,
      otherAmountText: _otherController.text,
      otherMethod: _otherMethod,
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
            Text('الدفع', style: Theme.of(context).textTheme.titleLarge),
            MoneyRow(
              label: 'المستحق',
              amount: widget.amountDuePiasters,
              bold: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cashController,
              onChanged: (_) => _notifyDraftChanged(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'المبلغ كاش',
                suffixText: 'ج.م',
                hintText: 'مثال: 10000.00',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<GoldSalePaymentMethod>(
              initialValue: _otherMethod,
              decoration: const InputDecoration(labelText: 'طريقة دفع أخرى'),
              items: const [
                DropdownMenuItem(
                  value: GoldSalePaymentMethod.card,
                  child: Text('بطاقة'),
                ),
                DropdownMenuItem(
                  value: GoldSalePaymentMethod.bankTransfer,
                  child: Text('تحويل بنكي'),
                ),
                DropdownMenuItem(
                  value: GoldSalePaymentMethod.mobileWallet,
                  child: Text('محفظة إلكترونية'),
                ),
                DropdownMenuItem(
                  value: GoldSalePaymentMethod.other,
                  child: Text('طريقة أخرى'),
                ),
              ],
              onChanged: (method) {
                if (method != null) {
                  setState(() {
                    _otherMethod = method;
                  });
                  _notifyDraftChanged();
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _otherController,
              onChanged: (_) => _notifyDraftChanged(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'المبلغ بطريقة الدفع الأخرى',
                suffixText: 'ج.م',
                hintText: 'مثال: 8157.10',
              ),
            ),
            if (_inputError != null) ...[
              const SizedBox(height: 8),
              Text(
                _inputError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _submit,
              child: const Text('اتمام المبلغ'),
            ),
          ],
        ),
      ),
    );
  }
}
