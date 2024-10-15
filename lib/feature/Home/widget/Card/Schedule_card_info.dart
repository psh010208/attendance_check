import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';

import '../../../Drawer/widget/IdText.dart';

class ScheduleCardInfo extends StatelessWidget {
  final Schedule schedule;

  const ScheduleCardInfo({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      height: 100.h, // 필요한 경우 높이 설정
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Theme.of(context).colorScheme.onSurface),
              SizedBox(width: 8.w),
              CustomText(
                id: schedule.location.isNotEmpty ? schedule.location : "위치 없음",
                size: 25.sp,
              ),
              SizedBox(width: 8.w),
              CustomText(
                id: '강의실',
                size: 15.sp,
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
                id: schedule.instructorName.isNotEmpty ? schedule.instructorName : "교수님 없음",
                size: 23.sp,
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
    );
  }
}
