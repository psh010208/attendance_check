import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
//하이
Widget animationButton({
  required IconData icon, // 아이콘 타입 추가
  required double iconSize, // 아이콘 크기 추가
  required Color iconColor, // 아이콘 색상 추가
  Offset defaultSize = const Offset(100, 105),
  Offset clickedSize = const Offset(100, 105),
  double defaultFontSize = 15,
  double clickedFontSize = 14,
  required Color defaultButtonColor,
  required Color clickedButtonColor,
  double circularRadius = 10,
  int buttonDuration = 300,
  int textDuration = 300,
  required void Function() onTap,
}) {
  var isClicked = useState(false);

  return GestureDetector(
    onTapDown: (_) => isClicked.value = true,
    onTapUp: (_) {
      isClicked.value = false;
      onTap(); // 버튼 클릭 시 기능 실행
    },
    child: AnimatedContainer(
      duration: Duration(milliseconds: buttonDuration),
      width: isClicked.value ? clickedSize.dx : defaultSize.dx,
      height: isClicked.value ? clickedSize.dy : defaultSize.dy,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(circularRadius),
        color: isClicked.value ? clickedButtonColor : defaultButtonColor,
      ),
      child: Center(
        child: Icon(
          icon, // 아이콘 사용
          size: iconSize, // 아이콘 크기 설정
          color: iconColor, // 아이콘 색상 설정
        ),
      ),
    ),
  );
}
