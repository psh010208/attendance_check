import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminIcon extends StatelessWidget {
  final Function onPressed;

  const AdminIcon({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add, size: 30.w), // 일정 추가 아이콘
      onPressed: () => onPressed(),
      color: Theme.of(context).iconTheme.color,
    );
  }
}
