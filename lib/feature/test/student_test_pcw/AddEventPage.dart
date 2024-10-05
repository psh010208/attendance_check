import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController eventName = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();
  final TextEditingController eventDate = TextEditingController();
  final TextEditingController startTime = TextEditingController();
  final TextEditingController endTime = TextEditingController();

  String qrData = ''; // QR 코드에 저장할 데이터

  // Firestore에 이벤트 저장 함수
  Future<void> addEventToFirestore() async {
    // 입력 폼 검증
    if (eventName.text.isEmpty ||
        eventLocation.text.isEmpty ||
        eventDate.text.isEmpty ||
        startTime.text.isEmpty ||
        startTime.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 채워주세요.')),
      );
      return;
    }

    String eventId = DateTime.now().millisecondsSinceEpoch.toString();

    // QR 코드 데이터를 이벤트 이름과 ID를 조합하여 생성
    qrData = '${eventName.text}_$eventId';

    // Firestore에 이벤트와 QR 코드 저장
    await FirebaseFirestore.instance.collection('event').add({
      'eventName': eventName.text,
      'eventLocation': eventLocation.text,
      'eventDate': eventDate.text,
      'startTime': startTime.text,
      'endTime': endTime.text,
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
        eventDate.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // 날짜 업데이트
      });
    }
  }

  // 시간 선택기
  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
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
              controller: eventName,
              decoration: InputDecoration(labelText: '이벤트 이름'),
            ),
            SizedBox(height: 10),

            // 이벤트 장소 입력 필드
            TextField(
              controller: eventLocation,
              decoration: InputDecoration(labelText: '이벤트 장소'),
            ),
            SizedBox(height: 10),

            // 이벤트 날짜 선택 버튼
            TextField(
              controller: eventDate,
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
              controller: startTime,
              readOnly: true,
              decoration: InputDecoration(
                labelText: '시작 시간',
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context, startTime),
                ),
              ),
            ),
            SizedBox(height: 10),

            // 종료 시간 선택 버튼
            TextField(
              controller: endTime,
              readOnly: true,
              decoration: InputDecoration(
                labelText: '종료 시간',
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context, endTime),
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
