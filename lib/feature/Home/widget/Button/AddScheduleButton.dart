import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // 추가: DateFormat 사용을 위해 intl 패키지 임포트

class AddScheduleDialog extends StatefulWidget {
  @override
  _AddScheduleDialogState createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  String scheduleName = '';
  String location = '';
  String instructorName = '강사 미정'; // 기본값 설정
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // QR 코드 생성 (랜덤 값 또는 시간 기반)
  String generateQrCode() {
    return DateTime.now().millisecondsSinceEpoch.toString(); // QR 코드 생성 방식
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // 모서리 둥글게
      ),
      elevation: 0,
      backgroundColor: Colors.transparent, // 배경 투명
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).shadowColor,
              Theme.of(context).colorScheme.outline
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(20.0), // 여백 추가
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '새 일정 추가',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Divider(color: Theme.of(context).primaryColor, thickness: 5),
            TextFormField(
              decoration: InputDecoration(labelText: '일정 이름', labelStyle: TextStyle(color: Colors.white)),
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
                labelStyle: TextStyle(color: Colors.white),
              ),
              onTap: () => _pickDate(context),
            ),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: startTime == null
                    ? '시작 시간 선택 (HH:MM)'
                    : '시작 시간: ${startTime!.format(context)}',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _selectTime(context, (TimeOfDay pickedTime) {
                  setState(() {
                    startTime = pickedTime;
                  });
                });
              },
            ),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: endTime == null
                    ? '종료 시간 선택 (HH:MM)'
                    : '종료 시간: ${endTime!.format(context)}',
                labelStyle: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _selectTime(context, (TimeOfDay pickedTime) {
                  setState(() {
                    endTime = pickedTime;
                  });
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '장소', labelStyle: TextStyle(color: Colors.white)),
              onChanged: (value) {
                location = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '강사 이름 (선택 사항)', labelStyle: TextStyle(color: Colors.white)),
              onChanged: (value) {
                instructorName = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                  child: Text('취소', style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    _addSchedule(); // 일정 추가 함수 호출
                  },
                  child: Text('추가', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 날짜 선택기 함수
  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // 시간 선택기 함수
  void _selectTime(BuildContext context, Function(TimeOfDay) onTimeSelected) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

  // 일정 추가 함수
  void _addSchedule() async {
    if (scheduleName.isNotEmpty && selectedDate != null && startTime != null && endTime != null && location.isNotEmpty) {
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

      // Firestore에 일정 추가
      await FirebaseFirestore.instance.collection('schedules').doc(scheduleName).set({
        'schedule_name': scheduleName,
        'location': location,
        'instructor_name': instructorName,
        'start_time': Timestamp.fromDate(startDateTime),
        'end_time': Timestamp.fromDate(endDateTime),
        'qr_code': generateQrCode(), // QR 코드 필드 추가
      });

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('일정이 추가되었습니다.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('모든 필드를 입력해주세요.')));
    }
  }
}
