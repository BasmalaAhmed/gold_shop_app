import 'package:gold_shop_app/features/gold_sale/domain/gold_item_status.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_calc.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_cart.dart';
import 'package:gold_shop_app/features/gold_sale/domain/gold_sale_payment_method.dart';

class GoldSaleDraft {
  GoldSaleDraft({
    required this.items,
    required this.discountPercent,
    required this.supervisorApprovalNumber,
    required this.cashAmountText,
    required this.otherAmountText,
    required this.otherMethod,
  });

  final List<GoldSaleCartItem> items;
  final int discountPercent;
  final String? supervisorApprovalNumber;

  final String cashAmountText;
  final String otherAmountText;
  final GoldSalePaymentMethod otherMethod;

  Map<String, dynamic> toJson() => {
    'items': items.map((item) {
      final input = item.input;

      return {
        'code': item.code,
        'status': item.status.name,
        'input': {
          'grossWeightMg': input.grossWeightMg,
          'stonesWeightMg': input.stonesWeightMg,
          'karat': input.karat,
          'goldPricePerGramPiasters': input.goldPricePerGramPiasters,
          'laborValue': input.laborValue,
          'laborPricingType': input.laborPricingType.name,
        },
      };
    }).toList(),
    'discountPercent': discountPercent,
    'supervisorApprovalNumber': supervisorApprovalNumber,
    'cashAmountText': cashAmountText,
    'otherAmountText': otherAmountText,
    'otherMethod': otherMethod.name,
  };

  factory GoldSaleDraft.fromJson(Map<String, dynamic> json) {
    final itemJsonList = json['items'] as List<dynamic>;

    final items = itemJsonList.map((itemEntry) {
      final itemJson = itemEntry as Map<String, dynamic>;
      final inputJson = itemJson['input'] as Map<String, dynamic>;

      return GoldSaleCartItem(
        code: itemJson['code'] as String,
        status: GoldItemStatus.values.byName(itemJson['status'] as String),
        input: GoldSaleInput(
          grossWeightMg: inputJson['grossWeightMg'] as int,
          stonesWeightMg: inputJson['stonesWeightMg'] as int,
          karat: inputJson['karat'] as int,
          goldPricePerGramPiasters:
              inputJson['goldPricePerGramPiasters'] as int,
          laborValue: inputJson['laborValue'] as int,
          laborPricingType: LaborPricingType.values.byName(
            inputJson['laborPricingType'] as String,
          ),
        ),
      );
    }).toList();

    return GoldSaleDraft(
      items: items,
      discountPercent: json['discountPercent'] as int,
      supervisorApprovalNumber:
          json['supervisorApprovalNumber'] as String?,
      cashAmountText: json['cashAmountText'] as String,
      otherAmountText: json['otherAmountText'] as String,
      otherMethod: GoldSalePaymentMethod.values.byName(
        json['otherMethod'] as String,
      ),
    );
  }
}