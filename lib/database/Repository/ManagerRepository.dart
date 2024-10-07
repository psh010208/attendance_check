import 'package:cloud_firestore/cloud_firestore.dart';
import '../db_query/db_service.dart';
import '../model/ManagerModel.dart';

class ManagerRepository {
  final DbService _dbService = DbService();

  // 관리자 승인 상태 업데이트
  Future<void> approveManager(String managerId) async {
    try {
      await _dbService.update(
        'manager',
        managerId,
        {'isApprove': true},
      );
    } catch (e) {
      print('Error approving manager: $e');
    }
  }

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

  // 특정 ID로 매니저 데이터 조회
  Future<ManagerModel?> fetchManagerById(String managerId) async {
    try {
      Map<String, dynamic>? managerData =
      await _dbService.getDocumentById('manager', managerId);
      if (managerData != null) {
        return ManagerModel.fromMap(managerData);
      }
    } catch (e) {
      print('Error fetching manager by ID: $e');
    }
    return null;
  }
}
