import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';  // Camera 패키지 추가

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
  late CameraController cameraController;  // CameraController 추가
  List<CameraDescription>? cameras; // Available cameras list
  bool isFlashOn = false; // 플래시 상태를 관리

  final TransformationController _transformationController =
  TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    initializeCamera();  // 카메라 초기화
  }

  // 카메라 초기화 함수
  Future<void> initializeCamera() async {
    cameras = await availableCameras();  // 사용 가능한 카메라 목록 가져오기
    cameraController = CameraController(
      cameras!.first, // 후면 카메라 사용
      ResolutionPreset.high,  // 고해상도 모드 설정
    );
    await cameraController.initialize(); // 카메라 초기화
    setState(() {});  // 카메라가 초기화되면 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    print(widget.studentId);

    // 디바이스의 크기에 따라 scanArea를 지정
    var scanArea = (MediaQuery.of(context).size.width < 400.w ||
        MediaQuery.of(context).size.height < 400.h)
        ? 150.0.w
        : 300.0.w;

    return Scaffold(
      appBar: AppBar(
        title: Text('QR 스캐너'),
        actions: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_off : Icons.flash_on),
            onPressed: () {
              controller?.toggleFlash();
              setState(() {
                isFlashOn = !isFlashOn;  // 플래시 상태 업데이트
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onDoubleTapDown: _handleDoubleTapDown,
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          panEnabled: false, // 패닝 비활성화
          minScale: 1.0,
          maxScale: 3.0, // 최대 3배 확대
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 13,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double screenHeight = constraints.maxHeight;
                        double cutOutHeight = scanArea * 2.0.h; // 감지 영역을 넓힘

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            QRView(
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated,
                              overlay: QrScannerOverlayShape(
                                borderColor: Theme.of(context).primaryColor,
                                borderRadius: 10.r,
                                borderLength: 30.w,
                                borderWidth: 15.w,
                                cutOutSize: cutOutHeight, // 감지 영역 확대
                              ),
                            ),
                            // 중앙에 빨간색 + 모양 가이드라인
                            Positioned(
                              top: ((screenHeight - cutOutHeight) / 2 +
                                  cutOutHeight / 1.6 - 1)
                                  .h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // 세로선
                                  Container(
                                    width: 4.w,
                                    height: 40.h,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  // 가로선
                                  Container(
                                    width: 40.w,
                                    height: 4.h,
                                    color: Theme.of(context).primaryColor,
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
                      color: Theme.of(context).primaryColor,
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
        ),
      ),
    );
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0); // 3배 확대
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!isScanned) {
        setState(() {
          result = scanData;
          isScanned = true;
        });
        controller.pauseCamera();

        // Firestore에 출석 정보를 추가/업데이트하는 함수 호출
        await addOrUpdateAttendance(context, widget.studentId, result!.code!);
        dispose();
      }
    });
  }
}
