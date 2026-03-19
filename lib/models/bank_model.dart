class BankResponse {
  final List<BankApp> apps;

  BankResponse({required this.apps});

  factory BankResponse.fromJson(Map<String, dynamic> json) {
    return BankResponse(
      apps: (json['apps'] as List)
          .map((app) => BankApp.fromJson(app as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BankApp {
  final String appId;
  final String appLogo;
  final String appName;
  final String bankName;
  final int monthlyInstall;
  final String deeplink;
  final int autofill;

  BankApp({
    required this.appId,
    required this.appLogo,
    required this.appName,
    required this.bankName,
    required this.monthlyInstall,
    required this.deeplink,
    required this.autofill,
  });

  factory BankApp.fromJson(Map<String, dynamic> json) {
    return BankApp(
      appId: json['appId'] as String,
      appLogo: json['appLogo'] as String,
      appName: json['appName'] as String,
      bankName: json['bankName'] as String,
      monthlyInstall: json['monthlyInstall'] as int? ?? 0,
      deeplink: json['deeplink'] as String,
      autofill: json['autofill'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appId': appId,
      'appLogo': appLogo,
      'appName': appName,
      'bankName': bankName,
      'monthlyInstall': monthlyInstall,
      'deeplink': deeplink,
      'autofill': autofill,
    };
  }
}

class CustomApp {
  final String name;
  final String icon;
  final String deeplink;
  final String? logoUrl;
  final String? fallbackUrl;

  CustomApp({
    required this.name,
    required this.icon,
    required this.deeplink,
    this.logoUrl,
    this.fallbackUrl,
  });
}
