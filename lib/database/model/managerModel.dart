class ManagerModel {
  final String managerId;
  final String department;
  final String name;
  final String password;
  final bool isApprove; // 이 필드가 필요함

  ManagerModel({
    required this.managerId,
    required this.department,
    required this.name,
    required this.password,
    required this.isApprove, // 필수로 받아서 사용
  });

  // Firestore 데이터를 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'managerId': managerId,
      'department': department,
      'name': name,
      'password': password,
      'isApprove': isApprove, // 이 필드도 포함
    };
  }

  // Firestore에서 데이터를 가져와 객체로 변환
  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      managerId: map['managerId'],
      department: map['department'],
      name: map['name'],
      password: map['password'],
      isApprove: map['isApprove'] ?? false, // 기본값은 false로 설정
    );
  }
}
