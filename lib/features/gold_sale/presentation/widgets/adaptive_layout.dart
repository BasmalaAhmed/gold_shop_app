import 'package:flutter/material.dart';

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.searchPanel,
    required this.cartPanel,
    this.paymentPanel,
  });

  final Widget searchPanel;
  final Widget cartPanel;
  final Widget? paymentPanel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 340, child: searchPanel),
                const SizedBox(width: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        cartPanel,
                        if (paymentPanel != null) ...[
                          const SizedBox(height: 16),
                          paymentPanel!,
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              searchPanel,
              const SizedBox(height: 16),
              cartPanel,
              if (paymentPanel != null) ...[
                const SizedBox(height: 16),
                paymentPanel!,
              ],
            ],
          ),
        );
      },
    );
  }
}
