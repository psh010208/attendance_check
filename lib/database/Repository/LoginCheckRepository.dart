import 'package:attendance_check/database/db_query/db_service.dart';
import 'package:attendance_check/database/model/loginCheckModel.dart';

class LoginCheckRepository {
  final DbService _dbService = DbService();

  // 새로운 로그인 기록 추가
  Future<void> addLoginCheck(LoginCheckModel loginCheck) async {
    await _dbService.add('login_check', loginCheck.toMap());
  }

  // 모든 로그인 기록 조회
  Future<List<LoginCheckModel>> fetchAllLoginChecks() async {
    List<Map<String, dynamic>> loginCheckData = await _dbService.get('login_check');
    return loginCheckData.map((data) => LoginCheckModel.fromMap(data)).toList();
  }

  // 특정 로그인 기록 업데이트
  Future<void> updateLoginCheck(String docId, LoginCheckModel loginCheck) async {
    await _dbService.update('login_check', docId, loginCheck.toMap());
  }

  // 특정 로그인 기록 삭제
  Future<void> deleteLoginCheck(String docId) async {
    await _dbService.delete('login_check', docId);
  }

  // 특정 ID로 로그인 기록 조회
  Future<LoginCheckModel?> fetchLoginCheckById(String docId) async {
    Map<String, dynamic>? loginCheckData = await _dbService.getDocumentById('login_check', docId);
    if (loginCheckData != null) {
      return LoginCheckModel.fromMap(loginCheckData);
    }
    return null;
  }
}