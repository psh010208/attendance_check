class LotteryStudent {
  final String dept;
  final int num;
  final String name;
  final int count;

  LotteryStudent({
    required this.dept,
    required this.num,
    required this.name,
    required this.count,
  });
}

List<LotteryStudent> l_students = [
  LotteryStudent(
      dept: '소프트웨어공학과',
      num: 20225528,
      name: '민지희',
      count: 4),
  LotteryStudent(
      dept: '의료IT공학과',
      num: 20225524,
      name: '김형은',
      count: 9)
];
