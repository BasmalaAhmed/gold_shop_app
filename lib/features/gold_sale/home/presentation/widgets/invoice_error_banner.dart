import 'package:flutter/material.dart';
import 'package:gold_shop_app/core/theme/app_theme.dart';

class InvoiceErrorBanner extends StatelessWidget {
  const InvoiceErrorBanner({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.redLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.redBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.redText,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.redText,
            size: 24,
          ),
        ],
      ),
    );
  }
}