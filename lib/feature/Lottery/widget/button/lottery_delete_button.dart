// 삭제버튼
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LotteryDeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LotteryDeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.primary),
      onPressed: onPressed,
      iconSize: 30.w, // 아이콘 크기
      constraints: BoxConstraints(
        minWidth: 40.w,
        minHeight: 40.h,
      ),
    );
  }
}
