import 'package:cloud_firestore/cloud_firestore.dart';

// Schedule.dart
class Schedule {
  final String title;
  final String time;
  final String location;
  final String professor;

  Schedule({
    required this.title,
    required this.time,
    required this.location,
    required this.professor,
  });
}

class HomeModel {
  // Firestore에서 Schedule 리스트를 가져오는 메서드
  Future<List<Schedule>> fetchSchedules() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('schedules').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Schedule(
        title: data['title'] ?? '',
        time: data['time'] ?? '',
        location: data['location'] ?? '',
        professor: data['professor'] ?? '',
      );
    }).toList();
  }
}
