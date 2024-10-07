import 'package:flutter/material.dart';
import 'package:attendance_check/database/Repository/ManagerRepository.dart';
import 'package:attendance_check/database/Repository/StudentRepository.dart';
import 'package:attendance_check/database/model/ManagerModel.dart';

class Mypage extends StatelessWidget {
  final String id;
  final String role; // 역할 정보 추가 ('학부생' 또는 '교수(관리자)')

  final StudentRepository studentRepo = StudentRepository();
  final ManagerRepository managerRepo = ManagerRepository();

  Mypage({required this.id, required this.role});

  Future<Map<String, dynamic>?> _fetchData() async {
    if (role == '학부생') {
      return await studentRepo.getStudentInfoById(id); // Fetch student data
    } else if (role == '교수(관리자)') {
      ManagerModel? manager = await managerRepo.fetchManagerById(id); // Fetch manager data
      if (manager != null) {
        return manager.toMap(); // Convert to Map<String, dynamic>
      }
    }
    return null; // Return null if no data is found
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('정보를 불러오는 중 오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('정보를 찾을 수 없습니다.'));
          }

          final data = snapshot.data!;

          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Text(
                    '내 정보',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff0d47a1),
                ),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text(
                  data['name'] ?? '이름 없음', // Display name
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  data['department'] ?? '부서 정보 없음',  // Display department
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '밀어서 닫기',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
