// drawer 모든 기능 통합 페이지

import 'package:attendance_check/feature/Drawer/widget/IdText.dart';
import 'package:attendance_check/feature/Drawer/widget/button.dart';
import 'package:attendance_check/feature/Drawer/widget/currentBar.dart';
import 'package:flutter/material.dart';

class drawerScreen extends StatelessWidget {
  // 사용자 정보 받기
  final String role;
  final String id;
  //final String current
  drawerScreen(
      {required this.role,
        required this.id,
      });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF0C3C73),
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.account_circle, size: 60), // 계정 아이콘
                  ),
                  SizedBox(height: 13),
                  CustomText(
                    id: role,  // 역할 표시
                  ),
                  SizedBox(height: 7),
                  CustomText(
                    id: id,  // 아이디 표시
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.grey,
            thickness: 2,
            height: 1,
          ),
          SizedBox(height: 10),
          // 역할에 따라 ListTile 표시
          if (role == '교수(관리자)') ...[
            ParticipationButton(  //참여 학생
              onPressed: () {},
            ),
            SizedBox(height: 10),
            RaffleButton(  //추첨
              onPressed: () {},
            ),
            SizedBox(height: 10),
          ]  // 관리자
          else if (role == '학부생') ...[
            CurrentButton(  // 현황
              onPressed: () {},
            ),
            SizedBox(height: 10),
            currentBar(  // 현황 바
              currentProgress: 5,
            ),
          ],  //학생
          SizedBox(height: 250),
          Center(
            child: LogOutButton(onPressed: () {  },)
          ),
        ],
      ),
    );
  }
}
