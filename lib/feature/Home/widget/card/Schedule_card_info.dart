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
    return Padding(
      padding: EdgeInsets.only(left: 10.w, top: 15.w),
      child: Stack(
        children: [
          // 카드 로고
          Positioned(
            top: 60.h,
            left: 70.w,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/cardLogo.png', // 로고 이미지 경로
                fit: BoxFit.cover,
                width: 160.w,  // 로고 크기 조정
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 상단 수업 이름 부분
              Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 수평적으로 가운데 정렬
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.w), // 왼쪽 패딩 설정
                    child: CustomText(
                      id: schedule.scheduleName.isNotEmpty
                          ? schedule.scheduleName
                          : "이름 없음",
                      size: 18.sp,
                      overflow: TextOverflow.ellipsis, // 텍스트가 길면 "..."으로 표시
                      maxLines: 1, // 한 줄까지만 표시
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 18.w), // 오른쪽과 시간 사이 공간
                    child: CustomText(
                      // 시작시간 ~ 끝나는시간을 포맷한 값을 사용
                      id: schedule.startTime.isNotEmpty
                          ? _formatTime(schedule.startTime, schedule.endTime) // 포맷된 시간 출력
                          : "시간 없음",
                      size: 13.sp,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w), // 왼쪽에 패딩을 주어 오른쪽으로 이동
                child: Divider(
                  height: 25.h,
                  color: Colors.grey, // 색상 설정 (사이드바와 동일한 색상)
                  thickness: 1.5.w, // 두께 설정
                ),
              ),

              // 장소 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70.h),
                  Icon(Icons.location_on, color: Theme.of(context).colorScheme.onSurface),
                  SizedBox(width: 5.w),
                  CustomText(
                    id: schedule.location.isNotEmpty ? schedule.location : "위치 없음",
                    size: 29.sp,
                  ),
                  SizedBox(width: 9.w),
                  CustomText(
                    id: '강의실',
                    size: 16.sp,
                  ),
                ],
              ),

              // 교수 정보
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
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }


}