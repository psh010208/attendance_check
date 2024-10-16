import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/logModel.dart';

class LogViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Firestore에서 사용자 정보 가져오기 (로그인 시 사용)
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

  // Firestore에 사용자 정보 저장하기 (회원가입 시 사용)
  Future<void> signUp(LogModel newUser) async {
    await _firestore
        .collection('user')
        .doc('${newUser.studentId}-${newUser.role}') // studentId와 role을 결합하여 문서 ID로 사용
        .set(newUser.toFirestore());
  }

// 로그인 검증 로직 (학번, 역할, 학과를 확인)
  Future<bool> logIn(String studentId, String role, String department) async {
    // Firestore에서 학번, 역할, 학과를 모두 확인
    QuerySnapshot snapshot = await _firestore
        .collection('user')
        .where('student_id', isEqualTo: studentId)
        .where('role', isEqualTo: role)
        .where('department', isEqualTo: department) // 학과도 추가하여 검증
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      LogModel user = LogModel.fromFirestore(snapshot.docs.first.data() as Map<String, dynamic>);
      // 관리자인 경우 승인 여부를 반드시 확인
      if (user.role == '관리자' && !user.isApproved) {
        return false; // 관리자는 승인 대기 중일 경우 로그인 불가
      }
      return true; // 로그인 성공
    }

    return false; // 로그인 실패 (정보가 일치하지 않는 경우)
  }

  // 학번 중복 확인 (회원가입 시 사용)
  Future<bool> isStudentIdDuplicate(String studentId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('user')
        .where('student_id', isEqualTo: studentId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
