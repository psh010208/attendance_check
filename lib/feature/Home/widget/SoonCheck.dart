import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/widget/Text/SoonCheckText.dart'; // 새로 만든 위젯 import

class SoonCheckWidget extends StatelessWidget {
  final double bottom;
  final double left;

  // bottom과 left를 받아서 위치 조정을 가능하게 하는 생성자
  const SoonCheckWidget({super.key, required this.bottom, required this.left});

  @override
  Widget build(BuildContext context) {
    // 화면 너비와 높이 가져오기
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // 공통 폰트 사이즈 전역 변수로 선언
    final double fontSize = screenWidth * 0.13 * textScaleFactor;

    return Stack(
      children: [
        // 첫 번째 텍스트 (외곽선)
        SoonCheckTextWidget(
          text: 'Soon CHeck',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: fontSize, // 전역 변수 fontSize 사용
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = screenWidth * 0.01 // 화면 너비에 비례한 외곽선 두께
              ..colorFilter = ColorFilter.mode(
                Theme.of(context).shadowColor, // 그림자 색상
                BlendMode.srcIn, // 색상 적용 방식
              ),
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, screenHeight * 0.01), // 화면 높이에 맞춘 그림자 위치
                blurRadius: screenHeight * 0.02, // 화면 높이에 맞춘 블러 반경
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ],
          ),
          bottom: bottom, // 인자로 전달받은 bottom 위치 사용
          left: left,     // 인자로 전달받은 left 위치 사용
        ),

        // 두 번째 텍스트 (채우기 색상)
        SoonCheckTextWidget(
          text: 'Soon CHeck',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: fontSize,
            color: Theme.of(context).primaryColor,
          ),
          bottom: bottom, // 인자로 전달받은 bottom 위치 사용
          left: left,     // 인자로 전달받은 left 위치 사용
        ),

        // 가운데 일부 텍스트 "oon"
        SoonCheckTextWidget(
          text: 'oon',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          bottom: bottom, // 인자로 전달받은 bottom 위치 사용
          left: left + screenWidth * 0.0673, // 조정된 left 위치
        ),

        // 오른쪽 일부 텍스트 "eck"
        SoonCheckTextWidget(
          text: 'eck',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          bottom: bottom, // 인자로 전달받은 bottom 위치 사용
          left: left + screenWidth * 0.415, // 조정된 left 위치
        ),
      ],
    );
  }
}
