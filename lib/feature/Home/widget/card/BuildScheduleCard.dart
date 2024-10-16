import 'package:flutter/material.dart';
import 'package:attendance_check/feature/Home/widget/card/SchedulCard.dart';
import 'package:attendance_check/feature/Home/model/homeModel.dart';

import '../../../Drawer/model/AttendanceViewModel.dart'; // ScheduleViewModel import

class ScheduleCardBuilder extends StatelessWidget {
  final ScheduleViewModel scheduleViewModel;

  const ScheduleCardBuilder({Key? key, required this.scheduleViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Schedule>>(
      stream: scheduleViewModel.getScheduleStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('일정을 불러오는 중 오류가 발생했습니다: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('등록된 일정이 없습니다.'));
        }

        List<Schedule> schedules = snapshot.data!;
        return ScheduleCard(schedules: schedules);
      },
    );
  }
}
