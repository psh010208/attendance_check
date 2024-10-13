import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Log/logPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Drawer/widget/IdText.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  final double iconSize;
  final double textSize;
  final double top;
  final double left;

  CommonButton({
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.iconSize,
    required this.textSize,
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // 버튼 배경색을 투명하게 설정
          shadowColor: Colors.transparent, // 그림자 색상 투명하게
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: iconSize,
            ),
            SizedBox(width: 10),
            CustomText(
              id: text,
              size: textSize,
            ),
          ],
        ),
      ),
    );
  }
}

// 로그인 버튼
class LogInButton extends StatelessWidget {
  final VoidCallback onPressed;

  LogInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => logPage(isLogin: true)),
        );
      },
      icon: Icons.login,
      text: '로그인',
      iconSize: 25,
      textSize: 25,
      top: 250.h,
      left: 10.w,
    );
  }
}

// 회원가입 버튼
class JoinButton extends StatelessWidget {
  final VoidCallback onPressed;

  JoinButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => logPage(isLogin: false)), // 회원가입 페이지로 이동
        );
      },
      icon: Icons.account_circle,
      text: '회원가입',
      iconSize: 25,
      textSize: 25,
      top: 300.h,
      left: 10.w,
    );
  }
}

// 참여 학생 현황 버튼
class ParticipationButton extends StatelessWidget {
  final VoidCallback onPressed;

  ParticipationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        // 참여 학생 현황 페이지로 이동하는 로직 추가
      },
      icon: Icons.task_alt,
      text: '참여 학생 현황',
      iconSize: 33,
      textSize: 23,
      top: 250.h,
      left: 10.w,
    );
  }
}

// 상품 추첨 버튼
class RaffleButton extends StatelessWidget {
  final VoidCallback onPressed;

  RaffleButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        // 상품 추첨 페이지로 이동하는 로직 추가
      },
      icon: Icons.redeem,
      text: '상품 추첨',
      iconSize: 33,
      textSize: 21,
      top: 320.h,
      left: 10.w,
    );
  }
}

// 출석 현황 버튼
class CurrentButton extends StatelessWidget {
  final VoidCallback onPressed;

  CurrentButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        // 출석 현황 페이지로 이동하는 로직 추가
      },
      icon: Icons.check_circle, // 출석 현황에 적합한 아이콘 추가
      text: '출석 현황',
      iconSize: 20,
      textSize: 20,
      top: 240.h,
      left: 10.w,
    );
  }
}

// 로그아웃 버튼
class LogOutButton extends StatelessWidget {
  final VoidCallback onPressed;

  LogOutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => logPage(isLogin: true)),
        );
      },
      icon: Icons.logout,
      text: '로그아웃',
      iconSize: 23,
      textSize: 17,
      top: 680.h,
      left: 75.w,
    );
  }
}

// 로고 버튼
class Logo extends StatelessWidget {
  final VoidCallback onPressed;

  Logo({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 750.h,
      left: 75.w,
      child: GestureDetector(
        onTap: onPressed,
        child: Image.asset(
          'assets/simple_logo.png',
          width: 150,
          height: 30,
        ),
      ),
    );
  }
}
