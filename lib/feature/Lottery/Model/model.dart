import 'package:cloud_firestore/cloud_firestore.dart';

class LotteryStudent {
  final String studentId;    // 학번
  final String name;         // 이름
  final String department;   // 학과
  final int attendanceCount; // 출석 횟수
  final DateTime? lotteryDate; // 추첨 일자 (nullable)

  LotteryStudent({
    required this.studentId,
    required this.name,
    required this.department,
    required this.attendanceCount,
    this.lotteryDate,
  });

  // Firestore에서 데이터를 가져와서 LotteryModel 객체로 변환
  factory LotteryStudent.fromFirestore(Map<String, dynamic> data, {required int attendanceCount}) {
    return LotteryStudent(
      studentId: data['student_id'] ?? '',
      name: data['name'] ?? '',
      department: data['department'] ?? '',
      attendanceCount: attendanceCount, // 받아온 출석 횟수를 할당
      lotteryDate: (data['lottery_date'] as Timestamp?)?.toDate(),
    );
  }

  // Firestore에 저장할 수 있는 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'student_id': studentId,
      'name':name,
      'department': department,
      'total_attendance': attendanceCount,

      if (lotteryDate != null) 'lottery_date': Timestamp.fromDate(lotteryDate!),
    };
  }
}