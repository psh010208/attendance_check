class ParticipationStudent {
  final String dept;
  final String num;
  final String name;
  final String count;


  ParticipationStudent({
    required this.dept,
    required this.num,
    required this.name,
    required this.count,
  });
}

List<ParticipationStudent> p_students = [
  ParticipationStudent(
      dept: '소프트웨어공학과',
      num: '20225528',
      name: '민지희',
      count: '4'),
  ParticipationStudent(
      dept: '의료IT공학과',
      num: '20225524',
      name: '김형은',
      count: '9'),
  ParticipationStudent(
      dept: '소프트웨어공학과',
      num: '20225528',
      name: '민지희',
      count: '6'),
  ParticipationStudent(
      dept: '소프트웨어공학과',
      num: '20225528',
      name: '민지희',
      count: '5')
];