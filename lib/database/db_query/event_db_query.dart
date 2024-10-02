import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attendance_check/database/model/EventModel.dart';

class EventFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 이벤트 데이터를 Firestore에서 가져오는 함수
  Future<List<EventModel>> getEvents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('event')
          .orderBy('eventId', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EventModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('이벤트 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }

  // 새로운 이벤트 데이터를 Firestore에 추가하는 함수
  Future<void> addEvent(EventModel event) async {
    try {
      await _firestore.collection('event').add(event.toMap());
    } catch (e) {
      print('이벤트 데이터를 추가하는 중 오류 발생: $e');
    }
  }

  // Firestore의 이벤트 컬렉션에서 첫 번째 데이터를 삭제하는 함수
  Future<void> deleteFirstEvent() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('event')
          .orderBy(FieldPath.documentId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String firstDocumentId = querySnapshot.docs[0].id;
        await _firestore.collection('event').doc(firstDocumentId).delete();
        print('첫 번째 이벤트 데이터 삭제 완료');
      } else {
        print('삭제할 데이터가 없습니다.');
      }
    } catch (e) {
      print('데이터 삭제 중 오류 발생: $e');
    }
  }
}
