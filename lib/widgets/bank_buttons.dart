import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/bank_model.dart';
import '../services/bank_service.dart';

class BankButtons extends StatefulWidget {
  final int amount;
  final String note;
  final List<CustomApp>? customApps;

  const BankButtons({
    super.key,
    required this.amount,
    required this.note,
    this.customApps,
  });

  @override
  State<BankButtons> createState() => _BankButtonsState();
}

class _BankButtonsState extends State<BankButtons> {
  late Future<List<BankApp>> _banksFuture;

  @override
  void initState() {
    super.initState();
    _banksFuture = BankService.fetchBanks().then((response) {
      // Sắp xếp theo số lần cài đặt (phổ biến nhất lên đầu)
      final sortedBanks = response.apps
          .where((bank) => bank.monthlyInstall > 0)
          .toList();
      sortedBanks.sort((a, b) => b.monthlyInstall.compareTo(a.monthlyInstall));
      return sortedBanks;
    });
  }

  Future<void> _openBankDeeplink(String deeplink, {String? fallbackUrl}) async {
    try {
      final uri = Uri.parse(deeplink);

      // Debug: In ra deeplink
      print('🔗 Deeplink: $deeplink');
      print('📝 Fallback: $fallbackUrl');

      // Thử mở
      final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);

      if (!launched) {
        print('⚠️ canLaunchUrl trả về false');

        // Fallback
        if (fallbackUrl != null && fallbackUrl.isNotEmpty) {
          print('↪️ Mở fallback: $fallbackUrl');
          await launchUrl(
            Uri.parse(fallbackUrl),
            mode: LaunchMode.platformDefault,
          );
        } else {
          _showSnackBar('❌ Không có URL dự phòng');
        }
      }
    } catch (e) {
      print('❌ Lỗi: $e');
      _showSnackBar('❌ Lỗi: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.withOpacity(0.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb = MediaQuery.of(context).size.width > 600;
    int crossAxisCount = isWeb ? 5 : 3;

    return FutureBuilder<List<BankApp>>(
      future: _banksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Lỗi tải danh sách ngân hàng',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final banks = snapshot.data ?? [];
        if (banks.isEmpty) {
          return SizedBox.shrink();
        }

        return Column(
          children: [
            // Header
            Text(
              '💳 Hoặc mở app ngân hàng',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),

            // Custom Apps Section (nếu có)
            if (widget.customApps != null && widget.customApps!.isNotEmpty)
              Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: widget.customApps!.length,
                    itemBuilder: (context, index) {
                      final customApp = widget.customApps![index];
                      return _buildCustomAppCard(customApp);
                    },
                  ),
                  SizedBox(height: 20),
                  Divider(color: Colors.white.withOpacity(0.1), height: 1),
                  SizedBox(height: 20),
                ],
              ),

            // Bank Grid (API)
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemCount: banks.length,
              itemBuilder: (context, index) {
                final bank = banks[index];
                return _buildBankCard(bank);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomAppCard(CustomApp app) {
    return GestureDetector(
      onTap: () =>
          _openBankDeeplink(app.deeplink, fallbackUrl: app.fallbackUrl),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Custom App Icon/Logo
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: app.logoUrl != null && app.logoUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: app.logoUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF667eea),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white.withOpacity(0.3),
                            size: 28,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(app.icon, style: TextStyle(fontSize: 28)),
                      ),
              ),

              SizedBox(height: 10),

              // App Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  app.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankCard(BankApp bank) {
    return GestureDetector(
      onTap: () => _openBankDeeplink(bank.deeplink),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bank Logo
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: CachedNetworkImage(
                  imageUrl: bank.appLogo,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF667eea),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white.withOpacity(0.3),
                      size: 28,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Bank Name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  bank.appName.replaceAll('‎', ''),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
