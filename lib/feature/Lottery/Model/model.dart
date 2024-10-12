import 'package:cloud_firestore/cloud_firestore.dart';

class LotteryModel {
  final String studentId;    // 학번
  final String name;         // 이름
  final String department;   // 학과
  final int attendanceCount; // 출석 횟수
  final DateTime? lotteryDate; // 추첨 일자 (nullable)

  LotteryModel({
    required this.studentId,
    required this.name,
    required this.department,
    required this.attendanceCount,
    this.lotteryDate,
  });

  // Firestore에서 데이터를 가져와서 LotteryModel 객체로 변환
  factory LotteryModel.fromFirestore(Map<String, dynamic> data) {
    return LotteryModel(
      studentId: data['student_id'] ?? '',
      name: data['student_name'] ?? '',
      department: data['department'] ?? '',
      attendanceCount: data['total_attendance'] ?? 0,
      lotteryDate: (data['lottery_date'] as Timestamp?)?.toDate(),
    );
  }

  // Firestore에 저장할 수 있는 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'student_id': studentId,
      'student_name': name,
      'department': department,
      'total_attendance': attendanceCount,
      if (lotteryDate != null) 'lottery_date': Timestamp.fromDate(lotteryDate!),
    };
  }
}
