import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/bank_model.dart';

class BankService {
  static const String _apiUrl = 'https://api.vietqr.io/v2/ios-app-deeplinks';
  static const int _timeoutSeconds = 15;

  /// Lấy tất cả ngân hàng từ API
  static Future<BankResponse> fetchBanks() async {
    try {
      final response = await http
          .get(
            Uri.parse(_apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            Duration(seconds: _timeoutSeconds),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BankResponse.fromJson(data);
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Lỗi tải ngân hàng: $e');
    }
  }

  /// Lấy ngân hàng phổ biến nhất (theo số lần cài đặt)
  static Future<List<BankApp>> fetchPopularBanks({int limit = 6}) async {
    try {
      final response = await fetchBanks();
      final sortedBanks = response.apps
          .where((bank) => bank.monthlyInstall > 0)
          .toList();
      sortedBanks.sort((a, b) => b.monthlyInstall.compareTo(a.monthlyInstall));
      return sortedBanks.take(limit).toList();
    } catch (e) {
      throw Exception('Lỗi tải ngân hàng phổ biến: $e');
    }
  }

  /// Tìm kiếm ngân hàng theo tên
  static Future<List<BankApp>> searchBanks(String query) async {
    try {
      final response = await fetchBanks();
      return response.apps
          .where(
            (bank) =>
                bank.bankName.toLowerCase().contains(query.toLowerCase()) ||
                bank.appName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    } catch (e) {
      throw Exception('Lỗi tìm kiếm: $e');
    }
  }

  /// Lấy ngân hàng hỗ trợ autofill
  static Future<List<BankApp>> fetchAutofillBanks() async {
    try {
      final response = await fetchBanks();
      return response.apps.where((bank) => bank.autofill == 1).toList();
    } catch (e) {
      throw Exception('Lỗi tải autofill: $e');
    }
  }

  /// Tìm ngân hàng theo appId
  static Future<BankApp?> findBankById(String appId) async {
    try {
      final response = await fetchBanks();
      return response.apps.firstWhere(
        (bank) => bank.appId == appId,
        orElse: () => throw Exception('Bank not found'),
      );
    } catch (e) {
      return null;
    }
  }
}
