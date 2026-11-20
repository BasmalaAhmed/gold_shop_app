import 'package:flutter/material.dart';
import 'package:gold_shop_app/core/theme/app_theme.dart';

class ScanBarcodeWidget extends StatelessWidget {
  const ScanBarcodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.pillTealBg,
          ),
          child: const Icon(
            Icons.filter_center_focus_rounded,
            size: 46,
            color: AppTheme.primaryTeal,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'امسح أول قطعة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'حق قطعتين في الفاتورة',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
