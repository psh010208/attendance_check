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
      child: Text('상품 추첨하기', style: Theme.of(context).textTheme.titleSmall?.copyWith( // 굵게
        color:Theme.of(context).colorScheme.surfaceVariant,
        fontWeight: FontWeight.bold,
        fontSize: 18.sp, // fontSize에 size 전달
      ) ),
      style: ElevatedButton.styleFrom(
        backgroundColor:Theme.of(context).colorScheme.onSurface,
        minimumSize: Size(200.w, 40.h),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}


