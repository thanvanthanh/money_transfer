import 'package:flutter/material.dart';

class QuickButtons extends StatelessWidget {
  final ValueChanged<int> onAmountSelected;

  const QuickButtons({required this.onAmountSelected});

  @override
  Widget build(BuildContext context) {
    final amounts = [50000, 100000, 200000, 500000, 1000000, 2000000];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      itemCount: amounts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onAmountSelected(amounts[index]),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onAmountSelected(amounts[index]),
                borderRadius: BorderRadius.circular(12),
                child: Center(
                  child: Text(
                    _formatAmount(amounts[index]),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (Match m) => '.',
    );
  }
}
