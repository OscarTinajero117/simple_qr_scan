import 'dart:developer' show log;
import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import 'result.dart';
import 'scanner.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = false;

  bool haveError = false;

  String errorMessage = '';

  String result = '';

  void _shared() {
    if (result.isEmpty) return;
    setState(() {
      isLoading = true;
    });

    Share.share(result);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _scan(BuildContext ctx, {bool isQR = true}) async {
    setState(() {
      isLoading = true;
    });
    if (await getPermission(Permission.camera) && ctx.mounted) {
      try {
        late final String? cameraResult;

        if (isQR) {
          cameraResult = await Scanner.scanQR(context: ctx);
        } else {
          cameraResult = await Scanner.scanBarcode(context: ctx);
        }

        if (cameraResult != null) {
          result = cameraResult;
        }
      } catch (e) {
        log('Error: $e');
        haveError = true;
        errorMessage = e.toString();
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simple QR Scanner',
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLoading = true;
                haveError = false;
                result = '';
                errorMessage = '';
                isLoading = false;
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          // Result
          if (result.isNotEmpty) Result(result: result),
          // Error
          if (result.isEmpty && haveError) Result.error(errorMessage),
          // Loading
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (result.isEmpty)
            FloatingActionButton(
              heroTag: 'qr',
              onPressed: isLoading ? null : () async => await _scan(context),
              tooltip: 'Escanear QR',
              child: const Icon(Icons.qr_code),
            ),
          const SizedBox(height: 10.0),
          if (result.isEmpty)
            FloatingActionButton(
              heroTag: 'barcode',
              onPressed: () => _scan(context, isQR: false),
              tooltip: 'Escanear Código de Barras',
              child: Transform.rotate(
                angle: 90 * pi / 180,
                child: const Icon(Icons.document_scanner_outlined),
              ),
            ),
          const SizedBox(height: 10.0),
          if (result.isNotEmpty)
            FloatingActionButton(
              heroTag: 'share',
              onPressed: _shared,
              tooltip: 'Compartir',
              child: const Icon(Icons.share),
            ),
        ],
      ),
    );
  }
}

///Función para verificar el permiso deseado, si no lo tiene, lo solicita y
///regresa ese resultado
///```
/// final PermissionStatus status = await permission.status;
/// if (status.isDenied) {
///   final result = await permission.request().isGranted;
///   return result;
/// }
/// return true;
///```
Future<bool> getPermission(Permission permission) async {
  final PermissionStatus status = await permission.status;
  if (status.isDenied) {
    final result = await permission.request().isGranted;
    return result;
  }
  return true;
}
