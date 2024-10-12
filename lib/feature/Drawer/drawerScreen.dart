// drawer 모든 기능 통합 페이지

import 'package:attendance_check/feature/Drawer/widget/IdText.dart';
import 'package:attendance_check/feature/Drawer/widget/button.dart';
import 'package:attendance_check/feature/Drawer/widget/currentBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
      backgroundColor: Theme.of(context).primaryColorDark,
      child: Stack(
        children: <Widget>[
           DrawerHeader(
              child: Center(
                child: Stack(
                  children: [
                      Positioned(
                        top: 0.h, // 반응형 높이 설정
                        left: 105.w,
                        child: CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.account_circle, size: 70),
                        ),
                      ),
                    if(role != '교수(관리자)' && role!='학부생')
                      Positioned(
                        top: 95.h, // 반응형 높이 설정
                        left: 88.w,
                        child: CustomText(
                          id: '정보없음'
                              , size: 30,  // 역할 표시
                        ),
                      ),
                    if(role == '교수(관리자)')
                      Positioned(
                        top: 75.h, // 반응형 높이 설정
                        left: 65.w,
                        child: CustomText(
                          id: role, size: 30,  // 역할 표시
                        ),
                      )else if(role=='학부생')
                      Positioned(
                        top: 75.h, // 반응형 높이 설정
                        left: 100.w,
                        child: CustomText(
                          id: role, size: 30,  // 역할 표시
                        ),
                      ),
                    if(role == '교수(관리자)' || role=='학부생')
                      Positioned(
                        top: 123.h, // 반응형 높이 설정
                        left: 113.w,
                        child: CustomText(
                          id: id,size: 20,   // 아이디 표시
                        ),
                      ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          // Divider와 버튼들을 Stack의 두 번째 자식으로 추가
          Positioned(
            top: 220.h, // 첫 번째 버튼의 위치를 조정
            left: 0,
            right: 0,
            child: Divider(
              color: Colors.grey,
              thickness: 3,
            ),
          ),
          if (role == '교수(관리자)') ...[
            ParticipationButton(  //참여 학생
              onPressed: () {},
            ),
            SizedBox(height: 10),
            RaffleButton(  //추첨
              onPressed: () {},
            ),
            SizedBox(height: 10),
          ]else if (role == '학부생') ...[
            CurrentButton(  // 현황
              onPressed: () {},
            ),
            CurrentBar(currentProgress: 5),
          ]else ...[
            LogInButton(onPressed: (){}),
            JoinButton(onPressed: (){}),
          ],
          if(role == '교수(관리자)' || role=='학부생')
            LogOutButton(onPressed: (){}),
          Logo(onPressed: (){}),
        ],
      ),
    );
  }
}
