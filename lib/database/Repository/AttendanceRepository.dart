import 'package:attendance_check/database/db_query/db_service.dart';
import 'package:attendance_check/database/model/attendanceModel.dart';

class AttendanceRepository {
  final DbService _dbService = DbService();

  // 새로운 출석 기록 추가
  Future<void> addAttendance(AttendanceModel attendance) async {
    await _dbService.add('attendance', attendance.toMap());
  }

  // 모든 출석 기록 조회
  Future<List<AttendanceModel>> fetchAllAttendances() async {
    List<Map<String, dynamic>> attendanceData = await _dbService.get('attendance');
    return attendanceData.map((data) => AttendanceModel.fromMap(data)).toList();
  }

  // 특정 출석 기록 업데이트
  Future<void> updateAttendance(String docId, AttendanceModel attendance) async {
    await _dbService.update('attendance', docId, attendance.toMap());
  }

  // 특정 출석 기록 삭제
  Future<void> deleteAttendance(String docId) async {
    await _dbService.delete('attendance', docId);
  }

  // 특정 ID로 출석 기록 조회
  Future<AttendanceModel?> fetchAttendanceById(String docId) async {
    Map<String, dynamic>? attendanceData = await _dbService.getDocumentById('attendance', docId);
    if (attendanceData != null) {
      return AttendanceModel.fromMap(attendanceData);
    }
    return null;
  }
}
