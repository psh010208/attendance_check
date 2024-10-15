import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> addOrUpdateAttendance(String studentId, String qrCode) async {
  try {
    // schedules 컬렉션에서 QR 코드가 존재하는지 확인하고 schedule_name 가져오기
    QuerySnapshot scheduleSnapshot = await _firestore
        .collection('schedules')
        .where('qr_code', isEqualTo: qrCode)
        .limit(1)
        .get();

    if (scheduleSnapshot.docs.isNotEmpty) {
      // QR 코드에 해당하는 schedule_name 가져오기 (데이터를 Map<String, dynamic>으로 캐스팅)
      Map<String, dynamic>? scheduleData = scheduleSnapshot.docs.first.data() as Map<String, dynamic>?;
      String? scheduleName = scheduleData?['schedule_name'] as String?;

      if (scheduleName != null) {
        // attendance 컬렉션에서 student_id가 있는지 확인
        QuerySnapshot attendanceSnapshot = await _firestore
            .collection('attendance')
            .where('student_id', isEqualTo: studentId)
            .limit(1)
            .get();

        if (attendanceSnapshot.docs.isNotEmpty) {
          // 이미 출석 기록이 있으면 해당 문서를 업데이트
          DocumentReference attendanceDoc = attendanceSnapshot.docs.first.reference;

          // schedule_name 배열에 새로 찍힌 QR 코드에 해당하는 schedule_name을 추가
          await attendanceDoc.update({
            'schedule_names': FieldValue.arrayUnion([scheduleName]),
            'check_in_time': FieldValue.serverTimestamp(), // 시간을 업데이트
          });
          print('출석 기록이 업데이트되었습니다.');
        } else {
          // 출석 기록이 없으면 새로 생성
          await _firestore.collection('attendance').add({
            'student_id': studentId,
            'qr_code': qrCode,
            'schedule_names': [scheduleName], // 새로운 schedule_name 배열로 저장
            'check': true,
            'check_in_time': FieldValue.serverTimestamp(),
          });
          print('새로운 출석 기록이 생성되었습니다.');
        }
      } else {
        print('schedule_name이 존재하지 않습니다.');
      }
      await _updateTotalAttendance(studentId);
    } else {
      // QR 코드가 schedules 테이블에 없을 경우
      print('해당 QR 코드를 찾을 수 없습니다.');
    }
  } catch (e) {
    print('출석 기록을 추가하거나 업데이트하는 중 에러가 발생했습니다: $e');
  }
}

// 다이얼로그를 띄우는 함수
void _showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('오류'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
        ],
      );
    },
  );
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
      List<dynamic> scheduleNames = attendanceDoc['schedule_names'] ?? [];

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
          'total_attendance': scheduleNames.length, // schedule_names 리스트의 길이를 total_attendance에 저장
        });
        print('attendance_summary의 total_attendance가 업데이트되었습니다.');
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