import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../view_model/HomeViewModel.dart';

//일정 추가
void AddSchedule(BuildContext context) {
  // ScheduleViewModel 인스턴스 생성
  ScheduleViewModel scheduleViewModel = ScheduleViewModel();

  Future<void> _pickDate(BuildContext context, StateSetter setState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        scheduleViewModel.selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, Function(TimeOfDay) onTimeSelected, StateSetter setState) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        onTimeSelected(pickedTime);
      });
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('새 일정 추가'),
            content: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: '일정 이름'),
                      onChanged: (value) {
                        scheduleViewModel.scheduleName = value;
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: scheduleViewModel.selectedDate == null
                            ? '날짜 선택 (YYYY-MM-DD)'
                            : '선택된 날짜: ${scheduleViewModel.selectedDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      onTap: () => _pickDate(context, setState),
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: scheduleViewModel.startTime == null
                            ? '시작 시간 선택 (HH:MM)'
                            : '시작 시간: ${scheduleViewModel.startTime!.format(context)}',
                      ),
                      onTap: () {
                        _selectTime(context, (TimeOfDay pickedTime) {
                          setState(() {
                            scheduleViewModel.startTime = pickedTime;
                          });
                        }, setState);
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: scheduleViewModel.endTime == null
                            ? '종료 시간 선택 (HH:MM)'
                            : '종료 시간: ${scheduleViewModel.endTime!.format(context)}',
                      ),
                      onTap: () {
                        _selectTime(context, (TimeOfDay pickedTime) {
                          setState(() {
                            scheduleViewModel.endTime = pickedTime;
                          });
                        }, setState);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: '장소'),
                      onChanged: (value) {
                        scheduleViewModel.location = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: '강사 이름 (선택 사항)'),
                      onChanged: (value) {
                        scheduleViewModel.instructorName = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('추가'),
                onPressed: () async {
                  try {
                    await scheduleViewModel.addSchedule();  // ViewModel의 addSchedule 호출
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('일정이 추가되었습니다.')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('오류가 발생했습니다: $e')),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}
