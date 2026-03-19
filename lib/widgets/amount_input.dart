import 'package:flutter/material.dart';
import '../utils/number_formatter.dart';

class AmountInput extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const AmountInput({super.key, required this.onChanged});

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final controller = TextEditingController();
  String vietnamesText = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _updateAmount(String value) {
    String numericOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    String formatted = NumberFormatter.formatAmount(value);

    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );

    if (numericOnly.isNotEmpty) {
      int amount = int.parse(numericOnly);
      vietnamesText = '${NumberFormatter.readNumberToVietnamese(amount)} đồng';
    } else {
      vietnamesText = '';
    }

    widget.onChanged(numericOnly);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '💵 Nhập số tiền chuyển',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nhập số tiền...',
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.25),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: _updateAmount,
                ),
              ),
              Text(
                'VNĐ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (vietnamesText.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8, left: 4),
            child: Text(
              vietnamesText,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  int getAmount() {
    String numericOnly = controller.text.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(numericOnly) ?? 0;
  }
}
