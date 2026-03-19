class BankButton {
  final String id;
  final String name;
  final String icon;
  final String color;

  BankButton({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory BankButton.fromConfig(String id, Map<String, String> config) {
    return BankButton(
      id: id,
      name: config['name'] ?? '',
      icon: config['icon'] ?? '',
      color: config['color'] ?? '#667eea',
    );
  }
}

class TransferData {
  final String amount;
  final String note;

  TransferData({required this.amount, required this.note});

  int get amountInt =>
      int.tryParse(amount.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
}
