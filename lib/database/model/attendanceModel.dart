class AttendanceModel {
  final String attendanceId;
  final String studentId;
  final String eventId;
  final DateTime attendanceTime;
  final String attendanceStatus;
  final String absence;
  final String perception;

  AttendanceModel({
    required this.attendanceId,
    required this.studentId,
    required this.eventId,
    required this.attendanceTime,
    required this.attendanceStatus,
    required this.absence,
    required this.perception,
  });

  // Firestore에 저장하기 위한 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'attendanceId': attendanceId,
      'studentId': studentId,
      'eventId': eventId,
      'attendanceTime': attendanceTime.toIso8601String(),  // DateTime을 ISO 8601 문자열로 변환
      'attendanceStatus': attendanceStatus,
      'absence': absence,
      'perception': perception,
    };
  }

  // Firestore에서 가져온 데이터를 AttendanceModel로 변환
  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      attendanceId: map['attendanceId'],
      studentId: map['studentId'],
      eventId: map['eventId'],
      attendanceTime: DateTime.parse(map['attendanceTime']),  // 문자열을 DateTime으로 변환
      attendanceStatus: map['attendanceStatus'],
      absence: map['absence'],
      perception: map['perception'],
    );
  }
}