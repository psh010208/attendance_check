import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String scheduleName;
  final String location;
  final String instructorName;
  final DateTime startTime; // Timestamp 대신 DateTime으로 변경
  final DateTime endTime;    // Timestamp 대신 DateTime으로 변경

  Schedule({
    required this.scheduleName,
    required this.location,
    required this.instructorName,
    required this.startTime,
    required this.endTime,
  });

  // Firestore에서 데이터를 Schedule 객체로 변환하는 메서드
  factory Schedule.fromFirestore(Map<String, dynamic> data) {
    return Schedule(
      scheduleName: data['schedule_name '] ?? '이름 없음', // Default if field is null
      location: data['location '] ?? '위치 없음', // Default if field is null
      instructorName: data['instructor_name '] ?? '교수 없음', // Default if field is null
      startTime: (data['start_time '] as Timestamp).toDate(),  // Timestamp를 DateTime으로 변환
      endTime: (data['end_time '] as Timestamp).toDate(),      // Timestamp를 DateTime으로 변환
    );
  }

  // Firestore로 데이터를 저장할 수 있도록 Schedule 객체를 Map으로 변환하는 메서드
  Map<String, dynamic> toFirestore() {
    return {
      'schedule_name': scheduleName,
      'location': location,
      'instructor_name': instructorName,
      'start_time': Timestamp.fromDate(startTime), // DateTime을 Timestamp로 변환
      'end_time': Timestamp.fromDate(endTime),     // DateTime을 Timestamp로 변환
    };
  }
}
class Attendance {
  String studentId;
  String scheduleId;
  bool check;
  DateTime checkInTime;  // DateTime으로 변경
  DateTime checkOutTime; // DateTime으로 변경
  String qrInCode;
  String qrOutCode;

  Attendance({
    required this.studentId,
    required this.scheduleId,
    required this.check,
    required this.checkInTime,
    required this.checkOutTime,
    required this.qrInCode,
    required this.qrOutCode,
  });

  // Firestore 데이터를 Attendance 객체로 변환하는 메서드
  factory Attendance.fromFirestore(Map<String, dynamic> data, String id) {
    return Attendance(
      studentId: data['student_id'] ?? '',
      scheduleId: data['schedule_id'] ?? '',
      check: data['check'] ?? false,
      checkInTime: (data['check_in_time'] as Timestamp).toDate(),  // Timestamp -> DateTime 변환
      checkOutTime: (data['check_out_time'] as Timestamp).toDate(), // Timestamp -> DateTime 변환
      qrInCode: data['qr_in_code'] ?? '',
      qrOutCode: data['qr_out_code'] ?? '',
    );
  }

  // Firestore에 저장하기 위한 데이터 변환 메서드
  Map<String, dynamic> toFirestore() {
    return {
      'student_id': studentId,
      'schedule_id': scheduleId,
      'check': check,
      'check_in_time': Timestamp.fromDate(checkInTime),  // DateTime -> Timestamp 변환
      'check_out_time': Timestamp.fromDate(checkOutTime), // DateTime -> Timestamp 변환
      'qr_in_code': qrInCode,
      'qr_out_code': qrOutCode,
    };
  }
}