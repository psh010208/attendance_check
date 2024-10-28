import 'package:attendance_check/feature/ApproveList/ApproveListScreen.dart';
import 'package:attendance_check/feature/Home/widget/QRService/QrCodeListScreen.dart';
import 'package:attendance_check/feature/Log/widget/SignUpForm.dart';
import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Log/logPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Drawer/widget/IdText.dart';
import 'package:attendance_check/feature/Lottery/lottery_view.dart';
import 'package:attendance_check/feature/CurrentList/StudentListScreen.dart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:attendance_check/feature/FriendsList/FriendsScreen.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).dialogBackgroundColor,
              size: iconSize.w,
            ),
            SizedBox(width: 10.w),
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
      iconSize: 25.w,
      textSize: 23.sp,
      top: 230.h,
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
      iconSize: 25.w,
      textSize: 23.sp,
      top: 300.h,
      left: 10.w,
    );
  }
}

// 관리자에게 문의하기 버튼
class AskButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String role;
  final String id;

  AskButton({required this.onPressed, required this.role, required this.id});

  final _url = Uri.parse('https://open.kakao.com/o/skfVRPWg');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: _launchUrl,
      icon: Icons.chat,
      text: '문의하기',
      iconSize: 23.w,
      textSize: 17.sp,
      top: 680.h,
      left: 77.w,
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
            builder: (context) => ApproveListScreen(role:
            role,  // role 값 전달
              id:id,    // id 값 전달
            ),
          ),
        );
      },
      icon: Icons.hourglass_bottom,
      text: '승인 대기 현황',
      iconSize: 33.w,
      textSize: 23.sp,
      top: 230.h,
      left: 10.w,
    );
  }
}

// 참여 학생 현황 버튼
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
            builder: (context) => StudentListScreen(
              role: role, // widget.role 사용
              id: id,
            ),
          ),
        );
      },
      icon: Icons.table_view, // 출석 현황에 적합한 아이콘 추가
      text: '참여 학생 현황',
      iconSize: 33.w,
      textSize: 23.sp,
      top: 310.h,
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
      iconSize: 33.w,
      textSize: 23.sp,
      top: 390.h,
      left: 10.w,
    );
  }
}

// QR 코드 현황 버튼
class QrScreenButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String role;
  final String id;

  QrScreenButton({required this.onPressed, required this.role, required this.id});


  @override
  Widget build(BuildContext context) {
    return CommonButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QrCodeListScreen(
              role: role, // widget.role 사용
              id: id, // widget.id 사용
            ),
          ),
        );
      },
      icon: Icons.qr_code_2,
      text: 'QR코드 확인',
      iconSize: 33.w,
      textSize: 23.sp,
      top: 470.h,
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
      iconSize: 23.w,
      textSize: 17.sp,
      top: 680.h,
      left: 77.w,
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
      left: 70.w,
      child: GestureDetector(
        onTap: onPressed,
        child: Image.asset(
          'assets/simple_logo.png',
          width: 150.w,
          height: 30.h,
        ),
      ),
    );
  }
}

// 친구 목록 보기 버튼
class FriendsListButton extends StatelessWidget {
  final VoidCallback onPressed;

  FriendsListButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CommonButton( // 또는 다른 버튼 위젯을 사용하세요
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FriendsScreen()),
        );
      },
      icon: Icons.group,
      text: '친구 목록',
      iconSize: 25.h,
      textSize: 23.w,
      top: 200,
      left: 200,  // 버튼의 텍스트
    );
  }
}
