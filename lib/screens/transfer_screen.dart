import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:money_transfer/models/bank_model.dart';
import '../widgets/account_info_card.dart';
import '../widgets/amount_input.dart';
import '../widgets/bank_buttons.dart';
import '../utils/deep_link_handler.dart';
import 'widgets/widgets.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

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
            colors: [
              Color(0xFF0f0c29),
              Color.fromARGB(255, 37, 77, 79),
              Color(0xFF24243e),
            ],
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
                    HeaderWidget(),
                    SizedBox(height: 30),

                    // Account Info
                    AccountInfoCard(),
                    SizedBox(height: 25),

                    // Amount Input
                    AmountInput(onChanged: _updateAmount),
                    SizedBox(height: 20),

                    // Note Input
                    NoteInputWidget(
                      controller: noteController,
                      onChanged: (value) {
                        setState(() => note = value);
                      },
                    ),
                    SizedBox(height: 25),

                    // QR Code
                    QRCodeSection(qrUrl: _getQRUrl()),
                    SizedBox(height: 20),

                    // Bank Buttons
                    BankButtons(
                      amount: amount,
                      note: note,
                      customApps: [
                        CustomApp(
                          name: 'Momo',
                          icon: '💜',
                          deeplink: 'momo://app',
                          logoUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZcQPC-zWVyFOu9J2OGl0j2D220D49D0Z7BQ&s',
                          fallbackUrl: '"https://momo.vn"',
                        ),
                        CustomApp(
                          name: 'ZaloPay',
                          icon: '💜',
                          deeplink: 'zalopay://app',
                          logoUrl:
                              'https://simg.zalopay.com.vn/zlp-website/assets/icon_hd_export_svg_ee6dd1e844.png',
                          fallbackUrl: "https://zalopay.vn",
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Footer
                    Text(
                      'Cảm ơn bạn đã chuyển tiền! ❤️',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
}
