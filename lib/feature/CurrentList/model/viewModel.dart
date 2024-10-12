import 'package:cloud_firestore/cloud_firestore.dart';
import 'model.dart';

class ViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 관리자 권한 확인
  Future<bool> isAdmin(String userId) async {
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userId).get();
    return userSnapshot.exists && userSnapshot['is_approved'] == true;
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

  //학번으로 검색
  Stream<List<currentListModel>> searchByStudentId(String studentId) async* {
    yield* _firestore
        .collection('attendance_summary')
        .where('student_id', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return currentListModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  //이름으로 검색
  Stream<List<currentListModel>> searchByName(String name) async* {
    yield* _firestore
        .collection('attendance_summary')
        .where('student_name', isEqualTo: name)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return currentListModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // 학과로 정렬
  Stream<List<currentListModel>> sortByDepartment() async* {
    yield* _firestore
        .collection('attendance_summary')
        .orderBy('department', descending: false) // 학과 오름차순 정렬 (ㄱ,ㄴ,ㄷ 순)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return currentListModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

 //출석 횟수로 정렬
  Stream<List<currentListModel>> sortByAttendanceCount() async* {
    yield* _firestore
        .collection('attendance_summary')
        .orderBy('total_attendance', descending: true) // 출석 횟수 내림차순 정렬
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return currentListModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
