//매니저 버튼 2개 (참여 학생 현황, 상품 추천)
//로그아웃 버튼

import 'package:flutter/material.dart';
import '../../Log/SignInPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// 참여 학생 현황 버튼
class ParticipationButton extends StatelessWidget {
  final VoidCallback onPressed;

  ParticipationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 230.h, // y축 위치 조정
      left: 10.w, // x축 위치 조정
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // 버튼 배경색을 투명하게 설정
          shadowColor: Colors.transparent, // 그림자 색상 투명하게
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Row( // 아이콘과 텍스트를 나란히 배치
          mainAxisSize: MainAxisSize.min, // 버튼 크기를 최소화
          children: [
            Icon(
              Icons.task_alt, // 아이콘
              color: Colors.white, // 아이콘 색상
              size: 33,
            ),
            SizedBox(width: 8), // 아이콘과 텍스트 간의 간격
            Text(
              '참여 학생 현황',
              style: TextStyle(fontSize: 20), // 텍스트 크기 조정
            ),
          ],
        ),
      ),
    );
  }
}

// 상품 추첨 버튼
class RaffleButton extends StatelessWidget {
  final VoidCallback onPressed;

  RaffleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 300.h, // y축 위치 조정
      left: 10.w, // x축 위치 조정
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // 버튼 배경색을 투명하게 설정
          shadowColor: Colors.transparent, // 그림자 색상 투명하게
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Row( // 아이콘과 텍스트를 나란히 배치
          mainAxisSize: MainAxisSize.min, // 버튼 크기를 최소화
          children: [
            Icon(
              Icons.redeem, // 아이콘
              color: Colors.white, // 아이콘 색상
              size: 33,
            ),
            SizedBox(width: 8), // 아이콘과 텍스트 간의 간격
            Text(
              '상품 추첨',
              style: TextStyle(fontSize: 20), // 텍스트 크기 조정
            ),
          ],
        ),
      ),
    );
  }
}

// 출석 현황
class CurrentButton extends StatelessWidget {
  final VoidCallback onPressed;

  CurrentButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 230.h, // y축 위치 조정
      left: 10.w, // x축 위치 조정
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // 버튼 배경색을 투명하게 설정
          shadowColor: Colors.transparent, // 그림자 색상 투명하게
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Row( // 아이콘과 텍스트를 나란히 배치
          mainAxisSize: MainAxisSize.min, // 버튼 크기를 최소화
          children: [
            SizedBox(width: 8), // 아이콘과 텍스트 간의 간격
            Text(
              '출석 현황',
              style: TextStyle(fontSize: 20), // 텍스트 크기 조정
            ),
          ],
        ),
      ),
    );
  }
}

// 로그아웃
class LogOutButton extends StatelessWidget {
  final VoidCallback onPressed;

  LogOutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 650.h, // y축 위치 조정
      left: 110.w, // x축 위치 조정
      child: Column(
        mainAxisSize: MainAxisSize.min, // 버튼 크기를 최소화
        children: [
          // ElevatedButton
          ElevatedButton(
            onPressed: () {
              // 로그아웃 로직을 여기에 추가하세요.
              // 로그아웃 후 SignInPage로 이동
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // 버튼 배경색을 투명하게 설정
              shadowColor: Colors.transparent, // 그림자 색상 투명하게
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Row( // 아이콘과 텍스트를 나란히 배치
              mainAxisSize: MainAxisSize.min, // 버튼 크기를 최소화
              children: [
                Icon(
                  Icons.logout, // 로그아웃 아이콘
                  color: Colors.white, // 아이콘 색상
                  size: 33,
                ),
                SizedBox(width: 8), // 아이콘과 텍스트 간의 간격
                Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 20), // 텍스트 크기 조정
                ),
              ],
            ),
          ),
          SizedBox(height: 25), // 버튼과 이미지 간의 간격
          Image.asset(
            'assets/simple_logo.png',
            width: 150,
            height: 30,
          ), // 로고 이미지 추가
        ],
      ),
    );
  }
}
