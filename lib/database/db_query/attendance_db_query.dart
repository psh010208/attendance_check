import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_check/database/model/attendanceModel.dart';

class attendanceDbQuery {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 출석 데이터를 Firestore에서 가져오는 함수
  Future<List<AttendanceModel>> getAttendances() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('attendance')
          .orderBy('attendanceTime', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return AttendanceModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('출석 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }



  // 새로운 출석 데이터를 Firestore에 추가하는 함수
  Future<void> addAttendance(AttendanceModel attendance) async {
    try {
      await _firestore.collection('attendance').add(attendance.toMap());
    } catch (e) {
      print('출석 데이터를 추가하는 중 오류 발생: $e');
    }
  }


}