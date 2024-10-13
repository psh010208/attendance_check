class LogModel {
  final String studentId;
  final String department;
  final String name;
  final String role;
  final bool isApproved;

  LogModel({
    required this.studentId,
    required this.department,
    required this.name,
    required this.role,
    required this.isApproved,
  });

  // Firestore에서 데이터를 가져와서 LogModel 객체로 변환
  factory LogModel.fromFirestore(Map<String, dynamic> data) {
    return LogModel(
      studentId: data['student_id'] ?? '',
      department: data['department'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      isApproved: data['is_approved'] ?? false,
    );
  }

  // Firestore에 저장할 수 있는 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'student_id': studentId,
      'department': department,
      'name': name,
      'role': role,
      'is_approved': isApproved,
    };
  }
}
