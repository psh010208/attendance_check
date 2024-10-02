import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_check/database/model/LoginCheckModel.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 로그인 체크 데이터를 Firestore에서 가져오는 함수
  Future<List<LoginCheckModel>> getLoginChecks() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('loginCheck')
          .orderBy('id', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return LoginCheckModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('로그인 체크 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }

  // 새로운 로그인 체크 데이터를 Firestore에 추가하는 함수
  Future<void> addLoginCheck(LoginCheckModel loginCheck) async {
    try {
      await _firestore.collection('loginCheck').add(loginCheck.toMap());
    } catch (e) {
      print('로그인 체크 데이터를 추가하는 중 오류 발생: $e');
    }
  }
}
