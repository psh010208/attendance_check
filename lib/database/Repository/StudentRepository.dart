import 'package:attendance_check/database/db_query/db_service.dart';
import 'package:attendance_check/database/model/studentModel.dart';

class StudentRepository {
  final DbService _dbService = DbService();

  // 새로운 학생 추가
  Future<void> addStudent(StudentModel student) async {
    try {
      await _dbService.add('student', student.toMap());
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  // 모든 학생 데이터 조회
  Future<List<StudentModel>> getAllStudents() async {
    try {
      List<Map<String, dynamic>> studentData = await _dbService.get('student');
      return studentData.map((data) => StudentModel.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching students: $e');
      return [];
    }
  }

  // 특정 학생 데이터 업데이트
  Future<void> updateStudent(String docId, StudentModel student) async {
    try {
      await _dbService.update('student', docId, student.toMap());
    } catch (e) {
      print('Error updating student: $e');
    }
  }

  // 특정 학생 데이터 삭제
  Future<void> deleteStudent(String docId) async {
    try {
      await _dbService.delete('student', docId);
    } catch (e) {
      print('Error deleting student: $e');
    }
  }

  // 특정 ID로 학생 데이터 조회
  Future<StudentModel?> fetchStudentById(String docId) async {
    try {
      Map<String, dynamic>? studentData = await _dbService.getDocumentById('student', docId);
      if (studentData != null) {
        return StudentModel.fromMap(studentData);
      }
    } catch (e) {
      print('Error fetching student by ID: $e');
    }
    return null;
  }
}
