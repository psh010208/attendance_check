import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/homeModel.dart';

class AttendanceViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 일정 추가
  Future<void> addSchedule(Schedule schedule) async {
    await _firestore.collection('schedules').add(schedule.toFirestore());
  }

  // QR 코드 생성 (랜덤 값 예시)
  String generateQrCode() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // QR 코드 출석 업데이트
  Future<void> updateAttendance(String studentId, String scheduleId, String qrCode) async {
    QuerySnapshot attendanceSnapshot = await _firestore
        .collection('attendance')
        .where('student_id', isEqualTo: studentId)
        .where('schedule_id', isEqualTo: scheduleId)
        .limit(1)
        .get();

    if (attendanceSnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = attendanceSnapshot.docs.first;

      // check 상태 및 시간을 업데이트
      await doc.reference.update({
        'check': true,
        'check_in_time': FieldValue.serverTimestamp(),
        'qr_in_code': qrCode,
      });
    } else {
      // 출석 기록이 없을 경우 새로 생성
      await _firestore.collection('attendance').add({
        'student_id': studentId,
        'schedule_id': scheduleId,
        'check': true,
        'check_in_time': FieldValue.serverTimestamp(),
        'qr_in_code': qrCode,
      });
    }
  }

}

class ScheduleViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Firestore에서 모든 일정 데이터를 가져오는 스트림
  Stream<List<Schedule>> getSchedules() {
    return _firestore.collection('schedules').snapshots().map((snapshot) {
      // Firestore 데이터에서 각 문서를 Schedule 객체로 변환
      return snapshot.docs.map((doc) {
        return Schedule.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
  // Firestore에서 일정 데이터를 스트림으로 가져오는 메서드
  Stream<List<Schedule>> getScheduleStream() {
    return _firestore.collection('schedules').snapshots().map((snapshot) {
      // 스냅샷을 List<Schedule>로 변환
      return snapshot.docs.map((doc) {
        final scheduleData = doc.data() as Map<String, dynamic>;
        return Schedule.fromFirestore(scheduleData);
      }).toList();
    });
  }

  // Firestore에서 특정 일정 추가
  Future<void> addSchedule(Schedule schedule) async {
    try {
      await _firestore.collection('schedules').add(schedule.toFirestore());
    } catch (e) {
      print('일정 추가 중 오류가 발생했습니다: $e');
    }
  }

  // Firestore에서 특정 일정 삭제
  Future<void> deleteSchedule(String scheduleId) async {
    try {
      // 해당 scheduleId로 문서 찾기
      QuerySnapshot snapshot = await _firestore
          .collection('schedules')
          .where('schedules_id', isEqualTo: scheduleId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // 문서가 있으면 삭제
        await snapshot.docs.first.reference.delete();
        print('일정이 삭제되었습니다.');
      } else {
        print('해당 일정이 없습니다.');
      }
    } catch (e) {
      print('일정 삭제 중 오류가 발생했습니다: $e');
    }
  }
}


