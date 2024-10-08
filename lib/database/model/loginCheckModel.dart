class LoginCheckModel {
  final String id;
  final DateTime loginTime;
  final String managerId;
  final String studentId;

  LoginCheckModel({
    required this.id,
    required this.loginTime,
    required this.managerId,
    required this.studentId,
  });

  // Firestore에 데이터를 저장하기 위한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'loginTime': loginTime.toIso8601String(),  // DateTime을 ISO 8601 문자열로 변환
      'managerId': managerId,
      'studentId': studentId,
    };
  }

  // Firestore에서 데이터를 가져와 객체로 변환
  factory LoginCheckModel.fromMap(Map<String, dynamic> map) {
    return LoginCheckModel(
      id: map['id'],
      loginTime: DateTime.parse(map['loginTime']),  // 문자열을 DateTime으로 변환
      managerId: map['managerId'],
      studentId: map['studentId'],
    );
  }
}
