import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool isExpanded = false;

  // Firestore에서 데이터를 가져오는 스트림
  Stream<QuerySnapshot> getEvents() {
    return FirebaseFirestore.instance.collection('event').snapshots();
  }

  // 왼쪽 바에 사용할 색상을 리스트로 정의
  final List<Color> barColors = [
    Color(0xFF3f51b5), // 일정 1
    Color(0xFF7986CB), // 일정 2
    Color(0xFF2962ff), // 일정 3
    Color(0xff6ab0f6), // 일정 4
    Color(0xFF0D47A1), // 일정 5
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/logo.png', width: 150, height: 30), // 학교 로고
            Spacer(),
            IconButton(onPressed: () {}, icon: Icon(Icons.menu)), // 메뉴 아이콘
          ],
        ),
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isExpanded)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
                  child: Text(
                    "밀어서 접기",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('오류 발생: ${snapshot.error}'));
                    }

                    final events = snapshot.data!.docs;

                    if (events.isEmpty) {
                      return Center(child: Text('추가된 일정이 없습니다.'));
                    }

                    return ListView(
                      children: events.map((event) {
                        // Firestore에서 데이터를 가져와 카드로 생성
                        String title = event['eventName'];
                        String time = "${event['startTime']} ~ ${event['endTime']}";
                        String location = event['eventLocation'];
                        int index = events.indexOf(event) % barColors.length;  // 색상 인덱스를 순환하도록 설정

                        return buildScheduleCard(title, time, location, barColors[index]);
                      }).toList(),
                    );
                  },
                ),
              ),
              if (!isExpanded)
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                  child: Text(
                    "밀어서 펼치기",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildScheduleCard(String title, String time, String location, Color barColor) {
    return Card(
      elevation: 15, // 그림자 효과 추가
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // 모서리 둥글게
      ),
      child: Container(
        height: 180, // 카드의 세로 길이 조정
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/cardLogo.png'), // 학교 마크 이미지 경로
            fit: BoxFit.scaleDown, // 이미지가 카드의 전체 영역을 덮도록 설정
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.dstATop), // 투명도 조절
          ),
          borderRadius: BorderRadius.circular(10), // 모서리 둥글게
        ),
        child: Row(
          children: [
            Container(
              width: 15, // 왼쪽 바의 너비
              decoration: BoxDecoration(
                color: barColor, // 왼쪽 바의 색상 지정
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), // 위쪽 왼쪽 끝 둥글게
                  bottomLeft: Radius.circular(10), // 아래쪽 왼쪽 끝 둥글게
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 65, // 체크 버튼, 장소, 알림 버튼의 위치를 카드 정 중앙으로
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 40), // 내용 패딩
                      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      trailing: Text(time, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.check_circle_outline, size: 30,),
                              onPressed: () {
                                // 체크 아이콘 눌렀을 때 동작
                              },
                            ),
                            SizedBox(width: 10,),
                            Text('$location', style: TextStyle(fontSize: 15),),
                            SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.alarm, size: 30,),
                              onPressed: () {
                                // 알림 아이콘 눌렀을 때 동작
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
