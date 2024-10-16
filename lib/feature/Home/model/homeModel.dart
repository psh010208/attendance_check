import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String scheduleName;
  final String location;
  final String instructorName;
  final DateTime startTime;
  final DateTime endTime;
  final int scheduleCount;

  Schedule({
    required this.scheduleName,
    required this.location,
    required this.instructorName,
    required this.startTime,
    required this.endTime,
    required this.scheduleCount,
  });

  // Firestore 데이터를 Schedule 객체로 변환하는 메서드
  factory Schedule.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Schedule(
      scheduleName: data['schedule_name'],
      location: data['location'],
      instructorName: data['instructor_name'] ?? '강사 미정',
      startTime: (data['start_time'] as Timestamp).toDate(),
      endTime: (data['end_time'] as Timestamp).toDate(),
      scheduleCount: data['schedule_count'] ?? 0,
    );
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