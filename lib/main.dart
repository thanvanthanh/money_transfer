import 'package:flutter/material.dart';
import 'screens/transfer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thân Văn Thanh - Chuyển Tiền',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: TransferScreen(),
    );
  }
}
