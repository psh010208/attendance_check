class Waitinglist {
  final String num;
  final String name;
  bool approved; // 승인 여부를 bool로 선언, final 제거

  Waitinglist({
    required this.num,
    required this.name,
    required this.approved,
  });
}

List<Waitinglist> waitinglist = [
  Waitinglist(
    num: '20225528',
    name: '민지희',
    approved: false, // 초기값 설정
  ),
  Waitinglist(
    num: '20225524',
    name: '김형은',
    approved: false, // 초기값 설정
  ),
];
