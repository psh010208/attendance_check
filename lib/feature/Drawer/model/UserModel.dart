class User {
  final String studentId;
  final String name;
  final String department;
  final bool isApproved;
  final String role;

  User({
    required this.studentId,
    required this.name,
    required this.department,
    required this.isApproved,
    required this.role,
  });

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      studentId: data['student_id'] ?? '',
      name: data['name'] ?? '',
      department: data['department'] ?? '',
      isApproved: data['is_approved'] ?? false,
      role: data['role'] ?? 'student',
    );
  }
}
