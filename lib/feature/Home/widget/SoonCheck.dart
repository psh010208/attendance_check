import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoonCheckWidget extends StatelessWidget {
  final double bottom;
  final double left;

  const SoonCheckWidget({super.key, required this.bottom, required this.left,});

  @override
  Widget build(BuildContext context) {
    return Stack(

      children: [
        // 첫 번째 텍스트 (외곽선)
        Positioned(

          bottom: bottom.h, // 반응형 위치 설정
          left: left+85.w, // 반응형 위치 설정
          child: Text(
            'Soon CHeck',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 50.sp, // 반응형 폰트 크기 설정
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6.w // 반응형 외곽선 두께
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
          bottom: bottom.h, // 반응형 위치 설정
          left:left+ 85.w, // 반응형 위치 설정
          child: Text(
            'Soon CHeck',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 50.sp, // 반응형 폰트 크기 설정
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),

        // 가운데 일부 텍스트
        Positioned(
          bottom: bottom.h, // 반응형 위치 설정
          left: left+87.8.w, // 반응형 위치 설정
          child: Text(
            '  oon',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 50.sp, // 반응형 폰트 크기 설정
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),

        // 오른쪽 일부 텍스트
        Positioned(
          bottom: bottom.h, // 반응형 위치 설정
          left:left+ 59.2.w, // 반응형 위치 설정
          child: Text(
            '                eck',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 50.sp, // 반응형 폰트 크기 설정
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
