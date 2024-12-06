import 'package:flutter/material.dart';

import 'src/dashboard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Simple QR Scanner',
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}
