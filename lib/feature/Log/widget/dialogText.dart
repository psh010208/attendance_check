// dialogText.dart
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // 다이얼로그 모서리를 둥글게
      ),
      backgroundColor: Theme.of(context).primaryColorLight, // 배경색 설정
      title: Text(
        title,
        textAlign: TextAlign.center, // 제목 가운데 정렬
        style: TextStyle(
          color: Theme.of(context).colorScheme.scrim, // 제목 색상
          fontSize: 23, // 제목 크기
          fontWeight: FontWeight.bold, // 제목 폰트 굵기
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.scrim, // 메시지 색상
          fontSize: 16, // 메시지 텍스트 크기
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.1), // 버튼 배경색
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // 버튼 패딩
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // 버튼 모서리 둥글게
                  side: BorderSide(
                    color: Theme.of(context).primaryColorDark, // 테두리 색상
                  ),
                ),
              ),
              child: Text(
                '확인',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.scrim, // 텍스트 색상
                  fontSize: 17.5, // 버튼 텍스트 크기
                ),
                textAlign: TextAlign.center, // 텍스트 가운데 정렬
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
