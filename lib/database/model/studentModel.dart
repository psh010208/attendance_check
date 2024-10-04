class StudentModel {
  final String studentId;
  final String department;
  final String name;
  final String tel;
  final String password;
  final String? subscription;  // nullable 필드

  StudentModel({
    required this.studentId,
    required this.department,
    required this.name,
    required this.tel,
    required this.password,
    this.subscription,  // nullable 필드
  });

  // Firestore에 저장하기 위한 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'department': department,
      'name': name,
      'tel': tel,
      'password': password,
      'subscription': subscription,
    };
  }

  // Firestore에서 데이터를 가져와 StudentModel로 변환
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      studentId: map['studentId'],
      department: map['department'],
      name: map['name'],
      tel: map['tel'],
      password: map['password'],
      subscription: map['subscription'],  // nullable 처리
    );
  }
}
