class LogModel {
  final String studentId;
  final String department;
  final String name;
  final String role;
  final bool isApproved;
  final List<String> friend; // 친구 목록 추가

  LogModel({
    required this.studentId,
    required this.department,
    required this.name,
    required this.role,
    required this.isApproved,
    this.friend = const [], // 기본값으로 빈 리스트 설정
  });

  // Firestore에서 데이터를 가져와서 LogModel 객체로 변환
  factory LogModel.fromFirestore(Map<String, dynamic> data) {
    return LogModel(
      studentId: data['student_id'] ?? '',
      department: data['department'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      isApproved: data['is_approved'] ?? false,
      friend: List<String>.from(data['friend'] ?? []), // 친구 목록 가져오기
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
      'friend': friend, // 친구 목록을 Firestore에 저장
    };
  }
}
