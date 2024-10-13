import 'package:cloud_firestore/cloud_firestore.dart';
import 'AttendanceSummaryModel.dart';
import 'UserModel.dart';

class AttendanceViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
