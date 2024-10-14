import 'package:flutter/cupertino.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class qrCodeScanner {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isScanned = false; // 중복 스캔 방지 플래그

  // QR 코드 스캔 시작 메서드
  void startScanning( onScanned) {
    // 스캔 완료시 데이터를 처리할 콜백 함수
    controller?.scannedDataStream.listen((scanData) {
      if (!isScanned) { // 중복 스캔 방지
        result = scanData;
        isScanned = true;  // 스캔 완료 플래그 설정
        controller?.pauseCamera(); // 스캔 후 카메라 일시 중지

        // 스캔된 데이터를 콜백으로 반환
        onScanned(result?.code ?? 'No data');
      }
    });
  }
//qwe
  // QR 코드 스캔을 중지하는 메서드
  void stopScanning() {
    controller?.stopCamera();
  }

  // QR 코드 스캔을 재개하는 메서드
  void resumeScanning() {
    isScanned = false;
    controller?.resumeCamera();
  }

  // QR 코드 컨트롤러 설정 메서드
  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
  }

  // QR 코드 스캔 해제 (메모리 누수 방지)
  void dispose() {
    controller?.dispose();
  }
}
