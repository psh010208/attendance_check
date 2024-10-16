import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentIcon extends StatelessWidget {
  final Function onPressed;

  const StudentIcon({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: IconButton(
        icon: Icon(Icons.qr_code_scanner, size: 40.w), // QR 코드 아이콘
        onPressed: () => onPressed(),
        color: Theme.of(context).iconTheme.color,
      ),
    );
  }
}
