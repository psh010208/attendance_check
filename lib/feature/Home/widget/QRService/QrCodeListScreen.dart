import 'package:attendance_check/feature/Home/widget/QRService/widget/qr_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Widget _buildContent(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildLoading();  // 로딩 상태일 때
    }

    if (snapshot.hasError) {
      return _buildError();  // 오류가 발생했을 때
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return _buildEmpty();  // 데이터가 없을 때
    }

    return _buildList(snapshot.data!);  // 데이터가 있을 때
  }

  Widget _buildLoading() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Container(
      alignment: Alignment.center,
      child: Text('오류가 발생했습니다.'),
    );
  }

  Widget _buildEmpty() {
    return Container(
      alignment: Alignment.center,
      child: Text('일정이 없습니다.'),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> schedules) {
    return SingleChildScrollView(
      child: Column(
        children: schedules.map((schedule) {
          final qrCode = schedule['qr_code'] ?? 'N/A';

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),

            ),
            child: QrCodeTile(
              qrCode: qrCode,
              scheduleName: schedule['schedule_name'] ?? '일정 이름 없음',
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchSchedules(),
        builder: (context, snapshot) => _buildContent(snapshot),
      ),
    );
  }
}
