// NotificationServiceModel.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationServiceModel {
  final String scheduleName;
  final DateTime startTime;

  NotificationServiceModel({
    required this.scheduleName,
    required this.startTime,
  });

  // Firebase 문서 데이터를 모델 객체로 변환하는 팩토리 생성자
  factory NotificationServiceModel.fromMap(Map<String, dynamic> data) {
    return NotificationServiceModel(
      scheduleName: data['schedule_name'] ?? '알 수 없는 일정',
      startTime: (data['start_time'] as Timestamp).toDate(), // Firebase Timestamp를 DateTime으로 변환
    );
  }
}
