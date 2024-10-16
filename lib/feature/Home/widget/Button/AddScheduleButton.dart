import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//일정 추가
void AddSchedule(BuildContext context) {
  String scheduleName = '';
  String location = '';
  String instructorName = '강사 미정'; // 기본값 설정
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _pickDate(BuildContext context, StateSetter setState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
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
                        scheduleName = value;
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: selectedDate == null
                            ? '날짜 선택 (YYYY-MM-DD)'
                            : '선택된 날짜: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      onTap: () => _pickDate(context, setState),
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: startTime == null
                            ? '시작 시간 선택 (HH:MM)'
                            : '시작 시간: ${startTime!.format(context)}',
                      ),
                      onTap: () {
                        _selectTime(context, (TimeOfDay pickedTime) {
                          setState(() {
                            startTime = pickedTime;
                          });
                        }, setState);
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: endTime == null
                            ? '종료 시간 선택 (HH:MM)'
                            : '종료 시간: ${endTime!.format(context)}',
                      ),
                      onTap: () {
                        _selectTime(context, (TimeOfDay pickedTime) {
                          setState(() {
                            endTime = pickedTime;
                          });
                        }, setState);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: '장소'),
                      onChanged: (value) {
                        location = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: '강사 이름 (선택 사항)'),
                      onChanged: (value) {
                        instructorName = value;
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
                  if (scheduleName.isNotEmpty &&
                      selectedDate != null &&
                      startTime != null &&
                      endTime != null &&
                      location.isNotEmpty) {
                    final startDateTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      startTime!.hour,
                      startTime!.minute,
                    );
                    final endDateTime = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      endTime!.hour,
                      endTime!.minute,
                    );

                    // Firestore에서 현재 일정 개수를 가져옴
                    DocumentSnapshot<Map<String, dynamic>> scheduleDoc = await FirebaseFirestore.instance
                        .collection('scheduleMeta')
                        .doc('scheduleCountDoc')
                        .get();

                    int currentCount = scheduleDoc.data()?['scheduleCount'] ?? 0;

                    // Firestore에 일정 추가
                    FirebaseFirestore.instance.collection('schedule').add({
                      'schedule_name': scheduleName,
                      'location': location,
                      'instructor_name': instructorName,
                      'start_time': Timestamp.fromDate(startDateTime),
                      'end_time': Timestamp.fromDate(endDateTime),
                      'schedule_count': currentCount + 1,
                    }).then((_) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('일정이 추가되었습니다.')),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('오류가 발생했습니다: $error')),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('모든 필드를 입력해주세요.')),
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

