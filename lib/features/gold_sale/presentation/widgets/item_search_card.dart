import 'package:flutter/material.dart';

class ItemSearchCard extends StatelessWidget {
  const ItemSearchCard({
    super.key,
    required this.codeController,
    required this.onSearch,
    required this.onChooseDemoBarcode,
  });

  final TextEditingController codeController;
  final VoidCallback onSearch;
  final VoidCallback onChooseDemoBarcode;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('إضافة قطعة', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            TextField(
              controller: codeController,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                labelText: 'كود القطعة',

                hintText: 'مثال: DEMO-1001',
              ),
              onSubmitted: (_) => onSearch(),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onSearch,
              icon: const Icon(Icons.search),
              label: const Text('بحث وإضافة'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onChooseDemoBarcode,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('اختيار باركود'),
            ),
          ],
        ),
      ),
    );
  }
}
