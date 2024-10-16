import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Home/widget/Text/SoonCheckText.dart'; // 새로 만든 위젯 import

class SoonCheckWidget extends StatelessWidget {
  final double bottom;
  final double left;

  const SoonCheckWidget({super.key, required this.bottom, required this.left});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 첫 번째 텍스트 (외곽선)
        SoonCheckTextWidget(
          text: 'Soon CHeck',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 50.sp,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6.w
              ..color = Theme.of(context).shadowColor,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 10),
                blurRadius: 10,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ],
          ),
          // 각 텍스트의 위치를 조정하기 위해 bottom과 left 값을 전달
          bottom: bottom,  // bottom 값 전달
          left: left + 40, // 왼쪽 오프셋 조정
        ),

        // 두 번째 텍스트 (채우기 색상)
        SoonCheckTextWidget(
          text: 'Soon CHeck',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 50.sp,
            color: Theme.of(context).primaryColor,
          ),
          bottom: bottom,  // bottom 값 전달
          left: left + 40, // 왼쪽 오프셋 조정
        ),

        // 가운데 일부 텍스트
        SoonCheckTextWidget(
          text: '  oon',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 50.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          bottom: bottom,  // bottom 값 전달
          left: left + 43, // 왼쪽 오프셋 조정
        ),

        // 오른쪽 일부 텍스트
        SoonCheckTextWidget(
          text: '                eck',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 50.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          bottom: bottom,  // bottom 값 전달
          left: left + 14, // 왼쪽 오프셋 조정
        ),
      ],
    );
  }
}
