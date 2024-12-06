import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Result extends StatelessWidget {
  const Result({super.key, required this.result});

  final String result;

  @override
  Widget build(BuildContext context) {
    late final bool isUrl;
    try {
      final uri = Uri.parse(result);
      isUrl = uri.isAbsolute;
    } catch (e) {
      isUrl = false;
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30.0),
          Text(
            result,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          if (isUrl)
            ElevatedButton(
              onPressed: () => _pressUrl(result),
              child: const Text('Abrir enlace'),
            ),
        ],
      ),
    );
  }

  static Widget error(String message) => Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );

  Future<void> _pressUrl(String url) async {
    try {
      final launchUri = Uri.parse(url);

      await launchUrl(launchUri);
    } catch (e) {
      log('Error: $e');
    }
  }
}
