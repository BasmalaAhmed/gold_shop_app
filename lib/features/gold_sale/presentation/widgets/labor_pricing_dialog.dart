import 'package:flutter/material.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';
import 'package:gold_shop_app/features/gold_sale/presentation/utils/piaster_parser.dart';


class LaborPricingSelection {
  const LaborPricingSelection({
    required this.type,
    required this.value,
  });

  final LaborPricingType type;

  final int value;
}

Future<LaborPricingSelection?> showLaborPricingDialog(
  BuildContext context,
) {
  return showDialog<LaborPricingSelection>(
    context: context,
    builder: (_) => const LaborPricingDialog(),
  );
}

class LaborPricingDialog extends StatefulWidget {
  const LaborPricingDialog({super.key});

  @override
  State<LaborPricingDialog> createState() => _LaborPricingDialogState();
}

class _LaborPricingDialogState extends State<LaborPricingDialog> {
  final _valueController = TextEditingController();
  LaborPricingType _type = LaborPricingType.perGram;
  String? _error;

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  String get _label {
    switch (_type) {
      case LaborPricingType.perGram:
        return 'مصنعية لكل جرام';
      case LaborPricingType.percentageOfGoldValue:
        return 'نسبة من قيمة الذهب';
      case LaborPricingType.fixed:
        return 'مصنعية ثابتة للقطعة';
    }
  }

  String get _suffix {
    switch (_type) {
      case LaborPricingType.perGram:
        return 'ج.م / جرام';
      case LaborPricingType.percentageOfGoldValue:
        return '%';
      case LaborPricingType.fixed:
        return 'ج.م';
    }
  }

  void _submit() {
    final rawValue = _valueController.text.trim();

    final value = _type == LaborPricingType.percentageOfGoldValue
        ? int.tryParse(rawValue)
        : parsePiasters(rawValue);

    if (value == null || value < 0) {
      setState(() {
        _error = _type == LaborPricingType.percentageOfGoldValue
            ? 'أدخل نسبة صحيحة كعدد صحيح.'
            : 'أدخل مبلغًا صحيحًا بحد أقصى خانتين عشريتين.';
      });
      return;
    }

    Navigator.of(context).pop(
      LaborPricingSelection(type: _type, value: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0XFFE8F7EE),
      title: const Text('تحديد المصنعية'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<LaborPricingType>(
            initialValue: _type,
            dropdownColor: Color(0XFFE8F7EE),
            decoration: const InputDecoration(labelText: 'طريقة الحساب'),
            items: const [
              DropdownMenuItem(
                value: LaborPricingType.perGram,
                child: Text('مبلغ لكل جرام'),
              ),
              DropdownMenuItem(
                value: LaborPricingType.percentageOfGoldValue,
                child: Text('نسبة مئوية من قيمة الذهب'),
              ),
              DropdownMenuItem(
                value: LaborPricingType.fixed,
                child: Text('مبلغ ثابت للقطعة'),
              ),
            ],
            onChanged: (type) {
              if (type == null) return;
              setState(() {
                _type = type;
                _valueController.clear();
                _error = null;
              });
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _valueController,
            keyboardType: TextInputType.numberWithOptions(
              decimal: _type != LaborPricingType.percentageOfGoldValue,
            ),
            decoration: InputDecoration(
              labelText: _label,
              suffixText: _suffix,
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء' , style: TextStyle(color: Color(0XFF49111C)),),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(backgroundColor: Color(0XFF49111C)),
          child: const Text('إضافة القطعة'),
        ),
      ],
    );
  }
}