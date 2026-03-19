class BankConfig {
  // ============================================================
  // THAY ĐỔI THÔNG TIN CỦA BẠN TẠI ĐÂY
  // ============================================================
  static const String bankId = 'VCB';
  static const String bankName = 'Vietcombank';
  static const String accountNumber = '9366360222';
  static const String accountName = 'THAN VAN THANH';

  // Mã ngân hàng VietQR
  static const Map<String, String> bankCodes = {
    'MB': 'MB Bank',
    'VCB': 'Vietcombank',
    'TCB': 'Techcombank',
    'ICB': 'VietinBank',
    'BIDV': 'BIDV',
    'ACB': 'ACB',
    'TPB': 'TPBank',
    'STB': 'Sacombank',
    'VPB': 'VPBank',
  };

  // Deep link cho từng app
  static const Map<String, Map<String, String>> deepLinks = {
    'mbbank': {'name': 'MB Bank', 'icon': '🏦', 'color': '#1e2a5e'},
    'vietcombank': {'name': 'Vietcombank', 'icon': '🏦', 'color': '#00703c'},
    'techcombank': {'name': 'Techcombank', 'icon': '🏦', 'color': '#d41c24'},
    'vietinbank': {'name': 'VietinBank', 'icon': '🏦', 'color': '#1a3c8e'},
    'momo': {'name': 'MoMo', 'icon': '📱', 'color': '#a50064'},
    'zalopay': {'name': 'ZaloPay', 'icon': '📱', 'color': '#0068ff'},
  };
}
