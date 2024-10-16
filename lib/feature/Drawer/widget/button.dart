import 'package:attendance_check/feature/Home/widget/QRService/QrCodeListScreen.dart';
import 'package:attendance_check/feature/Log/widget/SignUpForm.dart';
import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Log/logPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Drawer/widget/IdText.dart';
import 'package:attendance_check/feature/Lottery/lottery_view.dart';
import 'package:attendance_check/feature/CurrentList/ParticipationStatus.dart';
import '../../CurrentList/ApproveWaitingList.dart';

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
              color: Theme.of(context).dialogBackgroundColor,
              size: iconSize,
            ),
            SizedBox(width: 10),
            CustomText(
              id: text,
              size: textSize.sp,
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
      iconSize: 25.sp,
      textSize: 23.sp,
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
          MaterialPageRoute(builder: (context) => SignUpForm()), // 회원가입 페이지로 이동
        );
      },
      icon: Icons.account_circle,
      text: '회원가입',
      iconSize: 25.sp,
      textSize: 23.sp,
      top: 320.h,
      left: 10.w,
    );
  }
}

// 승인 대기 현황 버튼
class ParticipationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String role;
  final String id;

  ParticipationButton({required this.onPressed, required this.role, required this.id});

  @override
  Widget build(BuildContext context) {

    return CommonButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ApproveWaitingList(
              role,  // role 값 전달
              id,    // id 값 전달
            ),
          ),
        );
      },
      icon: Icons.hourglass_bottom,
      text: '승인 대기 현황',
      iconSize: 33.sp,
      textSize: 23.sp,
      top: 250.h,
      left: 10.w,
    );
  }
}

// 출석 현황 버튼
class CurrentButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String role;
  final String id;

  CurrentButton({required this.onPressed, required this.role, required this.id});

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ParticipationStatus(
                role: role, // widget.role 사용
                id: id,
              ),
          ),
        );
      },
      icon: Icons.table_view, // 출석 현황에 적합한 아이콘 추가
      text: '참여 학생 현황',
      iconSize: 33.sp,
      textSize: 23.sp,
      top: 330.h,
      left: 10.w,
    );
  }
}

// 상품 추첨 버튼
class RaffleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String role;
  final String id;

  RaffleButton({required this.onPressed, required this.role, required this.id});

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LotteryView(
              role: role, // widget.role 사용
              id: id, // widget.id 사용
            ),
          ),
        );
      },
      icon: Icons.redeem,
      text: '상품 추첨',
      iconSize: 33.sp,
      textSize: 23.sp,
      top: 410.h,
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
      iconSize: 23.sp,
      textSize: 17.sp,
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
          width: 150.sp,
          height: 30.sp,
        ),
      ),
    );
  }
}


// 상품 추첨 버튼
class QrScreenButton extends StatelessWidget {
  final VoidCallback onPressed;

  QrScreenButton({required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QrCodeListScreen(
             
            ),
          ),
        );
      },
      icon: Icons.qr_code_2,
      text: 'QR코드 확인',
      iconSize: 33.sp,
      textSize: 23.sp,
      top: 490.h,
      left: 10.w,
    );
  }
}

