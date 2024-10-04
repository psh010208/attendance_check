class EventModel {
  final String eventId;
  final String eventName;
  final DateTime startTime;
  final DateTime endTime;
  final String eventLocation;
  final String eventDate;
  final String barcode;

  EventModel({
    required this.eventId,
    required this.eventName,
    required this.startTime,
    required this.endTime,
    required this.eventLocation,
    required this.eventDate,
    required this.barcode,
  });

  // Firestore에 데이터를 저장하기 위한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'startTime': startTime.toIso8601String(),  // DateTime을 문자열로 변환
      'endTime': endTime.toIso8601String(),      // DateTime을 문자열로 변환
      'eventLocation': eventLocation,
      'eventDate': eventDate,
      'barcode': barcode,
    };
  }

  // Firestore에서 데이터를 가져와 객체로 변환
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eventId: map['eventId'],
      eventName: map['eventName'],
      startTime: DateTime.parse(map['startTime']),  // 문자열을 DateTime으로 변환
      endTime: DateTime.parse(map['endTime']),      // 문자열을 DateTime으로 변환
      eventLocation: map['eventLocation'],
      eventDate: map['eventDate'],
      barcode: map['barcode'],
    );
  }
}
