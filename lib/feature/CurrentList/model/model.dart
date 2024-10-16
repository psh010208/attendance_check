class currentListModel {
  final String studentId;      // 학번
  final String name;           // 이름
  final String department;     // 학과
  final int attendanceCount;   // 출석 횟수
final String role;          //관리자/학부생

  final bool is_approved; //관리자 승인 bool
  currentListModel({
    required this.studentId,
    required this.name,
    required this.department,
    required this.attendanceCount,
    required this.role,
    required this.is_approved,


  });

  // Firestore에서 데이터를 가져와서 StudentAttendance 객체로 변환
  factory currentListModel.fromFirestore(Map<String, dynamic> data) {
    return currentListModel(
      studentId: data['student_id'] ?? '',
      name: data['student_name'] ?? '',
      department: data['department'] ?? '',
      attendanceCount: data['total_attendance'] ?? 0,
      role: data['role'] ?? '',
      is_approved: data['is_approved'] ?? '',
    );
  }

  // Firestore에 저장할 수 있는 Map으로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'student_id': studentId,
      'student_name': name,
      'department': department,
      'total_attendance': attendanceCount,
      'role': role,
      'is_approved': is_approved,

    };
  }
}
