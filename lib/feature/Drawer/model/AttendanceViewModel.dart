import 'package:attendance_check/feature/Drawer/model/SchedulesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Home/model/homeModel.dart';
import 'AttendanceSummaryModel.dart';
import 'UserModel.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AttendanceViewModel {

  // 학생 ID로 User 데이터 가져오기
  Future<User?> getUserByStudentId(String studentId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .where('student_id', isEqualTo: studentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return User.fromFirestore(userData);
      }
      return null;
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  // 학생 ID로 AttendanceSummary에서 total_attendance 가져오기
  Future<int?> getTotalAttendanceByStudentId(String studentId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('attendance_summary')
          .where('student_id', isEqualTo: studentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var attendanceData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return attendanceData['total_attendance'] ?? 0;
      }
      return null;
    } catch (e) {
      print("Error getting attendance summary: $e");
      return null;
    }
  }
}
class ScheduleViewModel {

  String scheduleName = '';
  String location = '';
  String instructorName = '강사 미정'; // 기본값 설정
  DateTime? selectedDate;
  TimeOfDay? startTime;


// 일정 스트림을 받아오는 메서드 (start_time 기준으로 내림차순 정렬)
  Stream<List<Schedule>> getScheduleStream() {
    return _firestore.collection('schedules')
        .orderBy('start_time', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Schedule.fromFirestore(doc)).toList());
  }

}
