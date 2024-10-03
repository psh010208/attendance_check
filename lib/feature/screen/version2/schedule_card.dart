import 'package:flutter/material.dart';

Widget buildScheduleCard(
    String title, String time, String location, Color barColor) {
  return Card(
    elevation: 15,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Container(
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/cardLogo.png'),
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 15,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 65,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 40),
                    title: Text(title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    trailing: Text(time,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check_circle_outline, size: 30),
                        onPressed: () {
                          // 체크 아이콘 눌렀을 때 동작
                        },
                      ),
                      SizedBox(width: 10),
                      Text(location, style: TextStyle(fontSize: 15)),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.alarm, size: 30),
                        onPressed: () {
                          // 알림 아이콘 눌렀을 때 동작
                        },
                      ),
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
