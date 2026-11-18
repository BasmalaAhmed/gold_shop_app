import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment_method.dart';

import '../utils/piaster_parser.dart';
import 'money_row.dart';

class PaymentCard extends StatefulWidget {
  const PaymentCard({
    super.key,
    required this.amountDuePiasters,
    required this.onSubmit,
  });

  final int amountDuePiasters;
  final ValueChanged<List<GoldSalePayment>> onSubmit;

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  final _cashController = TextEditingController();
  final _otherController = TextEditingController();

  GoldSalePaymentMethod _otherMethod = GoldSalePaymentMethod.card;
  String? _inputError;

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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0XFFE8F7EE),
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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'المبلغ كاش',
                labelStyle: TextStyle(color: Color(0XFF49111C)),
                suffixText: 'ج.م',
                hintText: 'مثال: 10000.00',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<GoldSalePaymentMethod>(
              dropdownColor: Color(0XFFE8F7EE),
              initialValue: _otherMethod,
              decoration: const InputDecoration(
                labelText: 'طريقة دفع أخرى',
                labelStyle: TextStyle(color: Color(0XFF49111C)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C)),
                ),
              ),
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
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _otherController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'المبلغ بطريقة الدفع الأخرى',
                labelStyle: TextStyle(color: Color(0XFF49111C)),
                suffixText: 'ج.م',
                hintText: 'مثال: 8157.10',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C)),
                ),
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
              style: FilledButton.styleFrom(backgroundColor: Color(0XFF49111C)),
              child: const Text('التحقق من المبلغ'),
            ),
          ],
        ),
      ),
    );
  }
}
