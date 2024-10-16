import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    // 디바이스의 크기에 따라 scanArea를 지정
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return Scaffold(
      appBar: AppBar(title: Text('QR 스캐너')),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 13,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double screenHeight = constraints.maxHeight;
                    //double screenWidth = constraints.maxWidth;
                    double cutOutHeight = scanArea * 1.8;

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                          overlay: QrScannerOverlayShape(
                            borderColor: Theme.of(context).primaryColor, // 모서리 테두리 색
                            borderRadius: 10, // 둥글게 둥글게
                            borderLength: 30, // 테두리 길이
                            borderWidth: 15, // 테두리 너비
                            cutOutSize: cutOutHeight,
                          ),
                        ),
                        // 중앙에 빨간색 + 모양 가이드라인
                        // 중앙에 빨간색 + 모양 가이드라인
                        Positioned(
                          top: (screenHeight - cutOutHeight) / 2 + cutOutHeight / 2.2 - 1,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 세로선
                              Container(
                                width: 4,
                                height: 40,
                                color: Colors.redAccent,
                              ),
                              // 가로선
                              Container(
                                width: 40,
                                height: 4,
                                color: Colors.redAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).primaryColor, // 원하는 배경색으로 설정
                  child: Center(
                    child: (result != null)
                        ? Text('QR 코드 데이터: ${result!.code}',
                        style: TextStyle(color: Colors.white))
                        : Text('QR 코드를 스캔하세요',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!isScanned) {
        // 중복 스캔 방지
        setState(() {
          result = scanData;
          isScanned = true; // 스캔 완료 플래그 설정
        });
        controller.pauseCamera(); // 스캔 후 카메라 일시 중지

        // Firestore에 출석 정보를 추가/업데이트하는 함수 호출
        await addOrUpdateAttendance(context, widget.studentId, result!.code!);
        dispose();
      }
    });
  }
}
