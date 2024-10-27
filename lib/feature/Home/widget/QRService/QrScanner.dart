import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camera/camera.dart';

import 'ViewModel/QrViewModel.dart';

class QrScanner extends StatefulWidget {
  final String studentId;

  QrScanner({required this.studentId});

  @override
  State<StatefulWidget> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isScanned = false;
  late CameraController cameraController;
  List<CameraDescription>? cameras;
  bool isFlashOn = false;
  bool isCameraInitialized = false; // 카메라 초기화 상태 플래그 추가

  final TransformationController _transformationController =
  TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  // 카메라 초기화 함수
  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras!.first, // 후면 카메라 사용
      ResolutionPreset.high,
    );
    await cameraController.initialize();
    setState(() {
      isCameraInitialized = true; // 카메라 초기화 완료 후 플래그 변경
    });
  }

  @override
  Widget build(BuildContext context) {
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
                isFlashOn = !isFlashOn;
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
          panEnabled: false,
          minScale: 1.0,
          maxScale: 3.0,
          child: isCameraInitialized // 카메라가 초기화되었을 때만 QRView 렌더링
              ? Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 13,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double screenHeight = constraints.maxHeight;
                        double cutOutHeight = scanArea * 2.0.h;

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
                                cutOutSize: cutOutHeight,
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
          )
              : Center(child: CircularProgressIndicator()), // 카메라가 초기화 중일 때 로딩 표시
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
        ..scale(3.0);
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

        // Firestore에 출석 정보를 추가/업데이트하는 함수 호출 (학생_ID/QR_CODE)
        await addOrUpdateAttendance(context, widget.studentId, result!.code!);
        dispose();
      }
    });
  }
}