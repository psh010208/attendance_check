import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../homeScreen.dart';
import 'ViewModel/QrViewModel.dart'; // Firestore를 사용하기 위한 import

class QrScanner extends StatefulWidget {
  final String studentId; // studentId를 전달받음

  QrScanner({required this.studentId});

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
    print(widget.studentId);

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
    controller.scannedDataStream.listen((scanData) async {
      if (!isScanned) { // 중복 스캔 방지
        setState(() {
          result = scanData;
          isScanned = true; // 스캔 완료 플래그 설정
        });
        controller.pauseCamera(); // 스캔 후 카메라 일시 중지

        // Firestore에 출석 정보를 추가/업데이트하는 함수 호출
        await addOrUpdateAttendance(context, widget.studentId, result!.code!);


        // Firestore 작업 후 카메라 재시작 (필요시)
        // controller.resumeCamera(); // 필요하면 다시 카메라 재시작
      }
    });
  }
}