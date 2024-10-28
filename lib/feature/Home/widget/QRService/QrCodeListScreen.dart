import 'package:attendance_check/feature/Home/widget/QRService/widget/qr_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Home/homeScreen.dart';

import '../../../ApproveList/widget/CustomText.dart';

class QrCodeListScreen extends StatefulWidget {
  final String role;
  final String id;

  QrCodeListScreen({required this.role, required this.id});

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
            margin: EdgeInsets.symmetric(vertical: 10.w, horizontal: 15.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),

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
      appBar: AppBar(
        toolbarHeight: 50.h, // 반응형으로 상단바의 높이를 설정
        backgroundColor: Theme.of(context).primaryColorLight,
        title: CustomText(
          id : 'QR 코드 확인',size: 20.sp,
          color : Theme.of(context).colorScheme.scrim,),
        centerTitle: true,
        elevation: 1,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: Theme.of(context).colorScheme.scrim,
                size: 25.sp),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(role: widget.role, id: widget.id)));
            }),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                color: Theme.of(context).colorScheme.scrim,
              );
            },
          ),
        ],
      ),
      endDrawer: DrawerScreen(role: widget.role, id: widget.id,        isFriendView: false,
      ),
      body: Container(
        height: 800.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onInverseSurface,
              Theme.of(context).primaryColorLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.9],
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchSchedules(),
          builder: (context, snapshot) => _buildContent(snapshot),
        ),
      ),
    );
  }
}
