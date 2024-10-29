import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../homeScreen.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
QRViewController? controller;

Future<void> addOrUpdateAttendance(BuildContext context, String studentId, String qrCode) async {
  try {
    // schedules 컬렉션에서 QR 코드가 존재하는지 확인하고 schedule_name과 start_time 가져오기
    QuerySnapshot scheduleSnapshot = await _firestore
        .collection('schedules')
        .where('qr_code', isEqualTo: qrCode)
        .limit(1)
        .get();

    if (scheduleSnapshot.docs.isNotEmpty) {
      // QR 코드에 해당하는 schedule_name 및 start_time 가져오기
      Map<String, dynamic>? scheduleData = scheduleSnapshot.docs.first.data() as Map<String, dynamic>?;
      String? scheduleName = scheduleData?['schedule_name'] as String?;
      String? scheduleQrCode = scheduleData?['qr_code'] as String?;
      Timestamp? startTime = scheduleData?['start_time'] as Timestamp?;

      if (scheduleName != null && scheduleQrCode != null && startTime != null) {
        // 출석 가능 시간 체크
        DateTime now = DateTime.now();
        DateTime start = startTime.toDate();
        //n분 설정
        DateTime BeforeStart = start.subtract(Duration(minutes: 10));
        DateTime AfterStart = start.add(Duration(minutes: 10));
        if (now.isBefore(BeforeStart)) {
          _showAlertDialog(context, '출석 가능한 시간이 아닙니다.',studentId);
          return;
        }
        if (now.isAfter(AfterStart)) {
          _showAlertDialog(context, '출석 가능한 시간이 지났습니다.',studentId);
          return;
        }

        // attendance 테이블에서 student_id가 있는지 확인
        QuerySnapshot attendanceSnapshot = await _firestore
            .collection('attendance')
            .where('student_id', isEqualTo: studentId)
            .limit(1)
            .get();

        if (attendanceSnapshot.docs.isNotEmpty) {
          // 출석 기록이 있는 경우 해당 문서를 가져옴
          DocumentSnapshot attendanceDoc = attendanceSnapshot.docs.first;
          List<dynamic> attendanceQrCodes = attendanceDoc['qr_code'] ?? [];

          // attendance 테이블의 qr_code 리스트에 스캔된 qr_code가 있는지 확인
          if (attendanceQrCodes.contains(scheduleQrCode)) {
            _showAlertDialog(context, '이미 출석한 일정입니다.',studentId);
            return;
          }

          // schedule_name 배열에 새로 찍힌 QR 코드에 해당하는 schedule_name을 추가
          await attendanceDoc.reference.update({
            'schedule_names': FieldValue.arrayUnion([scheduleName]),
            'qr_code': FieldValue.arrayUnion([scheduleQrCode]),
            'check_in_time': FieldValue.serverTimestamp(), // 시간을 업데이트
          });

          print('출석 기록이 업데이트되었습니다.');
        } else {
          // 출석 기록이 없으면 새로 생성
          await _firestore.collection('attendance').doc(studentId).set({
            'student_id': studentId,
            'qr_code': [scheduleQrCode],
            'schedule_names': [scheduleName], // 새로운 schedule_name 배열로 저장
            'check': true,
            'check_in_time': FieldValue.serverTimestamp(),
          });

          print('새로운 출석 기록이 생성되었습니다.');
        }

        // 출석 완료 팝업
        _showAlertDialog(context, '출석 완료되었습니다.',studentId);
      } else {
        _showAlertDialog(context, 'schedule_name이 존재하지 않습니다.',studentId);
      }

      // attendance_summary 업데이트
      await _updateTotalAttendance(studentId);
      print(studentId);
    } else {
      _showAlertDialog(context, '해당 QR 코드를 찾을 수 없습니다.',studentId);
    }
  } catch (e) {
    print('출석 기록을 추가하거나 업데이트하는 중 에러가 발생했습니다: $e');
    _showAlertDialog(context, 'QR 인식에 실패하였습니다.',studentId);
  }
}

Future<void> _updateTotalAttendance(String studentId) async {
  try {
    // attendance 테이블에서 student_id가 일치하는 기록을 가져옴
    QuerySnapshot attendanceSnapshot = await _firestore
        .collection('attendance')
        .where('student_id', isEqualTo: studentId)
        .limit(1)
        .get();

    if (attendanceSnapshot.docs.isNotEmpty) {
      DocumentSnapshot attendanceDoc = attendanceSnapshot.docs.first;
      List<dynamic> qrCodes = attendanceDoc['qr_code'] ?? [];
      // attendance_summary 테이블에서 해당 student_id와 일치하는 문서를 찾음
      QuerySnapshot summarySnapshot = await _firestore
          .collection('attendance_summary')
          .where('student_id', isEqualTo: studentId)
          .limit(1)
          .get();
      if (summarySnapshot.docs.isNotEmpty) {
        // 문서가 존재하면 해당 문서의 document ID로 업데이트
        DocumentReference summaryDocRef = summarySnapshot.docs.first.reference;
        await summaryDocRef.update({
          'total_attendance': qrCodes.length, // qrCode 리스트의 길이를 total_attendance에 저장
        });
        print('출석 횟수가 저장 되었습니다');
      } else {
        print('해당 student_id에 대한 attendance_summary 문서를 찾을 수 없습니다.');
      }
    } else {
      print('해당 student_id로 출석 기록을 찾을 수 없습니다.');
    }
  } catch (e) {
    print('attendance_summary 업데이트 중 오류 발생: $e');
  }
}

// 다이얼로그를 띄우는 함수
void _showAlertDialog(BuildContext context, String message, String studentId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('알림'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('확인'),
            onPressed: () {
              controller?.dispose();
              Navigator.of(context).pop(); // 다이얼로그 닫기
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen(role: '학부생', id: studentId)), // HomeScreen으로 이동
              );
            },
          ),
        ],
      );
    },
  );
}