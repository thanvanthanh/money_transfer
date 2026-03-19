class NumberFormatter {
  static String formatAmount(String input) {
    String numericOnly = input.replaceAll(RegExp(r'[^\d]'), '');
    if (numericOnly.isEmpty) return '';

    int amount = int.parse(numericOnly);
    return amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (Match m) => '.',
    );
  }

  static String readNumberToVietnamese(int number) {
    if (number == 0) return 'không';

    const List<String> units = [
      '',
      'một',
      'hai',
      'ba',
      'bốn',
      'năm',
      'sáu',
      'bảy',
      'tám',
      'chín',
    ];
    const List<String> groups = [
      '',
      'nghìn',
      'triệu',
      'tỷ',
      'nghìn tỷ',
      'triệu tỷ',
    ];

    String readGroup(int n) {
      String str = '';
      int h = n ~/ 100;
      int t = (n % 100) ~/ 10;
      int u = n % 10;

      if (h > 0) str += '${units[h]} trăm ';

      if (t > 1) {
        str += '${units[t]} mươi ';
        if (u == 1) {
          str += 'mốt';
        } else if (u == 5) {
          str += 'lăm';
        } else if (u > 0) {
          str += units[u];
        }
      } else if (t == 1) {
        str += 'mười ';
        if (u == 5) {
          str += 'lăm';
        } else if (u > 0) {
          str += units[u];
        }
      } else if (u > 0) {
        if (h > 0) str += 'lẻ ';
        str += units[u];
      }

      return str.trim();
    }

    String result = '';
    int groupIndex = 0;
    int temp = number;

    while (temp > 0) {
      int group = temp % 1000;
      if (group > 0) {
        result = '${readGroup(group)} ${groups[groupIndex]} $result';
      }
      temp = temp ~/ 1000;
      groupIndex++;
    }

    return result.trim();
  }

  static String formatVietnamCurrency(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (Match m) => '.')} VNĐ';
  }
}
