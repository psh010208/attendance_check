import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimationButton extends HookWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Offset defaultSize;
  final Offset clickedSize;
  final Color defaultButtonColor;
  final Color clickedButtonColor;
  final double circularRadius;
  final int buttonDuration;
  final void Function() onTap;

  AnimationButton({
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    this.defaultSize = const Offset(80, 80),
    this.clickedSize = const Offset(70, 70),
    required this.defaultButtonColor,
    required this.clickedButtonColor,
    this.circularRadius = 50,
    this.buttonDuration = 300,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var isClicked = useState(false);

    return GestureDetector(
      onTapDown: (_) => isClicked.value = true,
      onTapUp: (_) {
        isClicked.value = false;
        onTap(); // 버튼 클릭 시 기능 실행
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: buttonDuration),
        width: isClicked.value ? clickedSize.dx : defaultSize.dx, // 크기 변화
        height: isClicked.value ? clickedSize.dy : defaultSize.dy, // 크기 변화
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
}
