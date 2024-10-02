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
