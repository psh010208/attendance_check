import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_check/database/model/managerModel.dart';

class ManagerDbQuery {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 관리자 데이터를 Firestore에서 가져오는 함수
  Future<List<ManagerModel>> getManagers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('manager')
          .orderBy('managerId', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return ManagerModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('관리자 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }

  // 새로운 관리자 데이터를 Firestore에 추가하는 함수
  Future<void> addManager(ManagerModel manager) async {
    try {
      await _firestore.collection('manager').add(manager.toMap());
    } catch (e) {
      print('관리자 데이터를 추가하는 중 오류 발생: $e');
    }
  }

}
