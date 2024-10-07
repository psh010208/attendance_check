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

  Future<ManagerModel?> fetchManagerById(String managerId) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('manager') // Ensure this is the correct collection name
          .where('managerId', isEqualTo: managerId) // Ensure this field exists in Firestore
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ManagerModel.fromMap(snapshot.docs.first.data());
      } else {
        return null; // Return null if no matching manager is found
      }
    } catch (e) {
      print('Error fetching manager by ID: $e');
      return null; // Handle and return null if an error occurs
    }
  }
}