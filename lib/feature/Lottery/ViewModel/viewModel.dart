import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class LotteryStudent {
  final String dept;
  final String num;
  final String name;
  final int count;

  LotteryStudent({
    required this.dept,
    required this.num,
    required this.name,
    required this.count,
  });

  // Firestore에서 데이터를 가져와서 LotteryStudent 객체로 변환
  factory LotteryStudent.fromFirestore(Map<String, dynamic> data) {
    return LotteryStudent(
      dept: data['department'] ?? '',
      num: data['student_id'] ?? '',
      name: data['student_name'] ?? '',
      count: data['total_attendance'] ?? 0,
    );
  }
}

class LotteryViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 학생 리스트 가져오기
  Future<List<LotteryStudent>> getAllStudents() async {
    QuerySnapshot snapshot = await _firestore.collection('attendance_summary').get();
    return snapshot.docs.map((doc) {
      return LotteryStudent.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // 출석 횟수에 따라 추첨 진행
  Future<LotteryStudent> runLottery() async {
    List<LotteryStudent> students = await getAllStudents();

    // 출석 횟수에 따른 가중치 리스트 생성
    List<LotteryStudent> weightedPool = [];
    for (var student in students) {
      for (int i = 0; i < student.count; i++) {
        weightedPool.add(student); // 출석 횟수만큼 학생을 리스트에 추가
      }
    }

    // 랜덤 추첨
    Random random = Random();
    int winnerIndex = random.nextInt(weightedPool.length);
    LotteryStudent winner = weightedPool[winnerIndex];

    // Firestore에 당첨된 학생 정보 저장
    await _firestore.collection('lottery').add({
      'student_id': winner.num,
      'student_name': winner.name,
      'department': winner.dept,
      'lottery_date': FieldValue.serverTimestamp(),
    });

    return winner; // 추첨된 학생 정보 반환
  }

  // Firestore에서 추첨된 학생 리스트 가져오기
  Stream<List<LotteryStudent>> getLotteryResults() {
    return _firestore.collection('lottery').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return LotteryStudent.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
