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
      await _firestore.collection('attendance').doc(studentId).set({
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

  // QR 코드 생성 (랜덤 값 예시)
  String generateQrCode() {
    return DateTime.now().millisecondsSinceEpoch.toString(); // 현재 시간 기반으로 QR 코드 생성
  }

  // 일정 정보를 Firestore에 추가하는 메서드 (QR 코드 포함)
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

    // QR 코드 생성
    String qrCode = generateQrCode();

    // 관리자 모드로 일정 추가시, 데이터 베이스에 일정 등록
    await _firestore.collection('schedules').add({
      'schedule_name': scheduleName,
      'location': location,
      'instructor_name': instructorName,
      'start_time': Timestamp.fromDate(startDateTime),
      'end_time': Timestamp.fromDate(endDateTime),
      'qr_code': qrCode,  // QR 코드 추가
    });
  }

  // 일정 스트림을 받아오는 메서드 (일정 시작 시간 (start_time) 기준으로 정렬하고 end_time이 지난 일정들은 맨 뒤에 배치)
  Stream<List<Schedule>> getScheduleStream() {
    return _firestore
        .collection('schedules')
        .orderBy('start_time', descending: true)
        .snapshots()
        .map((snapshot) {
      final now = DateTime.now();

      // 모든 일정 문서를 Schedule 객체로 변환
      final allSchedules = snapshot.docs.map((doc) => Schedule.fromFirestore(doc)).toList();

      // 현재 시각 기준으로 end_time이 지난 일정과 그렇지 않은 일정을 구분
      final pastSchedules = allSchedules.where((schedule) => schedule.endTime.isBefore(now)).toList();
      final activeSchedules = allSchedules.where((schedule) => schedule.endTime.isAfter(now)).toList();

      // 종료된 일정을 먼저, 종료되지 않은 일정을 나중에 반환
      return [...pastSchedules, ...activeSchedules];
    });
  }

}