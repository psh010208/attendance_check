// //누구인지 = 이름,학생/관리자
//
// import 'package:flutter/material.dart';
// import 'package:attendance_check/database/model/ManagerModel.dart';
//
// class Mypage extends StatelessWidget {
//   final String id;
//   final String role;
//
//   Mypage({required this.id, required this.role});
//
//   Future<Map<String, dynamic>?> _fetchData() async {
//
//
//     if (role == '학부생') {
//       return await studentRepo.getStudentInfoById(id); // Fetch student data
//     } else if (role == '교수(관리자)') {
//       ManagerModel? manager = await managerRepo.fetchManagerById(id); // Fetch manager data
//       if (manager != null) {
//         return manager.toMap(); // Convert to Map<String, dynamic>
//       }
//     }
//     return null; // Return null if no data is found
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>?>( // FutureBuilder 사용
//       future: _fetchData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('정보를 불러오는 중 오류가 발생했습니다.'));
//         } else if (!snapshot.hasData || snapshot.data == null) {
//           return Center(child: Text('정보를 찾을 수 없습니다.'));
//         }
//
//         final data = snapshot.data!;
//
//         return Column(
//         );
//       },
//     );
//   }
// }
