import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// QR 코드 스캐너 화면 구현
class QrScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isScanned = false; // 스캔 완료 여부 플래그

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR 스캐너')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('QR 코드 데이터: ${result!.code}')
                  : Text('QR 코드를 스캔하세요'),
            ),
          )
        ],
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanned) {  // 중복 스캔 방지
        setState(() {
          result = scanData;
          isScanned = true;  // 스캔 완료 플래그 설정
        });
        controller.pauseCamera(); // 스캔 후 카메라 일시 중지
        // 추가적으로 데이터를 처리하는 로직 (예: 서버로 전송, UI 업데이트 등)을 여기에 추가
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
