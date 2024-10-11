import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CollapsedCardView_admin.dart';
import 'ExpandedCardView_admin.dart';
import 'package:attendance_check/feature/screen/MyPage.dart';
import 'package:attendance_check/feature/sign/SignInPage.dart';

class MainAdminScreen extends StatefulWidget {
  final String id;  // id 필드 추가
  final String role;

  // 생성자를 통해 id를 받음
  MainAdminScreen({required this.id, required this.role});

  @override
  _MainAdminScreenState createState() => _MainAdminScreenState();
}

class CustomDrawer extends StatelessWidget {
  final String id;  // id 필드 추가
  final String role;

  CustomDrawer({required this.id, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF0C3C73),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.account_circle, size: 60), // 계정 아이콘
                ),
                SizedBox(height: 13),
                Text(
                  role, // 역할 표시
                  style: TextStyle(
                    color: Colors.white, // 텍스트 색상
                    fontSize: 23, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 굵게
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  id, // 아이디 표시
                  style: TextStyle(
                    color: Colors.white, // 텍스트 색상
                    fontSize: 20, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 굵게
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.grey,
            thickness: 2,
            height: 1,
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(
                Icons.task_alt,
              size: 33,
              color: Colors.white,
            ),
            title: Text(
                '참여 학생 현황',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onTap: () {
              // Home으로 이동하는 로직
            },
          ),
          ListTile(
            leading: Icon(
              Icons.redeem,
              size: 33,
              color: Colors.white,
            ),
            title: Text(
              '상품 추첨',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onTap: () {
              // Home으로 이동하는 로직
            },
          ),
          ListTile(
            leading: Icon(
              Icons.list_alt,
              size: 33,
              color: Colors.white,
            ),
            title: Text(
              '추첨 결과',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            onTap: () {
              // Home으로 이동하는 로직
            },
          ),
          SizedBox(height: 250),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // 로그아웃 로직을 여기에 추가하세요.
                // 로그아웃 후 SignInPage로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // 버튼 배경색을 투명하게 설정
                shadowColor: Colors.transparent, // 그림자 색상 투명하게
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 패딩 조정
              ),
              child: Row( // 아이콘과 텍스트를 나란히 배치
                mainAxisSize: MainAxisSize.min, // 버튼 크기를 최소화
                children: [
                  Icon(
                    Icons.logout, // 로그아웃 아이콘
                    color: Colors.white, // 아이콘 색상 (필요에 따라 변경)
                    size: 33,
                  ),
                  SizedBox(width: 8), // 아이콘과 텍스트 간의 간격
                  Text(
                    '로그아웃',
                    style: TextStyle(fontSize: 20), // 텍스트 크기 조정
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25),
          Image.asset('assets/simple_logo.png', width: 150, height: 30),
        ],
      ),
    );
  }
}



class _MainAdminScreenState extends State<MainAdminScreen> {
  bool isExpanded = false;
  List<dynamic> events = []; //이벤트 리스트


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
        backgroundColor: Colors.white,
        //iconTheme: IconThemeData(color: Colors.black), // AppBar의 아이콘 테마
        actionsIconTheme: IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 30),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.black, // + 아이콘을 검은색으로 설정
              ),
              onPressed: () {
                _showAddEventDialog(context); // 이벤트 추가 다이얼로그 열기
              },
            ),
          ],
        ),
      ),
<<<<<<< HEAD
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // 왼쪽 정렬
                children: [
                  CircleAvatar(
                    radius: 30, // 아이콘 크기
                    child: Icon(Icons.account_circle, size: 60), // 계정 아이콘
                  ),
                  SizedBox(height: 13), // 아이콘과 텍스트 간격
                  Text(
                    '컴퓨터공학과', // 학과
                    style: TextStyle(
                      color: Colors.white, // 텍스트 색상
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '홍길동', // 학생 이름
                    style: TextStyle(
                      color: Colors.white, // 텍스트 색상
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 1,
            ),
            SizedBox(height: 10),
            // Drawer의 다른 항목들
            ListTile(
              leading: Icon(
                  Icons.task_alt,
                size: 33,
                color: Colors.white,
              ),
              title: Text(
                  '참여 학생 현황',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Home으로 이동하는 로직
              },
            ),
            ListTile(
              leading: Icon(
                Icons.redeem,
                size: 33,
                color: Colors.white,
              ),
              title: Text(
                '상품 추첨',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Home으로 이동하는 로직
              },
            ),
            ListTile(
              leading: Icon(
                Icons.list_alt,
                size: 33,
                color: Colors.white,
              ),
              title: Text(
                '추첨 결과',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Home으로 이동하는 로직
              },
            ),
            SizedBox(height: 250),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 로그아웃 로직을 여기에 추가하세요.
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // 버튼 배경색을 투명하게 설정
                  shadowColor: Colors.transparent, // 그림자 색상 투명하게
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 패딩 조정
                ),
                child: Row( // 아이콘과 텍스트를 나란히 배치
                  mainAxisSize: MainAxisSize.min, // 버튼 크기를 최소화
                  children: [
                    Icon(
                      Icons.logout, // 로그아웃 아이콘
                      color: Colors.white, // 아이콘 색상 (필요에 따라 변경)
                      size: 33,
                    ),
                    SizedBox(width: 8), // 아이콘과 텍스트 간의 간격
                    Text(
                      '로그아웃',
                      style: TextStyle(fontSize: 20), // 텍스트 크기 조정
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Image.asset('assets/simple_logo.png', width: 150, height: 30),
          ],
        ),
      ),
=======
      endDrawer: CustomDrawer(id: widget.id, role: widget.role),
>>>>>>> e8172dc72da2715bc4a173b5cef8c027a583ecdc

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
                  ? ExpandedCardView_admin(
                schedules: events,
                barColors: barColors.length >= events.length
                    ? barColors.sublist(0, events.length)
                    : barColors, // 색상 리스트가 짧으면 전체 사용
                onCollapse: () {
                  setState(() {
                    isExpanded = false;
                  });
                },
              ): CollapsedCardView_admin(
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
