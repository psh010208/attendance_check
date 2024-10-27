import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../model/homeModel.dart';
import 'package:attendance_check/feature/Home/widget/Text/IdText.dart';

class ScheduleCardInfo extends StatelessWidget {
  final Schedule schedule;
  final double cardWidth;  // 카드 너비
  final double cardHeight; // 카드 높이

  const ScheduleCardInfo({
    Key? key,
    required this.schedule,
    required this.cardWidth,
    required this.cardHeight,
  }) : super(key: key);

  // 시간을 포맷하는 함수
  String _formatTime(String startTime, DateTime endTime) {
    DateTime parsedStartTime = DateTime.parse(startTime);
    String formattedStartTime = DateFormat('hh:mm a').format(parsedStartTime);
    String formattedEndTime = DateFormat('hh:mm a').format(endTime);
    return "$formattedStartTime ~ $formattedEndTime";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: cardWidth * 0.03, top: cardHeight * 0.05),
      child: Stack(
        children: [
          Positioned(
            top: cardHeight * 0.28,
            left: cardWidth * 0.27,
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/cardLogo.png',
                fit: BoxFit.cover,
                width: cardWidth * 0.50,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // 상단 수업 이름 부분
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: cardWidth * 0.02),
                    child: CustomText(
                      id: schedule.scheduleName.isNotEmpty
                          ? schedule.scheduleName
                          : "이름 없음",
                      size: cardHeight * 0.08,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: cardWidth * 0.05),
                    child: CustomText(
                      id: schedule.startTime.isNotEmpty
                          ? _formatTime(schedule.startTime, schedule.endTime)
                          : "시간 없음",
                      size: cardHeight * 0.05,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: cardWidth * 0.03),
                child: Divider(
                  height: cardHeight * 0.05,
                  color: Colors.grey,
                  thickness: cardWidth * 0.005,
                ),
              ),

              // 장소 및 교수 정보
              SizedBox(
                height: cardHeight * 0.7, // 원하는 비율로 높이 설정
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 장소 정보
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Theme.of(context).colorScheme.onSurface, size: cardHeight * 0.1),
                        SizedBox(width: cardWidth * 0.02),
                        CustomText(
                          id: schedule.location.isNotEmpty ? schedule.location : "위치 없음",
                          size: cardHeight * 0.12,
                        ),
                        SizedBox(width: cardWidth * 0.02),
                        CustomText(
                          id: '강의실',
                          size: cardHeight * 0.06,
                        ),
                      ],
                    ),
                    // 교수 정보
                    SizedBox(
                      height: cardHeight * 0.2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface, size: cardHeight * 0.1),
                          SizedBox(width: cardWidth * 0.02),
                          CustomText(
                            id: schedule.instructorName.isNotEmpty
                                ? schedule.instructorName
                                : "교수 없음",
                            size: cardHeight * 0.12,
                          ),
                          SizedBox(width: cardWidth * 0.02),
                          CustomText(
                            id: '교수님',
                            size: cardHeight * 0.06,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
