// 삭제버튼
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(CupertinoIcons.delete),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(55.w, 40.h),
        elevation: 4,
      ),
    );
  }
}
