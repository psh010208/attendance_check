import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart'; // UUID 패키지 추가
import '../Model/logModel.dart';

class LogViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // 토큰 생성 메서드
  String _generateToken() {
    var uuid = Uuid(); // Uuid 인스턴스 생성
    return uuid.v4(); // UUID v4 형식의 문자열 반환
  }

  Future<LogModel?> getUser(String studentId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('user')
        .where('student_id', isEqualTo: studentId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null; // 사용자 정보를 찾지 못한 경우
    } else {
      return LogModel.fromFirestore(snapshot.docs.first.data() as Map<String, dynamic>);
    }
  }

  Future<void> signUp(LogModel newUser) async {
    await _firestore
        .collection('user')
        .doc('${newUser.studentId}-${newUser.role}')
        .set(newUser.toFirestore());

    // 토큰 생성 및 저장
    String token = _generateToken();  // Generate the token
    await _storage.write(key: 'token', value: token); // Store the token

    // 사용자 정보 저장
    await _storage.write(key: 'studentId', value: newUser.studentId);
    await _storage.write(key: 'role', value: newUser.role);
    await _storage.write(key: 'department', value: newUser.department);

    // Token 값 출력
    print('회원가입 성공: studentId: ${newUser.studentId}, role: ${newUser.role}, department: ${newUser.department}, token: $token');
  }


  Future<bool> logIn(String studentId, String role, String department) async {
    QuerySnapshot snapshot = await _firestore
        .collection('user')
        .where('student_id', isEqualTo: studentId)
        .where('role', isEqualTo: role)
        .where('department', isEqualTo: department)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      LogModel user = LogModel.fromFirestore(snapshot.docs.first.data() as Map<String, dynamic>);

      if (user.role == '관리자' && !user.isApproved) {
        return false; // 관리자 승인 대기 중
      }

      // 토큰 생성 및 저장
      String token = _generateToken(); // Generate the token
      await _storage.write(key: 'token', value: token); // Store the token

      // 사용자 정보 저장
      await _storage.write(key: 'studentId', value: studentId);
      await _storage.write(key: 'role', value: role);
      await _storage.write(key: 'department', value: department);

      print('로그인 성공: studentId: $studentId, role: $role, department: $department, token: $token'); // Print the token
      return true; // 로그인 성공
    }

    return false; // 로그인 실패
  }

  Future<bool> isStudentIdDuplicate(String studentId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('user')
        .where('student_id', isEqualTo: studentId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<void> logout() async {
    String? studentId = await _storage.read(key: 'studentId');
    String? role = await _storage.read(key: 'role');
    String? department = await _storage.read(key: 'department');
    String? token = await _storage.read(key: 'token');
    print('로그아웃 이전의 값: studentId=$studentId, role=$role, department=$department, token=$token');

    await _storage.delete(key: 'studentId');
    await _storage.delete(key: 'role');
    await _storage.delete(key: 'department');
    await _storage.delete(key: 'token'); // 로그아웃 시 토큰 삭제

    String? studentId_ = await _storage.read(key: 'studentId');
    String? role_ = await _storage.read(key: 'role');
    String? department_ = await _storage.read(key: 'department');
    String? token_ = await _storage.read(key: 'token');
    print('로그아웃 완료: studentId=$studentId_, role=$role_, department=$department_, token=$token_');

  }
}
