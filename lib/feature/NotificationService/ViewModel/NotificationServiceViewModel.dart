import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../Model/NotificationServiceModel.dart';
import '../NotificationService.dart';

class NotificationServiceViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 일정 목록을 가져오는 메서드
  Future<List<NotificationServiceModel>> fetchSchedules() async {
    final querySnapshot = await _firestore.collection('schedules').get();
    return querySnapshot.docs.map((doc) {
      return NotificationServiceModel.fromMap(doc.data());
    }).toList();
  }

  // 일정 변경 리스너 추가
  void listenToScheduleChanges(BuildContext context) {
    _firestore.collection('schedules').snapshots().listen((snapshot) {
      print('일정 변경 감지됨');
      scheduleNotifications(context); // context를 전달하여 알림 예약 업데이트
    });
  }

  // 알림 예약 설정
  Future<void> scheduleNotifications(BuildContext context) async {


    List<NotificationServiceModel> schedules = await fetchSchedules();

    for (var schedule in schedules) {
      DateTime notificationTime = schedule.startTime.subtract(Duration(minutes: 10));

      if (notificationTime.isBefore(DateTime.now())) {
        print('예약된 알림 시간이 현재 시각보다 과거입니다: $notificationTime');
        continue; // 과거 시간인 경우 해당 알림 예약을 건너뜀
      }

      print('예약된 알림 시간: $notificationTime'); // 예약 시간 로그 추가
      await NotificationService.scheduleNotification(
        schedule.scheduleName,
        notificationTime,
        context, // context를 전달
      );
    }
  }
}
