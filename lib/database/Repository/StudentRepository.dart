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
  // 전체 학생의 이름만 조회
  Future<List<String>> getAllStudentNames() async {
    try {
      var snapshot =  await _dbService.get('student');
      return snapshot.map((doc) => doc['name'] as String).toList(); // 이름만 리스트로 반환
    } catch (e) {
      print('Error fetching student names: $e');
      return [];
    }
  }
// 특정 학생의 이름, 학과, 전화번호, 비밀번호를 조회
  Future<Map<String, dynamic>?> getStudentInfoById(String studentId) async {
    try {
      // 'student' 컬렉션에서 모든 학생 데이터를 가져옴
      List<Map<String, dynamic>> students = await _dbService.get('student');

      // studentId와 일치하는 학생을 찾음
      for (var student in students) {
        if (student['studentId'] == studentId) {
          // 학생의 정보 반환 (이름, 학과, 전화번호, 비밀번호 포함)
          return {
            'name': student['name'],
            'department': student['department'],
            'tel': student['tel'],
            'password': student['password']
          };
        }
      }

      return null; // 해당 studentId를 가진 학생이 없는 경우
    } catch (e) {
      print('Error fetching student info: $e');
      return null;
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