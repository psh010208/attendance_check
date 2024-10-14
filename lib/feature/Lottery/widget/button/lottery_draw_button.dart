//추첨 버튼
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LotteryDrawButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LotteryDrawButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? CircularProgressIndicator(color: Theme.of(context).colorScheme.surface)
          : Text('상품 추첨하기', style: TextStyle(fontSize: 16.sp)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onSurface,
        foregroundColor: Theme.of(context).colorScheme.surface,
        minimumSize: Size(200.w, 40.h),
        elevation: 4,
        shadowColor: Theme.of(context).colorScheme.onSurface.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
