import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/NotificationServiceModel.dart';
import '../NotificationService.dart';

class NotificationServiceViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 일정 목록을 가져오는 메서드
  Stream<List<NotificationServiceModel>> fetchSchedulesStream() {
    return _firestore.collection('schedules').snapshots().map((snapshot) {
      // 각 문서를 NotificationServiceModel로 변환하여 리스트로 반환
      return snapshot.docs.map((doc) {
        return NotificationServiceModel.fromMap(doc.data());
      }).toList();
    });
  }

  // 알림 예약 설정
  void listenToScheduleChanges() {
    fetchSchedulesStream().listen((schedules) {
      // Firestore에서 변경된 일정에 대해 알림 예약 설정
      scheduleNotifications(schedules);
    });
  }

  // 알림 예약 설정
  Future<void> scheduleNotifications(List<NotificationServiceModel> schedules) async {
    print("알람 예약 시작");

    for (var schedule in schedules) {
      DateTime notificationTime = schedule.startTime.subtract(Duration(minutes: 10));

      if (notificationTime.isBefore(DateTime.now())) {
        print('예약된 알림 시간이 현재 시각보다 과거입니다: $notificationTime');
        continue; // 과거 시간인 경우 해당 알림 예약을 건너뜀
      }

      print('알람 예약: ${schedule.scheduleName} at $notificationTime'); // 예약된 알람 로그 추가
      await NotificationService.scheduleNotification(
        schedule.scheduleName,
        notificationTime,
      );
    }
  }

}
