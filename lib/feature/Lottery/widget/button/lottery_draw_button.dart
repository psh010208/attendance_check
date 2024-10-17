//추첨 버튼
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LotteryDrawButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const LotteryDrawButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).dividerColor, // 끝 색상
            Theme.of(context).colorScheme.inversePrimary, // 시작 색상
          ],
          begin: Alignment.topCenter, // 그라데이션 시작 위치
          end: Alignment.bottomCenter, // 그라데이션 끝 위치
          stops: [0.0001,0.9]
        ),
        borderRadius: BorderRadius.circular(10.r), // 모서리 둥글기
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? CircularProgressIndicator(color: Theme.of(context).colorScheme.surface)
            : Text('상품 추첨하기', style: TextStyle(fontSize: 19.sp)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
          minimumSize: Size(160.w, 50.h),
          elevation: 0, // 그림자를 제거
          shadowColor: Colors.transparent, // 그림자 색상도 제거
        ),
      ),
    );
  }
}
