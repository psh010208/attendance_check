import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_check/database/model/studentModel.dart';

class StudentDbQuery {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 학생 데이터를 Firestore에서 가져오는 함수
  Future<List<StudentModel>> getStudents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('student')
          .orderBy('studentId', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return StudentModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('학생 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }
  // 새로운 학생 데이터를 Firestore에 추가하는 함수
  Future<void> addStudent(StudentModel student) async {
    try {
      await _firestore.collection('student').add(student.toMap());
    } catch (e) {
      print('학생 데이터를 추가하는 중 오류 발생: $e');
    }
  }


}