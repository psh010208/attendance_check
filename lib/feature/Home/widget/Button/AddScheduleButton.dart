import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: Theme.of(context).colorScheme.scrim, // 배경 투명
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),

        ),
        padding: EdgeInsets.all(20.0), // 여백 추가
        child: SingleChildScrollView( // 키보드 오버플로우 방지
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '일정 추가',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Divider(color: Colors.white.withOpacity(0.7), thickness: 2),
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.2),
                  labelText: '일정 이름',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  scheduleName = value;
                },
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.2),
                  labelText: selectedDate == null
                      ? '날짜 선택 (YYYY-MM-DD)'
                      : '선택된 날짜: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  filled: true,
                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () => _pickDate(context),
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.2),
                  labelText: startTime == null
                      ? '시작 시간 선택 (HH:MM)'
                      : '시작 시간: ${startTime!.format(context)}',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
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
                  fillColor: Colors.white.withOpacity(0.2),
                  labelText: endTime == null
                      ? '종료 시간 선택 (HH:MM)'
                      : '종료 시간: ${endTime!.format(context)}',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
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
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.2),
                  labelText: '장소',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  location = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.2),
                  labelText: '강사 이름 (선택 사항)',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
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
      ),
    );
  }

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).colorScheme.secondaryContainer, // Set the top bar color to blue
              onPrimary: Theme.of(context).colorScheme.onSurface, // Set the text color to white on the blue top bar
              surface: Theme.of(context).colorScheme.secondaryContainer, // Background color of the calendar area
              onSurface: Colors.black, // Text color of the calendar days
            ),
            dialogBackgroundColor: Colors.blue, // Background color for the dialog
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _selectTime(BuildContext context, Function(TimeOfDay) onTimeSelected) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input, // Starts with the input mode (second image)

    );
    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

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
