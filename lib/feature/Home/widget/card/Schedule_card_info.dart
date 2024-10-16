import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart'; // 추가: DateFormat 사용을 위해 intl 패키지 임포트
import '../../model/homeModel.dart';
import 'package:attendance_check/feature/Home/widget/Text/IdText.dart';

class ScheduleCardInfo extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCardInfo({Key? key, required this.schedule}) : super(key: key);

  // 시간을 포맷하는 함수 (시작 시간과 끝나는 시간 모두 포맷)
  String _formatTime(String startTime, DateTime endTime) {
    // 시작 시간 포맷
    DateTime parsedStartTime = DateTime.parse(startTime);
    String formattedStartTime = DateFormat('hh:mm a').format(parsedStartTime);

    // 끝나는 시간 포맷
    String formattedEndTime = DateFormat('hh:mm a').format(endTime);

    // 시작시간 ~ 끝나는시간 형식으로 반환
    return "$formattedStartTime ~ $formattedEndTime";
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      //color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 상단 수업 이름 부분
          Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 30.w), // 왼쪽에 50픽셀만큼 공간 추가
                  child: CustomText(
                    id: schedule.scheduleName.isNotEmpty
                        ? schedule.scheduleName
                        : "이름 없음",
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 20.w),
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: CustomText(
                    // 시작시간 ~ 끝나는시간을 포맷한 값을 사용
                    id: schedule.startTime.isNotEmpty
                        ? _formatTime(schedule.startTime, schedule.endTime) // 포맷된 시간 출력
                        : "시간 없음",
                    size: 16.sp,
                  ),
                ),
              ],
            ),
          ),

          // 구분선 (카드 끝까지)
          Container(
            height: 2.h, // 직접 높이 설정
            margin: EdgeInsets.symmetric(vertical: 0.0), // 위아래 여백 조정
            child: Divider(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2), // 색상 설정
              thickness: 2.w, // 두께 설정
            ),
          ),


          // 메인 정보 영역
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
              child: Stack(
                children: [
                  // 카드 로고
                  Positioned(
                    top: 0.h,
                    bottom: 5.h,
                    left: 70.w,
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset(
                        'assets/cardLogo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // 위치 및 교수 정보
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: Theme.of(context).colorScheme.onSurface),
                          SizedBox(width: 8.w),
                          CustomText(
                            id: schedule.location.isNotEmpty
                                ? schedule.location
                                : "위치 없음",
                            size: 29.sp,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            id: '강의실',
                            size: 16.sp,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface),
                          SizedBox(width: 8.w),
                          CustomText(
                            id: schedule.instructorName.isNotEmpty
                                ? schedule.instructorName
                                : "교수 없음",
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          CustomText(
                            id: '교수님',
                            size: 15.sp,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
