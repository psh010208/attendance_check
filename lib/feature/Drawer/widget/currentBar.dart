import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 출석 현황 바
class CurrentBar extends StatelessWidget {
  final int currentProgress;
  final int totalProgress;

  CurrentBar({
    required this.currentProgress,
    required this.totalProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 252.h,
      left: 30.w,
      child: Column(
        children: [
          Text(
            '        $currentProgress / $totalProgress',
            style: Theme.of(context).textTheme.titleSmall?.copyWith( // 굵게
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold,
              fontSize: 24.sp, // fontSize에 size 전달
            ),
          ),
          SizedBox(height: 20.h,),
          buildCustomProgressBar(currentProgress, totalProgress),
        ],
      ),
    );
  }
}

// 둥근 끝을 가진 커스텀 막대
Widget buildCustomProgressBar(int progress, int totalSteps) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(totalSteps, (index) {
      return Container(
        width: 25.sp,
        height: 15.sp,
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: index < progress ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(index == 0 ? 5 : 0),
            right: Radius.circular(index == totalSteps - 1 ? 5 : 0),
          ),
        ),
      );
    }),
  );
}
