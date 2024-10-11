import 'package:attendance_check/database/db_query/db_service.dart';
import 'package:attendance_check/database/model/eventModel.dart';

class EventRepository {
  final DbService _dbService = DbService();

  // 새로운 이벤트 추가
  Future<void> addEvent(EventModel event) async {
    await _dbService.add('event', event.toMap());
  }

  // 모든 이벤트 데이터 조회
  Future<List<EventModel>> fetchAllEvents() async {
    List<Map<String, dynamic>> eventData = await _dbService.get('event');
    return eventData.map((data) => EventModel.fromMap(data)).toList();
  }

  // 특정 이벤트 데이터 업데이트
  Future<void> updateEvent(String docId, EventModel event) async {
    await _dbService.update('event', docId, event.toMap());
  }

  // 특정 이벤트 데이터 삭제
  Future<void> deleteEvent(String docId) async {
    await _dbService.delete('event', docId);
  }

  // 특정 ID로 이벤트 데이터 조회
  Future<EventModel?> fetchEventById(String docId) async {
    Map<String, dynamic>? eventData = await _dbService.getDocumentById('event', docId);
    if (eventData != null) {
      return EventModel.fromMap(eventData);
    }
    return null;
  }
}