// lib/feature/Home/model/homeModel.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule {
  final String scheduleName;
  final String location;
  final String instructorName;
  final String startTime; // String으로 변경
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
      startTime: (data['start_time'] as Timestamp).toDate().toString(),
      endTime: (data['end_time'] as Timestamp).toDate(),
      scheduleCount: data['schedule_count'] ?? 0,
    );
  }
}