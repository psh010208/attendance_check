import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/NotificationServiceModel.dart';
import '../NotificationService.dart';

class NotificationServiceViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 일정 목록을 가져오는 메서드
  Future<List<NotificationServiceModel>> fetchSchedules() async {
    final querySnapshot = await _firestore.collection('schedules').get();

    // 각 문서를 NotificationServiceModel로 변환하여 리스트로 반환
    return querySnapshot.docs.map((doc) {
      return NotificationServiceModel.fromMap(doc.data());
    }).toList();
  }

  // 알림 예약 설정
  Future<void> scheduleNotifications() async {
    print("알람 예약 시작");

    // 즉각적인 테스트를 위해 다음 줄을 추가
    DateTime testNotificationTime = DateTime.now().add(Duration(seconds: 5)); // 5초 후

    // 테스트 알림 예약
    await NotificationService.scheduleNotification(
      "테스트 일정",
      testNotificationTime,
    );

    // Firestore에서 일정 가져오기
    List<NotificationServiceModel> schedules = await fetchSchedules();

    for (var schedule in schedules) {
      DateTime notificationTime = schedule.startTime.subtract(Duration(minutes: 10));

      if (notificationTime.isBefore(DateTime.now())) {
        print('예약된 알림 시간이 현재 시각보다 과거입니다: $notificationTime');
        continue; // 과거 시간인 경우 해당 알림 예약을 건너뜀
      }

      print('예약된 알람: ${schedule.scheduleName} at $notificationTime');
      await NotificationService.scheduleNotification(
        schedule.scheduleName,
        notificationTime,
      );
    }
  }
}
