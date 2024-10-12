// 학생 참여 현황 바

import 'package:flutter/material.dart';

// currentProgress도 MyPage로 넣을 거임
class currentBar extends StatelessWidget{
  // 출석 현황 바 색깔 조정
  final int currentProgress;

  currentBar({
    required this.currentProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [        // 커스텀 막대
        buildCustomProgressBar(currentProgress),
      ],
    );
  }
}
// 둥근 끝을 가진 커스텀 막대
Widget buildCustomProgressBar(int progress) {
  int totalSteps = 9;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(totalSteps, (index) {
      return Container(
        width: 25,
        height: 10,
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: index < progress ? Colors.white : Colors.black,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(index == 0 ? 5 : 0),
            right: Radius.circular(index == totalSteps - 1 ? 5 : 0),
          ),
        ),
      );
    }),
  );
}