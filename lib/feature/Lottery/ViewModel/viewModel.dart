import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../Model/model.dart';

class LotteryViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 학부생만 가져오기 (attendance_summary의 total_attendance를 포함)
  Future<List<LotteryStudent>> getAllStudents() async {
    // 'user' 컬렉션에서 'role' 필드가 '학부생'인 사람만 쿼리
    QuerySnapshot userSnapshot = await _firestore
        .collection('user')
        .where('role', isEqualTo: '학부생') // 학부생만 필터링
        .get();

    List<LotteryStudent> students = [];

    // 'schedules' 컬렉션에서 총 스케줄 개수 가져오기
    QuerySnapshot scheduleSnapshot = await _firestore.collection('schedules').get();
    int totalSchedules = scheduleSnapshot.size;

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

      // 스케줄 개수와 출석 횟수가 같은 사람만 리스트에 추가
      if (totalAttendance == totalSchedules) {
        students.add(LotteryStudent.fromFirestore(studentData, attendanceCount: totalAttendance));
      }
    }

    return students;
  }

  // 학부생들 대상으로 추첨을 실행 + 출석 횟수가 일정 갯수와 같은 사람만
  Future<LotteryStudent> runLottery() async {
    // 모든 학부생 데이터를 가져옴 (스케줄 개수와 출석 횟수가 같은 사람들)
    List<LotteryStudent> students = await getAllStudents();

    // Firestore에서 이미 추첨된 학생들의 ID를 가져옴
    QuerySnapshot alreadySelectedSnapshot = await _firestore.collection('lottery').get();
    List<String> alreadySelectedIds = alreadySelectedSnapshot.docs
        .map((doc) => doc['student_id'] as String)
        .toList();

    // 이미 추첨된 학생을 제외한 목록 생성
    List<LotteryStudent> eligibleStudents = students.where((student) {
      return !alreadySelectedIds.contains(student.studentId); // 이미 추첨된 학생 제외
    }).toList();

    // 출석 횟수에 따른 가중치 리스트 생성
    List<LotteryStudent> weightedPool = [];

    for (var student in eligibleStudents) {
      for (int i = 0; i < student.attendanceCount; i++) {
        weightedPool.add(student); // 출석 횟수만큼 학생을 리스트에 추가
      }
    }

    if (weightedPool.isEmpty) {
      throw Exception("추첨할 수 있는 학생이 없습니다.");
    }
    // 랜덤 추첨
    Random random = Random();
    int winnerIndex = random.nextInt(weightedPool.length);
    LotteryStudent winner = weightedPool[winnerIndex];

    return winner; // 추첨된 학생 정보 반환
  }

  // 등록 버튼 누르면 당첨자를 Firestore에 등록하는 메서드
  Future<void> registerWinner(LotteryStudent winner) async {
    await _firestore.collection('lottery').doc(winner.studentId).set({
      'student_id': winner.studentId,
      'name': winner.name,
      'department': winner.department,
      'attendance_count': winner.attendanceCount, // 출석 횟수 추가
      'lottery_date': FieldValue.serverTimestamp(),
    });
  }

  // Firestore에서 학부생 중 추첨된 학생 리스트 가져오기
  Stream<List<LotteryStudent>> getLotteryResults() {
    return _firestore
        .collection('lottery')
        .orderBy('lottery_date', descending: false) // 당첨된 날짜 기준으로 오름차순 정렬
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // 출석 횟수를 Firestore에서 가져와서 사용
        return LotteryStudent.fromFirestore(
          data,
          attendanceCount: data['attendance_count'] ?? 0,
        );
      }).toList();
    });
  }


  // 학생 정보 삭제 메서드 (학부생 포함)
  Future<void> deleteStudent(String studentId) async {
    try {
      // Firestore에서 해당 student_id를 가진 문서 찾기
      QuerySnapshot snapshot = await _firestore
          .collection('lottery')
          .where('student_id', isEqualTo: studentId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // 문서가 있으면 해당 문서 삭제
        await snapshot.docs.first.reference.delete();
        print('Student with student_id $studentId deleted successfully.');
      } else {
        print('No student found with student_id $studentId.');
      }
    } catch (e) {
      print('Error deleting student: $e');
    }
  }
}
