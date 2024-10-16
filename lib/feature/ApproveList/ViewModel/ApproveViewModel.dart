import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/ApproveModel.dart';

class ApproveViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _hasMoreData = true;
  bool _isLoading = false;

  // 확인 여부 함수 (스크롤 추가 로드용)
  bool hasMoreData() => _hasMoreData;

  // 로딩 여부 함수
  bool isLoading() => _isLoading;

  // Firestore에서 승인 대기 중인 관리자 목록 가져오기
  Future<List<Approvemodel>> fetchPendingAdmins() async {
    if (_isLoading || !_hasMoreData) return [];

    _isLoading = true;
    QuerySnapshot snapshot = await _firestore
        .collection('user')
        .where('role', isEqualTo: '관리자')
        .where('is_approved', isEqualTo: false)
        .limit(10)
        .get();

    if (snapshot.docs.isEmpty) {
      _hasMoreData = false;
      _isLoading = false;
      return [];
    }

    List<Approvemodel> admins = snapshot.docs.map((doc) {
      return Approvemodel.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();

    _isLoading = false;
    return admins;
  }

  // 승인 처리 함수
  Future<void> approveAdmin(String studentId, String role) async {
    try {
      await _firestore
          .collection('user')
          .doc('$studentId-$role')
          .update({'is_approved': true});
    } catch (e) {
      print('Error approving admin: $e');
    }
  }

  // 거절 처리 함수 (거절 시 Firestore에서 해당 사용자 삭제)
  Future<void> rejectAdmin(String studentId) async {
    try {
      await _firestore
          .collection('user')
          .doc('$studentId-관리자')
          .delete(); // 거절된 사용자를 삭제
    } catch (e) {
      print('Error rejecting admin: $e');
    }
  }
}
