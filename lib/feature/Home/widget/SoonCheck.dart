import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Home/widget/Text/SoonCheckText.dart'; // 새로 만든 텍스트 위젯

class SoonCheckWidget extends StatelessWidget {
  final double bottom;
  final double left;

  const SoonCheckWidget({super.key, required this.bottom, required this.left});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 첫 번째 텍스트 (외곽선)
        SoonCheckText(
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
          leftOffset: left + 40,
        ),

        // 두 번째 텍스트 (채우기 색상)
        SoonCheckText(
          text: 'Soon CHeck',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 50.sp,
            color: Theme.of(context).primaryColor,
          ),
          leftOffset: left + 40,
        ),

        // 가운데 일부 텍스트
        SoonCheckText(
          text: '  oon',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 50.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          leftOffset: left + 43,
        ),

        // 오른쪽 일부 텍스트
        SoonCheckText(
          text: '                eck',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 50.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          leftOffset: left + 14,
        ),
      ],
    );
  }
}
