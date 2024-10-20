import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'dart:io';

class QrCodeTile extends StatelessWidget {
  final String qrCode;
  final String scheduleName;

  QrCodeTile({required this.qrCode, required this.scheduleName});

  Future<void> _saveQrCodeAsPng(BuildContext context, String qrCode) async {
    try {
// QR 코드 이미지를 생성
      final qrImage = await QrPainter(
        data: qrCode,
        version: QrVersions.auto,
        gapless: false,
        color: Colors.black,
        // 전경색을 검정색으로 설정
        emptyColor: Colors.white, // 배경색을 흰색으로 설정
      ).toImage(500);

// 이미지 데이터를 PNG로 변환
      final ByteData? byteData =
          await qrImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

// image_gallery_saver를 사용해 갤러리에 저장
      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes), // 이미지 데이터를 Uint8List로 변환
        quality: 100, // 이미지 품질 설정
        name: 'qr_code_$qrCode', // 이미지 이름 설정
      );

      if (result['isSuccess']) {
// 성공적으로 저장되었을 때 알림 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR 코드가 갤러리에 저장되었습니다.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR 코드 저장에 실패했습니다.')),
        );
      }
    } catch (e) {
      print('QR 코드 저장 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR 코드 저장 중 오류가 발생했습니다.')),
      );
    }
  }

  Widget buildQrCode(String qrCode) {
    return Container(
      color: Colors.white, // QR 코드 배경을 흰색으로 설정
      padding: const EdgeInsets.all(10.0),
      child: CustomPaint(
        size: Size.square(1000),
        painter: QrPainter(
          data: qrCode,
          version: QrVersions.auto,
          color: Colors.black, // QR 코드 전경색을 검정으로 설정
          gapless: false,
        ),
      ),
    );
  }

  // QR 코드 확인 페이지에서 QR 누르면 뜨는 창
  void _showQrCodeDialog(BuildContext context, String qrCode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:Colors.white ,
          content: Container(
            color: Colors.white,
            height: 300.h,
            width: 300.w,
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
              child: Text('닫기',
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Theme.of(context).colorScheme.shadow)),
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
        border: Border.all(
            color: Theme.of(context).colorScheme.shadow,
            width: 2.w,
            strokeAlign: BorderSide.strokeAlignOutside),
        // Border 색상 설정
        borderRadius: BorderRadius.circular(10.r), // 모서리 둥글게 설정
      ),
      margin: EdgeInsets.symmetric(vertical: 4.w, horizontal: 4.h), // 컨테이너 외부 여백
      child: ListTile(
        onTap: () => _showQrCodeDialog(context, qrCode),
        leading: Container(
          width: 50.w,
          height: 50.h,
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
          style: TextStyle(
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.shadow,
              fontWeight: FontWeight.bold), // 일정 이름 색상 설정
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
          children: [
            SizedBox(height: 6.h),
            Text(
              '- QR 코드: $qrCode',
              style: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(context).colorScheme.shadow,
                fontWeight: FontWeight.bold,
              ), // QR 코드 텍스트 색상 설정
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.save_alt, size: 30.w),
          color: Theme.of(context).colorScheme.shadow,
          onPressed: () => _saveQrCodeAsPng(context, qrCode),
        ),
      ),
    );
  }
}
