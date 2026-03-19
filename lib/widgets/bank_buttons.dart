import 'package:flutter/material.dart';
import '../config/bank_config.dart';
import '../utils/deep_link_handler.dart';

class BankButtons extends StatelessWidget {
  final int amount;
  final String note;

  const BankButtons({required this.amount, required this.note});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'hoặc mở app ngân hàng',
          style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
        ),
        SizedBox(height: 16),
        Column(
          children: BankConfig.deepLinks.entries.map((entry) {
            String bankId = entry.key;
            Map<String, String> config = entry.value;
            Color buttonColor = _getColorFromHex(config['color'] ?? '#667eea');

            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => DeepLinkHandler.openBankApp(
                  bankId: bankId,
                  amount: amount,
                  note: note.isEmpty ? 'Chuyen tien' : note,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        buttonColor.withOpacity(0.8),
                        buttonColor.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        config['icon'] ?? '🏦',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Mở App ${config['name']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getColorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF' + hex, radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    }
    return Colors.purple;
  }
}
