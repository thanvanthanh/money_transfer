import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/account_info_card.dart';
import '../widgets/amount_input.dart';
import '../widgets/quick_buttons.dart';
import '../widgets/bank_buttons.dart';
import '../utils/deep_link_handler.dart';

class TransferScreen extends StatefulWidget {
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  int amount = 0;
  String note = '';
  final noteController = TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  void _setAmount(int newAmount) {
    setState(() => amount = newAmount);
  }

  void _updateAmount(String newAmount) {
    setState(() => amount = int.tryParse(newAmount) ?? 0);
  }

  String _getQRUrl() {
    return DeepLinkHandler.getQRUrl(amount, note);
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? 40 : 20,
              vertical: 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),
                    SizedBox(height: 30),

                    // Account Info
                    AccountInfoCard(),
                    SizedBox(height: 25),

                    // Amount Input
                    AmountInput(onChanged: _updateAmount),
                    SizedBox(height: 20),

                    // Quick Buttons
                    QuickButtons(onAmountSelected: _setAmount),
                    SizedBox(height: 25),

                    // Note Input
                    _buildNoteInput(),
                    SizedBox(height: 25),

                    // QR Code
                    _buildQRCodeSection(),
                    SizedBox(height: 20),

                    // Bank Buttons
                    BankButtons(amount: amount, note: note),
                    SizedBox(height: 30),

                    // Footer
                    Text(
                      'Cảm ơn bạn đã chuyển tiền! ❤️',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF667eea).withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 8,
              ),
            ],
          ),
          child: Center(child: Text('💰', style: TextStyle(fontSize: 40))),
        ),
        SizedBox(height: 15),
        Text(
          'Chuyển Tiền Cho Tôi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Nhanh chóng & Tiện lợi',
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📝 Nội dung chuyển khoản',
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
          child: TextField(
            controller: noteController,
            style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'VD: Thanh toán đơn hàng 001',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
            onChanged: (value) {
              setState(() => note = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQRCodeSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20),
            ],
          ),
          padding: EdgeInsets.all(15),
          child: CachedNetworkImage(
            imageUrl: _getQRUrl(),
            width: 200,
            height: 200,
            placeholder: (context, url) => Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: Icon(Icons.error),
            ),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Quét mã QR bằng app ngân hàng bất kỳ',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
        ),
      ],
    );
  }
}
