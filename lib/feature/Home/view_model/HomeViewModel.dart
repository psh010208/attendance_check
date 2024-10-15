import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/homeModel.dart';

class AttendanceViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // QR 코드 생성 (랜덤 값 예시)
  String generateQrCode() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // QR 코드 출석 업데이트
  Future<void> updateAttendance(String studentId, String scheduleId, String qrCode) async {
    QuerySnapshot attendanceSnapshot = await _firestore
        .collection('attendance')
        .where('student_id', isEqualTo: studentId)
        .where('schedule_id', isEqualTo: scheduleId)
        .limit(1)
        .get();

    if (attendanceSnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = attendanceSnapshot.docs.first;

      // check 상태 및 시간을 업데이트
      await doc.reference.update({
        'check': true,
        'check_in_time': FieldValue.serverTimestamp(),
        'qr_in_code': qrCode,
      });
    } else {
      // 출석 기록이 없을 경우 새로 생성
      await _firestore.collection('attendance').add({
        'student_id': studentId,
        'schedule_id': scheduleId,
        'check': true,
        'check_in_time': FieldValue.serverTimestamp(),
        'qr_in_code': qrCode,
      });
    }
  }

}


class ScheduleViewModel {
  String scheduleName = '';
  String location = '';
  String instructorName = '강사 미정'; // 기본값 설정
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 일정 정보를 Firestore에 추가하는 메서드
  Future<void> addSchedule() async {
    if (scheduleName.isEmpty ||
        selectedDate == null ||
        startTime == null ||
        endTime == null ||
        location.isEmpty) {
      throw Exception('모든 필드를 입력해주세요.');
    }

    final startDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      startTime!.hour,
      startTime!.minute,
    );

    final endDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      endTime!.hour,
      endTime!.minute,
    );

    // Firestore에서 현재 일정 개수를 가져옴
    DocumentSnapshot<Map<String, dynamic>> scheduleDoc = await _firestore
        .collection('scheduleMeta')
        .doc('scheduleCountDoc')
        .get();

    int currentCount = scheduleDoc.data()?['scheduleCount'] ?? 0;

    // Firestore에 일정 추가
    await _firestore.collection('schedules').add({
      'schedule_name': scheduleName,
      'location': location,
      'instructor_name': instructorName,
      'start_time': Timestamp.fromDate(startDateTime),
      'end_time': Timestamp.fromDate(endDateTime),
      'schedule_count': currentCount + 1,
    });
  }
  Stream<List<Schedule>> getScheduleStream() {
    return _firestore.collection('schedule')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Schedule.fromFirestore(doc)).toList());
  }
}
