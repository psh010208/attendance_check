import 'package:attendance_check/feature/Home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import '../Drawer/model/InfoModel.dart';
import 'Model/model.dart';
import 'ViewModel/viewModel.dart';
import 'widget/button/deleteButton.dart';
import 'widget/button/dialogOkButton.dart';
import 'widget/button/dialogRepickButton.dart';
import 'widget/button/pickButton.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Lottery/ViewModel/viewModel.dart';

class PrizeDrawPage extends StatefulWidget {
  final String role;
  final String id;

  PrizeDrawPage({required this.role, required this.id});

  @override
  _PrizeDrawPageState createState() => _PrizeDrawPageState();
}

class _PrizeDrawPageState extends State<PrizeDrawPage> {
  final LotteryViewModel _lotteryViewModel = LotteryViewModel();
  bool isLoading = false; // 로딩 상태 관리

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surface,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text('상품 추첨하기', style: Theme
            .of(context)
            .textTheme
            .titleLarge),
        centerTitle: true,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>
                  HomeScreen(role: widget.role, id: widget.id)),
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                color: Colors.black,
              );
            },
          ),
        ],
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.w,
          ),
        ),
      ),
      endDrawer: DrawerScreen(role: widget.role, id: widget.id),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // gif 박스
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xff26539C), width: 5.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 1.w,
                  blurRadius: 6.w,
                  offset: Offset(0, 3.h),
                ),
              ],
            ),
            width: 300.w,
            height: 200.h,
            child: isLoading
                ? Image.asset(
              'assets/surprise.gif',
              fit: BoxFit.fill,
            )
                : Image.asset(
              'assets/surprise.png',
              fit: BoxFit.fill,
            ),
          ),

          // 학생 리스트 표시 부분
          Expanded(
            child: StreamBuilder<List<LotteryStudent>>(
              stream: _lotteryViewModel.getLotteryResults(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final students = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: createColumns(),
                      rows: createRows(students),
                    ),
                  ),
                );
              },
            ),
          ),

          // 상품 추첨하기 버튼
          PickButton(
            isLoading: isLoading,
            onPressed: () async {
              await drawLottery();
            },
          ),
        ],
      ),
    );
  }

  // 열 생성 함수
  List<DataColumn> createColumns() {
    return [
      DataColumn(label: Text("학과", style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onSurface,
          fontSize: 19.sp, fontWeight: FontWeight.bold))),
      DataColumn(label: Text("학번", style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onSurface, fontSize: 19.sp, fontWeight: FontWeight.bold))),
      DataColumn(label: Text("이름", style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onSurface, fontSize: 19.sp, fontWeight: FontWeight.bold))),
      DataColumn(label: Text("참여 횟수", style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onSurface, fontSize: 19.sp, fontWeight: FontWeight.bold))),
      DataColumn(label: Text("삭제", style: TextStyle(color: Theme
          .of(context)
          .colorScheme
          .onSurface, fontSize: 19.sp, fontWeight: FontWeight.bold))),
      // 삭제 열 추가
    ];
  }

  // Firestore에서 불러온 학부생 데이터를 행으로 변환
  List<DataRow> createRows(List<LotteryStudent> students) {
    return students.map((student) {
      print('하이');
      print(student.name);
      print(student.studentId);


      return DataRow(
        cells: [
          DataCell(Text(student.department)),
          DataCell(Text(student.studentId)),
          DataCell(Text(student.name)), // 여기서 student.name 사용
          DataCell(Text(student.attendanceCount.toString())),
          DataCell(
            DeleteButton(

              onPressed: () async {
                bool confirmDelete = await _showConfirmationDialog(context);
                if (confirmDelete) {
                  // Firestore에서 해당 학생 삭제
                  await _lotteryViewModel.deleteStudent(student.studentId);
                  setState(() {
                    // 삭제 후 화면 업데이트
                    students.remove(student);
                  });
                }
              },
            ),
          ),
        ],
      );
    }).toList();
  }

  // 삭제 확인 다이얼로그
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('삭제 확인'),
          content: Text('정말로 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

// 상품 추첨 로직
  Future<void> drawLottery() async {
    setState(() {
      isLoading = true;
    });

    try {
      // runLottery가 호출되는지 확인하기 위해 print 문 추가
      print('runLottery 호출 전');

      LotteryStudent winner = await _lotteryViewModel.runLottery();

      print('runLottery 호출 후, 추첨된 학생: ${winner.name}');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('추첨 완료'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${winner.department}의 ${winner.name}님이 당첨되었습니다!'),
                // 이름 가져오기
                SizedBox(height: 16.h),
              ],
            ),
            actions: [
              DialogOkButton(onPressed: () {
                Navigator.of(context).pop();
              }),
              DialogRepickButton(onPressed: () {
                Navigator.of(context).pop();
                drawLottery(); // 재추첨
              }),
            ],
          );
        },
      );
    } catch (e) {
      print('에러 발생: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('추첨 중 오류가 발생했습니다. 다시 시도해주세요.'),
            actions: [
              DialogOkButton(onPressed: () {
                Navigator.of(context).pop();
              }),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
