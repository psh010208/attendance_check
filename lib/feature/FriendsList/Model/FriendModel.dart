class FriendModel {
  final String studentId; // 친구의 student_id
  final String name;      // 친구의 이름
  final String department; // 친구의 학과

  FriendModel({
    required this.studentId,
    required this.name,
    required this.department,
  });

  // Firestore에서 데이터를 가져와서 FriendModel 객체로 변환
  factory FriendModel.fromFirestore(Map<String, dynamic> data) {
    return FriendModel(
      studentId: data['student_id'] ?? '',
      name: data['name'] ?? '',
      department: data['department'] ?? '',
    );
  }

  // Firestore에 저장할 수 있는 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'student_id': studentId,
      'name': name,
      'department': department,
    };
  }
}
