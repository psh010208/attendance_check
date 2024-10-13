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
    await _firestore.collection('user').add(newUser.toFirestore());
  }

// 로그인 검증 로직 (학번과 역할을 확인)
  Future<bool> logIn(String studentId, String role) async {
    LogModel? user = await getUser(studentId);

    if (user != null) {
      // 역할이 일치하는지 확인
      if (user.role == role) {
        // 관리자인 경우 승인 여부를 반드시 확인
        if (user.role == '관리자') {
          if (user.isApproved) {
            return true; // 승인된 관리자는 로그인 성공
          } else {
            return false; // 승인되지 않은 관리자는 로그인 실패
          }
        } else {
          // 관리자가 아닌 경우(학부생 등) 바로 로그인 성공
          return true;
        }
      }
    }
    return false; // 로그인 실패 (사용자 정보가 없거나 역할이 일치하지 않는 경우)
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
