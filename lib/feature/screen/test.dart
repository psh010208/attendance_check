import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int currentProgress = 3; // 현재 참여 상황 (0~9)
  bool isExpanded = false; // 카드를 펼쳤는지 여부

  // 왼쪽 바에 사용할 색상을 리스트로 정의
  final List<Color> barColors = [
    Color(0xFF3f51b5), // 일정 1
    Color(0xFF7986CB), // 일정 2
    Color(0xFF2962ff), // 일정 3
    Color(0xff6ab0f6), // 일정 4
    Color(0xFF0D47A1), // 일정 5
  ];

  // 카드 정보를 저장하는 리스트
  final List<Map<String, String>> schedules = [
    {"title": "일정 1", "time": "09:30 ~ 11:00", "location": "장소:1506"},
    {"title": "일정 2", "time": "11:30 ~ 13:00", "location": "장소:1506"},
    {"title": "일정 3", "time": "13:30 ~ 15:00", "location": "장소:1506"},
    {"title": "일정 4", "time": "15:30 ~ 17:00", "location": "장소:1506"},
    {"title": "일정 5", "time": "17:30 ~ 19:00", "location": "장소:1506"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            isExpanded = !isExpanded; // 카드를 펼치도록 설정
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0), /////////////////////
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!isExpanded) ...[
                // 카드를 펼치기 전 참여 상황 및 진행도 표시
                SizedBox(height: 20),
                Text('참여 상황: $currentProgress / 9', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                // 커스텀 막대
                buildCustomProgressBar(currentProgress),
                SizedBox(height: 20),

              ],
              if (isExpanded)
              // '밀어서 접기' 버튼이 상단에 나타남
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = false;
                    });
                  },
                  child: Text("밀어서 접기", style: TextStyle(decoration: TextDecoration.underline)),
                ),
              Expanded(
                child: Stack(
                  children: [
                    if (!isExpanded)
                      buildOverlappingCards(), // 카드들이 겹쳐 보이도록
                    if (isExpanded)
                      ListView(
                        children: schedules.map((schedule) {
                          // schedule 정보를 사용하여 카드 생성
                          int index = schedules.indexOf(schedule);
                          return buildScheduleCard(schedule["title"]!, schedule["time"]!, schedule["location"]!, barColors[4-index]);
                        }).toList(),
                      ),
                  ],
                ),
              ),
              if (!isExpanded)
              // '밀어서 펼치기' 버튼 표시
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
                  child: Text("밀어서 펼치기", style: TextStyle(decoration: TextDecoration.underline)),
                ),
              // QR 코드 인식 버튼 추가
              if (!isExpanded)
                SizedBox(height: 30), // 버튼과 위의 내용 간격
              if (!isExpanded)
              // 펼친 이후에는 QR코드 인식 버튼 숨김
                IconButton(
                  onPressed: () {
                    // QR 코드 인식 기능을 추가하는 부분
                  },
                  icon: Icon(Icons.qr_code_2_rounded, size: 35,),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // 배경색을 투명하게 설정
                    shadowColor: Colors.transparent, // 그림자 색상도 투명하게 설정
                  ),
                ),
              if (!isExpanded)
                SizedBox(height: 16), // 버튼과 화면 아래 간격
            ],
          ),
        ),
      ),);
  }

  Widget buildOverlappingCards() {
    // 겹치는 카드들을 쌓아놓은 레이아웃을 구현
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        children: schedules.reversed.toList().asMap().entries.map((entry) { // 펼친 이후 맨 위에 일정 1이 오게 하려고 리스트를 리버스
          int index = entry.key;
          var schedule = entry.value;
          return Positioned(
            top: index * 50, // 카드 사이의 간격
            left: 0,
            right: 0,
            child: buildScheduleCard(schedule["title"]!, schedule["time"]!, schedule["location"]!, barColors[index]),
          );
        }).toList(),
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

  // 둥근 끝을 가진 커스텀 막대
  Widget buildCustomProgressBar(int progress) {
    int totalSteps = 9; // 총 9칸
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          width: 25,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: index < progress ? Colors.red : Colors.grey[300], // 색칠된 칸과 미색칠 칸 구분
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(index == 0 ? 5 : 0), // 왼쪽 끝 둥글게
              right: Radius.circular(index == totalSteps - 1 ? 5 : 0), // 오른쪽 끝 둥글게
            ),
          ),
        );
      }),
    );
  }
}
