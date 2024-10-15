import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';

class QrCodeTile extends StatelessWidget {
  final String qrCode;
  final String scheduleName;

  QrCodeTile({required this.qrCode, required this.scheduleName});

  Future<void> _saveQrCodeAsPng(BuildContext context, String qrCode) async {
    try {
      final qrImage = await QrPainter(
        data: qrCode,
        version: QrVersions.auto,
        gapless: false,

      ).toImage(300);

      final ByteData? byteData = await qrImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/qr_code_$qrCode.png';

      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR 코드가 저장되었습니다: $filePath')),
      );
    } catch (e) {
      print('QR 코드 저장 중 오류 발생: $e');
    }
  }

  void _showQrCodeDialog(BuildContext context, String qrCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 300,
            width: 300,
            child: CustomPaint(
              size: Size.square(300),
              painter: QrPainter(
                data: qrCode,
                version: QrVersions.auto,

                gapless: false,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.shadow, width: 3.5.w,strokeAlign: BorderSide.strokeAlignOutside), // Border 색상 설정
        borderRadius: BorderRadius.circular(10), // 모서리 둥글게 설정
      ),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4), // 컨테이너 외부 여백
      child: ListTile(
        onTap: () => _showQrCodeDialog(context, qrCode),
        leading: Container(
          width: 50,
          height: 50,
          child: CustomPaint(
            size: Size.square(50),
            painter: QrPainter(
              data: qrCode,
              version: QrVersions.auto,

              gapless: false,
            ),
          ),
        ),
        title: Text(
          scheduleName,
          style: TextStyle(color: Theme.of(context).colorScheme.shadow, fontWeight: FontWeight.bold), // 일정 이름 색상 설정
        ),
        subtitle: Text(
          'QR 코드: $qrCode',
          style: TextStyle(color: Theme.of(context).colorScheme.shadow,fontWeight: FontWeight.bold), // QR 코드 텍스트 색상 설정
        ),
        trailing: IconButton(
          icon: Icon(Icons.save_alt),
          color: Theme.of(context).colorScheme.shadow,
          onPressed: () => _saveQrCodeAsPng(context, qrCode),
        ),
      ),
    );
  }
}
