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
  bool isCameraInitialized = false;

  final TransformationController _transformationController =
  TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras!.first,
      ResolutionPreset.high,
    );
    await cameraController.initialize();
    setState(() {
      isCameraInitialized = true;
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
        title: Text('QR 코드 스캐너', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.scrim,
      ),
      body: GestureDetector(
        onDoubleTapDown: _handleDoubleTapDown,
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          panEnabled: false,
          minScale: 1.0,
          maxScale: 3.0,
          child: isCameraInitialized
              ? Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    flex: 13,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double screenHeight = constraints.maxHeight;
                        double cutOutHeight = scanArea * 2.2.h;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            QRView(
                              key: qrKey,
                              onQRViewCreated: _onQRViewCreated,
                              overlay: QrScannerOverlayShape(
                                borderColor: Theme.of(context).colorScheme.secondaryContainer,
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
                ],
              ),
              Positioned(
                bottom: 30.h,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isFlashOn ? Icons.flashlight_off : Icons.flashlight_on,
                        size: 45.w,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        controller?.toggleFlash();
                        setState(() {
                          isFlashOn = !isFlashOn;
                        });
                      },
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '  플래시 ${isFlashOn ? "끄기" : "켜기"}',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
            ],
          )
              : Center(child: CircularProgressIndicator()),
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

        await addOrUpdateAttendance(context, widget.studentId, result!.code!);

        // QR 코드 인식 후 뒤로가기
        Navigator.pop(context);
      }
    });
  }
}
