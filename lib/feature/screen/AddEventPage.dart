import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventLocationController = TextEditingController();
  final TextEditingController eventDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  String qrData = ''; // QR 코드에 저장할 데이터

  // Firestore에 이벤트 저장 함수
  Future<void> addEventToFirestore() async {
    // 입력 폼 검증
    if (eventNameController.text.isEmpty ||
        eventLocationController.text.isEmpty ||
        eventDateController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 채워주세요.')),
      );
      return;
    }

    String eventId = DateTime.now().millisecondsSinceEpoch.toString();

    // QR 코드 데이터를 이벤트 이름과 ID를 조합하여 생성
    qrData = '${eventNameController.text}_$eventId';

    // Firestore에 이벤트와 QR 코드 저장
    await FirebaseFirestore.instance.collection('events').add({
      'eventName': eventNameController.text,
      'eventLocation': eventLocationController.text,
      'eventDate': eventDateController.text,
      'startTime': startTimeController.text,
      'endTime': endTimeController.text,
      'barcode': qrData,
      'eventId': eventId,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('이벤트가 성공적으로 추가되었습니다!')),
    );

    // 상태 업데이트
    setState(() {
      qrData = ''; // QR 코드 데이터를 초기화
    });
  }

  // 날짜 선택기
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        eventDateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // 날짜 업데이트
      });
    }
  }

  // 시간 선택기
  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        controller.text = pickedTime.format(context); // 시간 업데이트
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이벤트 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 이벤트 이름 입력 필드
            TextField(
              controller: eventNameController,
              decoration: InputDecoration(labelText: '이벤트 이름'),
            ),
            SizedBox(height: 10),

            // 이벤트 장소 입력 필드
            TextField(
              controller: eventLocationController,
              decoration: InputDecoration(labelText: '이벤트 장소'),
            ),
            SizedBox(height: 10),

            // 이벤트 날짜 선택 버튼
            TextField(
              controller: eventDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: '이벤트 날짜',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            SizedBox(height: 10),

            // 시작 시간 선택 버튼
            TextField(
              controller: startTimeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: '시작 시간',
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context, startTimeController),
                ),
              ),
            ),
            SizedBox(height: 10),

            // 종료 시간 선택 버튼
            TextField(
              controller: endTimeController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: '종료 시간',
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context, endTimeController),
                ),
              ),
            ),
            SizedBox(height: 20),

            // 이벤트 추가 버튼
            ElevatedButton(
              onPressed: () {
                addEventToFirestore();
              },
              child: Text('이벤트 추가'),
            ),
          ],
        ),
      ),
    );
  }
}
