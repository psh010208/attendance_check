import 'package:cloud_firestore/cloud_firestore.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AttendanceSummary {
  final String studentId;

  final int totalAttendance;

  AttendanceSummary({
    required this.studentId,

    required this.totalAttendance,
  });

  factory AttendanceSummary.fromFirestore(Map<String, dynamic> data) {
    return AttendanceSummary(
      studentId: data['student_id'] ?? '',
      totalAttendance: data['total_attendance'] ?? 0,
    );
  }
  // schedules 컬렉션의 문서 개수 가져오기
  Future<int> getTotalSchedules() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('schedules').get();
      return querySnapshot.docs.length; // 문서 개수 반환
    } catch (e) {
      print("Error getting schedules count: $e");
      return 0; // 에러가 나면 0 반환
    }
  }
}
