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
    return FirebaseFirestore.instance.collection('events').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일정 목록'),
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
                        String title = event['eventName'];
                        String time =
                            "${event['startTime']} ~ ${event['endTime']}";
                        String location = event['eventLocation'];

                        return buildScheduleCard(title, time, location);
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

  Widget buildScheduleCard(String title, String time, String location) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18)),
        subtitle: Text(time),
        trailing: Text(location),
      ),
    );
  }
}
