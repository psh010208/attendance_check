// 학생 참여 현황 바

import 'package:attendance_check/feature/Drawer/widget/IdText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// currentProgress도 MyPage로 넣을 거임
// 출석 현황 바 색깔 조정
class CurrentBar extends StatelessWidget {
  final int currentProgress;

  CurrentBar({
    required this.currentProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 255.h, // y축 위치 조정
      left: 30.w, // x축 위치 조정
      child: Column(
        children: [
          CustomText(
              id: '      :    $currentProgress / 9',
            size: 23,
          ),
          SizedBox(height: 20,),// children 속성에 리스트 형태로 전달
          buildCustomProgressBar(currentProgress),
        ],
      ),
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
        height: 15,
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