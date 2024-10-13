//재추첨 버튼
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogRepickButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DialogRepickButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('다시 추첨하기', style: TextStyle(fontSize: 16.sp)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff2C2C2C),
        foregroundColor: Colors.white,
        minimumSize: Size(55.w, 40.h),
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
