// 삭제버튼
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LotteryDeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LotteryDeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(CupertinoIcons.delete),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        iconColor:Theme.of(context).colorScheme.onInverseSurface,
        minimumSize: Size(55.w, 40.h),
        elevation: 4,
        shadowColor: Theme.of(context).colorScheme.onSurface.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
