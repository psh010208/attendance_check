import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';

class QrCodeListScreen extends StatefulWidget {
  @override
  _QrCodeListScreenState createState() => _QrCodeListScreenState();
}

class _QrCodeListScreenState extends State<QrCodeListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchSchedules() async {
    QuerySnapshot snapshot = await _firestore.collection('schedules').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> _saveQrCodeAsPng(String qrCode) async {
    try {
      final qrImage = await QrPainter(
        data: qrCode,
        version: QrVersions.auto,
        gapless: false,
        color: Colors.black,
        emptyColor: Colors.white,
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

  void _showQrCodeDialog(String qrCode) {
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
                data: qrCode, // QR 코드 데이터를 QrImage 위젯으로 시각화
                version: QrVersions.auto,
                color: Colors.black,
                emptyColor: Colors.white,
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
    return Scaffold(
      appBar: AppBar(title: Text('일정 QR 코드 목록')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('일정이 없습니다.'));
          }

          final schedules = snapshot.data!;

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              final qrCode = schedule['qr_code'] ?? 'N/A';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () => _showQrCodeDialog(qrCode), // Tap to show larger QR code
                  leading: Container(
                    width: 50,
                    height: 50,
                    child: CustomPaint(
                      size: Size.square(50),
                      painter: QrPainter(
                        data: qrCode, // QR 코드 데이터를 QrImage 위젯으로 시각화
                        version: QrVersions.auto,
                        color: Colors.black,
                        emptyColor: Colors.white,
                        gapless: false,
                      ),
                    ),
                  ),
                  title: Text(schedule['schedule_name'] ?? '일정 이름 없음'),
                  subtitle: Text('QR 코드: $qrCode'),
                  trailing: IconButton(
                    icon: Icon(Icons.save_alt),
                    onPressed: () => _saveQrCodeAsPng(qrCode),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
