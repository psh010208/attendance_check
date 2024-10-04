import 'package:attendance_check/database/db_query/db_service.dart';
import 'package:attendance_check/database/model/ManagerModel.dart';

class ManagerRepository {
  final DbService _dbService = DbService();

  // 새로운 매니저 추가
  Future<void> addManager(ManagerModel manager) async {
    try {
      await _dbService.add('manager', manager.toMap());
    } catch (e) {
      print('Error adding manager: $e');
    }
  }

  // 모든 매니저 데이터 조회
  Future<List<ManagerModel>> getAllManagers() async {
    try {
      List<Map<String, dynamic>> managerData = await _dbService.get('manager');
      return managerData.map((data) => ManagerModel.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching managers: $e');
      return [];
    }
  }

  // 특정 매니저 데이터 업데이트
  Future<void> updateManager(String docId, ManagerModel manager) async {
    try {
      await _dbService.update('manager', docId, manager.toMap());
    } catch (e) {
      print('Error updating manager: $e');
    }
  }

  // 특정 매니저 데이터 삭제
  Future<void> deleteManager(String docId) async {
    try {
      await _dbService.delete('manager', docId);
    } catch (e) {
      print('Error deleting manager: $e');
    }
  }

  // 특정 ID로 매니저 데이터 조회
  Future<ManagerModel?> fetchManagerById(String docId) async {
    try {
      Map<String, dynamic>? managerData = await _dbService.getDocumentById('manager', docId);
      if (managerData != null) {
        return ManagerModel.fromMap(managerData);
      }
    } catch (e) {
      print('Error fetching manager by ID: $e');
    }
    return null;
  }
}
