//재추첨 버튼
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LotteryDialogRedrawButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LotteryDialogRedrawButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text('재추첨', style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.normal)),
    );
  }
}
