//매니저 : 버튼 2개 (참여 학생 현황, 상품 추천)
// 학생 : 로그아웃 버튼, 로고
// null : 로그인, 회원가입

import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Log/logPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Drawer/widget/IdText.dart';

// 로그인
class LogInButton extends StatelessWidget {
  final VoidCallback onPressed;

  LogInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 250.h, // y축 위치 조정
      left: 10.w, // x축 위치 조정
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
                  MaterialPageRoute(builder: (context) => logPage(isLogin: true),)
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
                  Icons.login, // 로그아웃 아이콘
                  color: Colors.white, // 아이콘 색상
                  size: 25,
                ),
                SizedBox(width: 10), // 아이콘과 텍스트 간의 간격
                CustomText(
                  id: '로그인',
                  size: 25, // 텍스트 크기 조정
                ),
              ],
            ),
          ), // 로고 이미지 추가
        ],
      ),
    );
  }
}
// 회원가입
class JoinButton extends StatelessWidget {
  final VoidCallback onPressed;

  JoinButton({required this.onPressed});

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
              Icons.account_circle, // 로그아웃 아이콘
              color: Colors.white, // 아이콘 색상
              size: 25,
            ),
            SizedBox(width: 10), // 아이콘과 텍스트 간의 간격
            CustomText(
              id : '회원가입',
              size: 25, // 텍스트 크기 조정
            ),
          ],
        ),
      ),
    );
  }
}
// 참여 학생 현황 버튼
class ParticipationButton extends StatelessWidget {
  final VoidCallback onPressed;

  ParticipationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 250.h, // y축 위치 조정
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
            SizedBox(width: 10), // 아이콘과 텍스트 간의 간격
            CustomText(
              id : '참여 학생 현황',
              size: 23, // 텍스트 크기 조정
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
      top: 320.h, // y축 위치 조정
      left: 10.w,// x축 위치 조정
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
            SizedBox(width: 10), // 아이콘과 텍스트 간의 간격
            CustomText(
              id :'상품 추첨',
              size: 21, // 텍스트 크기 조정
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
      top: 240.h, // y축 위치 조정
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
            SizedBox(width: 10), // 아이콘과 텍스트 간의 간격
            CustomText(
              id : '출석 현황',
              size: 20, // 텍스트 크기 조정
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
      top: 680.h, // y축 위치 조정
      left: 75.w, // x축 위치 조정
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
                MaterialPageRoute(builder: (context) => logPage(isLogin: true),)
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
                  size: 23,
                ),
                SizedBox(width: 10), // 아이콘과 텍스트 간의 간격
                CustomText(
                  id: '로그아웃',
                  size: 17, // 텍스트 크기 조정
                ),
              ],
            ),
          ), // 로고 이미지 추가
        ],
      ),
    );
  }
}

// 로고
class Logo extends StatelessWidget {
  final VoidCallback onPressed;

  Logo({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 750.h, // y축 위치 조정
      left: 75.w, // x축 위치 조정
      child: Column( // Column의 children 속성으로 Image.asset 추가
        children: [
          GestureDetector( // onPressed 기능을 추가하려면 GestureDetector 사용
            onTap: onPressed,
            child: Image.asset(
              'assets/simple_logo.png',
              width: 150,
              height: 30,
            ), // 로고 이미지 추가
          ),
        ],
      ),
    );
  }
}
