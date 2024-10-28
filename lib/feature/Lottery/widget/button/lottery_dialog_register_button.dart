//등록버튼
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LotteryDialogRegisterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LotteryDialogRegisterButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text('등록', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16.sp, fontWeight: FontWeight.normal)),
    );
  }
}