import 'dart:async';
import 'dart:typed_data'; // Int64List 사용을 위한 import
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../Store/MyStore.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // 알림 초기화
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    // 알림 채널 생성
    await createNotificationChannel();
  }

  // 알림 채널 생성
  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'schedule_channel', // 채널 ID
      '일정 알림', // 채널 이름
      description: '일정 알림을 위한 채널',
      importance: Importance.max, // 알림 중요도 설정
      playSound: true,
      enableVibration: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    print("알림 채널 생성 완료"); // 추가된 로그
  }

  // 진동 및 배지 설정 포함 알림 표시 메서드
  static Future<void> showNotification(String scheduleName,BuildContext context) async {
    print('알림 표시: $scheduleName'); // 로그 추가
    final isAlarmEnabled = context.read<MyStore>().onAlarm;

    if (!isAlarmEnabled) {
      print('알림이 비활성화되어 있습니다.');
      return; // 알림이 비활성화된 경우 함수 종료
    }
    await _notificationsPlugin.show(
      0,
      'Soon Check',
      '$scheduleName 출석 가능 10분 전입니다.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'schedule_channel',
          '일정 알림',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
          enableLights: true,
          ledColor: Color(0xFF3A7BD5),
          ledOnMs: 1000,
          ledOffMs: 500,
        ),
      ),
    );

    print('알림이 표시되었습니다.'); // 추가된 로그
  }

// 특정 시간에 알림 예약
  static Future<void> scheduleNotification(String scheduleName, DateTime notificationTime, BuildContext context) async {
    if (notificationTime.isBefore(DateTime.now())) {
      print('예약된 알림 시간이 현재 시각보다 과거입니다: $notificationTime');
      return; // 유효하지 않은 경우 함수를 종료
    }

    final Duration duration = notificationTime.difference(DateTime.now()); // 예약 시간까지 남은 시간 계산

    print('알람 예약: $scheduleName at $notificationTime'); // 추가된 로그
    // Timer를 사용하여 알림 예약
    Timer(duration, () async {
      print('알람이 울립니다: $scheduleName'); // 알람 발송 전 로그
      await showNotification(scheduleName, context); // 알림 이름과 context 전달
    });
  }
}