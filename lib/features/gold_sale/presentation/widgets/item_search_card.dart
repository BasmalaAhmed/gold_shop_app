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
      color: Color(0XFF8F8073),
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
                labelStyle: TextStyle(
                  color: Color(0XFF49111C)
                ),
                hintText: 'مثال: DEMO-1001',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C))
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C))
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF49111C))
                ),
              ),
              onSubmitted: (_) => onSearch(),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onSearch,
              icon: const Icon(Icons.search),
              label: const Text('بحث وإضافة'),
              style: FilledButton.styleFrom(
                backgroundColor: Color(0XFF49111C)
              ),
            ),
            OutlinedButton.icon(
              onPressed: onChooseDemoBarcode,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('اختيار باركود'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0XFF49111C),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
