class ManagerModel {
  final String managerId;
  final String department;
  final String name;
  final String password;

  ManagerModel({
    required this.managerId,
    required this.department,
    required this.name,
    required this.password,
  });

  // Firestore에 데이터를 저장하기 위한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'managerId': managerId,
      'department': department,
      'name': name,
      'password': password,
    };
  }

  // Firestore에서 데이터를 가져와 객체로 변환
  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      managerId: map['managerId'],
      department: map['department'],
      name: map['name'],
      password: map['password'],
    );
  }
}
