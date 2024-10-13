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

  factory Schedule.fromFirestore(Map<String, dynamic> data) {
    return Schedule(
      title: data['title'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      professor: data['professor'] ?? '',
    );
  }

  // Firestore에 저장할 수 있는 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'time': time,
      'location': location,
      'professor': professor,
    };
  }
}
