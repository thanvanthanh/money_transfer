import 'package:url_launcher/url_launcher.dart';
import '../config/bank_config.dart';

class DeepLinkHandler {
  static Future<void> openBankApp({
    required String bankId,
    required int amount,
    required String note,
  }) async {
    String vietqrLink = Uri.encodeFull(
      'https://dl.vietqr.io/pay?app=$bankId&ba=${BankConfig.bankId}-${BankConfig.accountNumber}&am=$amount&tn=$note',
    );

    final Map<String, String> deepLinks = {
      'mbbank': vietqrLink,
      'vietcombank': vietqrLink,
      'techcombank': vietqrLink,
      'vietinbank': vietqrLink,
      'momo':
          'https://nhantien.momo.vn/${BankConfig.accountNumber}/$amount/${Uri.encodeComponent(note)}',
      'zalopay':
          'https://social.zalopay.vn/mt/${BankConfig.accountNumber}?amount=$amount&note=${Uri.encodeComponent(note)}',
    };

    final String url = deepLinks[bankId] ?? vietqrLink;

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        // Fallback: mở link chung
        await launchUrl(
          Uri.parse(vietqrLink),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      print('Lỗi mở link: $e');
    }
  }

  static String getQRUrl(int amount, String note) {
    String qrUrl =
        'https://img.vietqr.io/image/${BankConfig.bankId}-${BankConfig.accountNumber}-compact.png'
        '?accountName=${Uri.encodeComponent(BankConfig.accountName)}';

    if (amount > 0) {
      qrUrl += '&amount=$amount';
    }

    if (note.isNotEmpty) {
      qrUrl += '&addInfo=${Uri.encodeComponent(note)}';
    }

    return qrUrl;
  }
}
