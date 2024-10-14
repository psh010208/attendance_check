import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../Model/model.dart';

class LotteryViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 학생 리스트 가져오기 (attendance_summary의 total_attendance를 포함)
  Future<List<LotteryStudent>> getAllStudents() async {
    QuerySnapshot userSnapshot = await _firestore.collection('user').get();
    List<LotteryStudent> students = [];

    for (var doc in userSnapshot.docs) {
      final studentData = doc.data() as Map<String, dynamic>;

      // 해당 student_id로 attendance_summary에서 total_attendance 가져오기
      QuerySnapshot attendanceSnapshot = await _firestore
          .collection('attendance_summary')
          .where('student_id', isEqualTo: studentData['student_id'])
          .limit(1)
          .get();

      int totalAttendance = 0;
      if (attendanceSnapshot.docs.isNotEmpty) {
        final attendanceData = attendanceSnapshot.docs.first.data() as Map<String, dynamic>;
        totalAttendance = attendanceData['total_attendance'] ?? 0; // total_attendance 값 가져오기
      }

      // 학생 데이터와 함께 LotteryStudent 객체 생성 (attendanceCount에 totalAttendance 할당)
      students.add(LotteryStudent.fromFirestore(studentData, attendanceCount: totalAttendance));
    }

    return students;
  }

  Future<LotteryStudent> runLottery() async {
    List<LotteryStudent> students = await getAllStudents();

    // 출석 횟수에 따른 가중치 리스트 생성
    List<LotteryStudent> weightedPool = [];
    for (var student in students) {
      for (int i = 0; i < student.attendanceCount; i++) {
        weightedPool.add(student); // 출석 횟수만큼 학생을 리스트에 추가
      }
    }

    // 랜덤 추첨
    Random random = Random();
    int winnerIndex = random.nextInt(weightedPool.length);
    LotteryStudent winner = weightedPool[winnerIndex];

    // Firestore에 당첨된 학생 정보 저장
    await _firestore.collection('lottery').add({
      'student_id': winner.studentId,
      'student_name': winner.name,
      'department': winner.department,
      'attendance_count': winner.attendanceCount, // 출석 횟수 추가
      'lottery_date': FieldValue.serverTimestamp(),
    });

    return winner; // 추첨된 학생 정보 반환
  }


  // Firestore에서 추첨된 학생 리스트 가져오기
  Stream<List<LotteryStudent>> getLotteryResults() {
    return _firestore.collection('lottery').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return LotteryStudent.fromFirestore(doc.data() as Map<String, dynamic>, attendanceCount: 0);
      }).toList();
    });
  }
}
