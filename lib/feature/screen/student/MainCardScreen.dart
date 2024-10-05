import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ExpandedCardView.dart';
import 'CollapsedCardView.dart';

class MainCardScreen extends StatefulWidget {
  @override
  _MainCardScreenState createState() => _MainCardScreenState();
}

class _MainCardScreenState extends State<MainCardScreen> {
  bool isExpanded = false;

  // 왼쪽 바에 사용할 색상을 리스트로 정의
  final List<Color> barColors = [
    Color(0xFF3f51b5), // 일정 1
    Color(0xFF7986CB), // 일정 2
    Color(0xFF2962ff), // 일정 3
    Color(0xff6ab0f6), // 일정 4
    Color(0xFF0D47A1), // 일정 5
  ];

  Stream<List<Map<String, String>>> _fetchEvents() {
    return FirebaseFirestore.instance.collection('event').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        // startTime과 endTime이 Timestamp인지 체크한 후 처리
        Timestamp startTime = data['startTime'] is Timestamp ? data['startTime'] : Timestamp.now();
        Timestamp endTime = data['endTime'] is Timestamp ? data['endTime'] : Timestamp.now();

        return {
          "title": data['eventName'].toString(),  // dynamic을 String으로 변환
          "time": "${startTime.toDate().hour}:${startTime.toDate().minute} ~ ${endTime.toDate().hour}:${endTime.toDate().minute}",
          "location": data['eventLocation'].toString(),  // dynamic을 String으로 변환
        };
      }).toList();
    });
  }

  // 이벤트 추가 다이얼로그
  void _showAddEventDialog(BuildContext context) {
    String eventName = '';
    String eventLocation = '';
    String barcode = '';
    DateTime? selectedDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    // 날짜 선택 함수
    Future<void> _pickDate(BuildContext context) async {
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

    // 시간 선택 함수
    Future<void> _selectTime(BuildContext context, Function(TimeOfDay) onTimeSelected) async {
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
              title: Text('새 이벤트 추가'),
              content: Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: '이벤트 이름'),
                      onChanged: (value) {
                        eventName = value;
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: selectedDate == null
                            ? '날짜 선택 (YYYY-MM-DD)'
                            : '선택된 날짜: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                      ),
                      onTap: () => _pickDate(context),
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
                        });
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
                        });
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: '장소'),
                      onChanged: (value) {
                        eventLocation = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: '바코드'),
                      onChanged: (value) {
                        barcode = value;
                      },
                    ),
                  ],
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
                  onPressed: () {
                    if (eventName.isNotEmpty &&
                        selectedDate != null &&
                        startTime != null &&
                        endTime != null &&
                        eventLocation.isNotEmpty &&
                        barcode.isNotEmpty) {
                      final startDateTime = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          startTime!.hour,
                          startTime!.minute);
                      final endDateTime = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                          endTime!.hour,
                          endTime!.minute);

                      // Firestore에 이벤트 추가
                      FirebaseFirestore.instance.collection('event').add({
                        'eventName': eventName,
                        'startTime': Timestamp.fromDate(startDateTime),  // DateTime을 Timestamp로 변환
                        'endTime': Timestamp.fromDate(endDateTime),      // DateTime을 Timestamp로 변환
                        'eventLocation': eventLocation,
                        'barcode': barcode,
                      });
                      Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 30),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showAddEventDialog(context); // 이벤트 추가 다이얼로그 열기
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<Map<String, String>>>(
        stream: _fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 로딩 상태일 때
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 오류가 있을 때
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // 데이터가 없을 때
            return Center(child: Text('No events available'));
          }

          final events = snapshot.data!;

          // GestureDetector를 반환
          return GestureDetector(
            onVerticalDragEnd: (details) {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isExpanded
                  ? ExpandedCardView(
                schedules: events,
                barColors: barColors.length >= events.length
                    ? barColors.sublist(0, events.length)
                    : barColors, // 색상 리스트가 짧으면 전체 사용
                onCollapse: () {
                  setState(() {
                    isExpanded = false;
                  });
                },
              ): CollapsedCardView(
                currentProgress: events.length,
                schedules: events,
                barColors: barColors.length >= events.length
                    ? barColors.sublist(0, events.length)
                    : barColors, // 색상 리스트가 짧으면 전체 사용
                onExpand: () {
                  setState(() {
                    isExpanded = true;
                  });
                },
              ),
            ),
          );
        },
      ),

    );
  }
}
