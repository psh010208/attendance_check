import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/model.dart';

class ViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 관리자 권한 확인
  Future<bool> isAdmin(String userId) async {
    DocumentSnapshot userSnapshot = await _firestore.collection('user').doc(userId).get();
    return userSnapshot.exists && userSnapshot['is_approved'] == true;
  }

  // 승인 대기 중인 관리자 리스트 가져오기 (is_approved == false)
  Stream<List<currentListModel>> getPendingAdmins() async* {
    yield* _firestore
        .collection('user')
        .where('role', isEqualTo: '관리자')
        .where('is_approved', isEqualTo: false) // 승인 대기 중인 관리자만 필터링
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return currentListModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // 관리자 승인 처리 (is_approved를 true로 변경)
  Future<void> approveAdmin(String studentId) async {
    await _firestore.collection('user').doc(studentId).update({
      'is_approved': true, // 승인 처리
    });
  }

  // 학생 출석 현황 가져오기 (관리자만 볼 수 있음)
  Stream<List<currentListModel>> getCurrentList(String userId) async* {
    bool isAdminUser = await isAdmin(userId);
    if (isAdminUser) {
      yield* _firestore.collection('attendance_summary').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return currentListModel.fromFirestore(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } else {
      throw Exception('관리자만 이 정보를 볼 수 있습니다.');
    }
  }
}
