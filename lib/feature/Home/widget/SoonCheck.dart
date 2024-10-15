import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoonCheckWidget extends StatelessWidget {
  final double bottom;
  final double left;

  const SoonCheckWidget({super.key, required this.bottom, required this.left});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 첫 번째 텍스트 (외곽선)
        Positioned(
          bottom: bottom.h,
          left: left + 40.w, // 위치 조정
          child: Text(
            'Soon CHeck',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
          ),
        ),

        // 두 번째 텍스트 (채우기 색상)
        Positioned(
          bottom: bottom.h,
          left: left + 40.w, // 위치 조정
          child: Text(
            'Soon CHeck',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 50.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

        // 가운데 일부 텍스트
        Positioned(
          bottom: bottom.h,
          left: left + 43.w, // 위치 조정
          child: Text(
            '  oon',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 50.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),

        // 오른쪽 일부 텍스트
        Positioned(
          bottom: bottom.h,
          left: left + 14.w, // 위치 조정
          child: Text(
            '                eck',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 50.sp,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
