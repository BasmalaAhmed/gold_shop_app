import 'package:flutter/material.dart';
import 'package:gold_shop_app/core/theme/app_theme.dart';

class DeleteConfirmDialog extends StatelessWidget {
  const DeleteConfirmDialog({
    super.key,
    required this.onConfirm,
    this.itemCode = 'G-1042',
  });

  final VoidCallback onConfirm;
  final String itemCode;

  static Future<bool?> show(
    BuildContext context, {
    required VoidCallback onConfirm,
    String itemCode = 'G-1042',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmDialog(
        onConfirm: onConfirm,
        itemCode: itemCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppTheme.redLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppTheme.redText,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'حذف الفاتورة؟',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'ستُحذف المسودة نهائيًا وتعود القطعة $itemCode متاحة للبيع. لا يمكن التراجع عن هذا الإجراء.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.redText,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'حذف الفاتورة',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.borderSubtle),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
