import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/bank_config.dart';

class AccountInfoCard extends StatefulWidget {
  const AccountInfoCard({super.key});

  @override
  State<AccountInfoCard> createState() => _AccountInfoCardState();
}

class _AccountInfoCardState extends State<AccountInfoCard> {
  String? copiedField;

  void _copyToClipboard(String text, String field) {
    Clipboard.setData(ClipboardData(text: text));
    setState(() => copiedField = field);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã sao chép: $text'),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      setState(() => copiedField = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoRow('Ngân hàng', BankConfig.bankName),
          Divider(color: Colors.white.withOpacity(0.1), height: 20),
          _buildInfoRow('Chủ tài khoản', BankConfig.accountName),
          Divider(color: Colors.white.withOpacity(0.1), height: 20),
          _buildCopyableRow(
            'Số tài khoản',
            BankConfig.accountNumber,
            'accountNumber',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCopyableRow(String label, String value, String field) {
    bool isCopied = copiedField == field;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
        ),
        GestureDetector(
          onTap: () => _copyToClipboard(value, field),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isCopied
                  ? Colors.green.withOpacity(0.3)
                  : Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  isCopied ? Icons.check : Icons.copy,
                  size: 14,
                  color: isCopied
                      ? Colors.green[300]
                      : Colors.blue.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
