//추첨 버튼
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const PickButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text('상품 추첨하기', style: TextStyle(fontSize: 16.sp)),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(55.w, 40.h),
        elevation: 6,
      ),
    );
  }
}
