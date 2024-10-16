class Approvemodel {
  final String studentId;      // 학번
  final String name;           // 이름
  final String department;     // 학과
  final String role;          //관리자/학부생

  final bool is_approved; //관리자 승인 bool
  Approvemodel({
    required this.studentId,
    required this.name,
    required this.department,
    required this.role,
    required this.is_approved,


  });

  // Firestore에서 데이터를 가져와서 StudentAttendance 객체로 변환
  factory Approvemodel.fromFirestore(Map<String, dynamic> data) {
    return Approvemodel(
      studentId: data['student_id'] ?? '',
      name: data['name'] ?? '',
      department: data['department'] ?? '',
      role: data['role'] ?? '',
      is_approved: data['is_approved'] ?? '',
    );
  }

  // Firestore에 저장할 수 있는 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'student_id': studentId,
      'name': name,
      'department': department,
      'role': role,
      'is_approved': is_approved,

    };
  }
}
