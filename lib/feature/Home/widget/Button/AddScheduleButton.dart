import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../Text/CustomScheduleTextField.dart';

class AddScheduleDialog extends StatefulWidget {
  @override
  _AddScheduleDialogState createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  String instructorName = '강사 미정';
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final TextEditingController _scheduleNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _instructorNameController = TextEditingController(text: '강사 미정');
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  String generateQrCode() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      cancelText: '취소',
      confirmText: '확인',
      helpText: '캘린더',
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).indicatorColor,
              onPrimary: Theme.of(context).colorScheme.primary,
              surface: Theme.of(context).secondaryHeaderColor,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.onSurface,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: TextStyle(fontSize: 15),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  void _selectTime(BuildContext context, Function(TimeOfDay) onTimeSelected, {required String helpText}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      helpText: helpText,
      cancelText: '취소',
      confirmText: '확인',
      hourLabelText: '             시',
      minuteLabelText: '           분',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.white60,
              onPrimary: Theme.of(context).colorScheme.primary,
              surface: Theme.of(context).secondaryHeaderColor,
              secondary: Theme.of(context).colorScheme.inversePrimary,
            ),
            dialogBackgroundColor: Theme.of(context).colorScheme.primaryContainer,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: TextStyle(fontSize: 15),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      onTimeSelected(pickedTime);
    }
  }

  void _addSchedule() async {
    if (_scheduleNameController.text.isNotEmpty && selectedDate != null && startTime != null && endTime != null && _locationController.text.isNotEmpty) {
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

      await FirebaseFirestore.instance.collection('schedules').add({
        'schedule_name': _scheduleNameController.text,
        'location': _locationController.text,
        'instructor_name': _instructorNameController.text,
        'start_time': Timestamp.fromDate(startDateTime),
        'end_time': Timestamp.fromDate(endDateTime),
        'qr_code': generateQrCode(),
      });

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('새로운 일정이 등록되었습니다')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('필요한 일정 정보를 입력해 주세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0,
      backgroundColor: Color(0xFF333333),
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '일정 추가',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFC8C8C8)),
              ),
              Divider(color: Colors.white.withOpacity(0.7), thickness: 2),
              SizedBox(height: 5.h),
              CustomScheduleTextField(
                labelText: '일정 이름',
                controller: _scheduleNameController,
                prefixIcon: Icons.event,
              ),
              SizedBox(height: 8.h),
              CustomScheduleTextField(
                labelText: '날짜 선택 (YYYY-MM-DD)',
                controller: _dateController,
                onTap: () => _pickDate(context),
                prefixIcon: Icons.calendar_today,
              ),
              SizedBox(height: 8.h),
              CustomScheduleTextField(
                labelText: '시작 시간 선택 (HH:MM)',
                controller: _startTimeController,
                onTap: () => _selectTime(context, (TimeOfDay pickedTime) {
                  setState(() {
                    startTime = pickedTime;
                    _startTimeController.text = pickedTime.format(context);
                  });
                }, helpText: '시작 시간 설정'),
                prefixIcon: Icons.access_time,
              ),
              SizedBox(height: 8.h),
              CustomScheduleTextField(
                labelText: '종료 시간 선택 (HH:MM)',
                controller: _endTimeController,
                onTap: () => _selectTime(context, (TimeOfDay pickedTime) {
                  setState(() {
                    endTime = pickedTime;
                    _endTimeController.text = pickedTime.format(context);
                  });
                }, helpText: '종료 시간 설정'),
                prefixIcon: Icons.timelapse,
              ),
              SizedBox(height: 8.h),
              CustomScheduleTextField(
                labelText: '장소',
                controller: _locationController,
                prefixIcon: Icons.location_on,
              ),
              SizedBox(height: 8.h),
              CustomScheduleTextField(
                labelText: '강사 이름 (선택 사항)',
                controller: _instructorNameController,
                prefixIcon: Icons.person_outline,
              ),
              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('취소', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: _addSchedule,
                    child: Text('추가', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
