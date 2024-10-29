import 'package:attendance_check/feature/Home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../ApproveList/widget/CustomText.dart';
import 'Model/model.dart';
import 'ViewModel/viewModel.dart';
import 'widget/button/lottery_delete_button.dart';
import 'widget/button/lottery_dialog_register_button.dart';
import 'widget/button/lottery_dialog_redraw_button.dart';
import 'widget/button/lottery_draw_button.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';
import 'package:attendance_check/feature/Store/MyStore.dart';

class LotteryView extends StatefulWidget {
  final String role;
  final String id;

  LotteryView({required this.role, required this.id});

  @override
  _LotteryView createState() => _LotteryView();
}

class _LotteryView extends State<LotteryView> {
  final LotteryViewModel _lotteryViewModel = LotteryViewModel();
  bool isLoading = false; // 로딩 상태 관리

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: CustomText(id : '상품 추첨하기',
          color: Theme.of(context).colorScheme.scrim,
          size: 20.sp,),
        centerTitle: true,
        elevation: 1,

        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: Theme.of(context).colorScheme.scrim,
                size: 25.sp),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(role: widget.role, id: widget.id)));
            }),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                color: Theme.of(context).colorScheme.scrim,
              );
            },
          ),
        ],
      ),
      endDrawer: DrawerScreen(role: widget.role, id: widget.id,        isFriendView: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onInverseSurface,
              Theme.of(context).primaryColorLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.9],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [// gif 박스
            // gif 박스
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  width: 1.5.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    spreadRadius: 1.w,
                    blurRadius: 6.w,
                    offset: Offset(0, 3.h),
                  ),
                ],
                borderRadius: BorderRadius.circular(150.w), // 동그란 모양 설정
              ),
              width: 210.w,
              height: 210.w, // 높이와 너비를 같게 설정하여 정원형으로 만들기
              child: ClipOval(
                child: isLoading
                    ? Image.asset(
                  'assets/surprise.gif',
                  fit: BoxFit.cover, // 비율 유지하며 잘리도록 설정
                )
                    : Image.asset(
                  'assets/surprise.png',
                  fit: BoxFit.cover, // 비율 유지하며 잘리도록 설정
                ),
              ),
            ),

            // 학생 리스트 표시 부분
            Container(
              height: 230.h,
              child: StreamBuilder<List<LotteryStudent>>(
                stream: _lotteryViewModel.getLotteryResults(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final students = snapshot.data!;
                  return Container(
                    margin: EdgeInsets.fromLTRB(3.w, 3, 3.w, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).splashColor,
                          width: 0.6.w),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: DataTable(
                          columns: createColumns(),
                          rows: createRows(students),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 상품 추첨하기 버튼
            LotteryDrawButton(
              isLoading: isLoading,
              onPressed: () async {
                await drawLottery();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> createColumns() {
    return [
      DataColumn(
        label: SizedBox(
          width: 200.w, // 너비 설정
          height: 90.h, // 높이 설정
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary, // 배경색 변경
            ),
            child: Text(
              "학과",
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: 200.w, // 너비 설정
          height: 90.h, // 높이 설정
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary, // 배경색 변경
            ),
            child: Text(
              "학번",
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: 200.w, // 너비 설정
          height: 90.h, // 높이 설정
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary, // 배경색 변경
            ),
            child: Text(
              "이름",
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      // DataColumn(
      //   label: SizedBox(
      //     width: 200.w, // 너비 설정
      //     height: 90.h, // 높이 설정
      //     child: ElevatedButton(
      //       onPressed: () {},
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: Theme.of(context).colorScheme.secondary, // 배경색 변경
      //       ),
      //       child: Text(
      //         "참여 횟수",
      //         style: TextStyle(
      //           fontSize: 36.sp,
      //           fontWeight: FontWeight.bold,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      DataColumn(
        label: SizedBox(
          width: 200.w, // 너비 설정
          height: 90.h, // 높이 설정
          child: ElevatedButton(
            onPressed: () {
              context.read<MyStore>().changeReversed();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary, // 배경색 변경
            ),
            child: Text(
              "등수",
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: 160.w, // 너비 설정
          height: 90.h, // 높이 설정
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary, // 배경색 변경
            ),
            child: Text(
              "삭제",
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  // Firestore에서 불러온 학부생 데이터를 행으로 변환
  List<DataRow> createRows(List<LotteryStudent> students) {
    // 참여 횟수로 학생 리스트를 정렬하여 등수를 계산
    List<LotteryStudent> sortedStudents = List.from(students)
      ..sort((a, b) => b.attendanceCount.compareTo(a.attendanceCount));

    // 추첨할 학생 리스트 생성
    List<LotteryStudent> drawList = [];

    // 추첨 로직을 통해 순서를 유지하면서 먼저 뽑힌 사람을 상단에 추가
    for (var student in sortedStudents) {
      // 각 학생이 추첨되었다고 가정하고 drawList에 추가
      drawList.add(student);
    }

    return drawList.asMap().entries.map((entry) {
      int rank = entry.key; // 0부터 시작하는 등수
      LotteryStudent student = entry.value;

      List<int> rankList = [1,2,2,3,3,3,4,4,4,4,5,5,5,5,5];
      List<int> rankListReverse = [5,5,5,5,5,4,4,4,4,3,3,3,2,2,1];

      final isReversed = context.watch<MyStore>().isReversed;

      return DataRow(
        cells: [
          DataCell(
            Container(
              alignment: Alignment.center, // 중앙 정렬
              child: Text(student.department,
                  style: TextStyle(
                    fontSize: 35.sp,
                    color: Colors.black,
                  )),
            ),
          ),
          DataCell(
            Container(
              alignment: Alignment.center, // 중앙 정렬
              child: Text(student.studentId,
                  style: TextStyle(
                    fontSize: 35.sp,
                    color: Colors.black,
                  )),
            ),
          ),
          DataCell(
            Container(
              alignment: Alignment.center, // 중앙 정렬
              child: Text(student.name,
                  style: TextStyle(
                    fontSize: 35.sp,
                    color: Colors.black,
                  )),
            ),
          ),
          // DataCell(
          //   Container(
          //     alignment: Alignment.center, // 중앙 정렬
          //     child: Text(student.attendanceCount.toString(),
          //         style: TextStyle(
          //           fontSize: 35.sp,
          //           color: Colors.black,
          //         )),
          //   ),
          // ),
          DataCell(
            Container(
              alignment: Alignment.center,
              child: isReversed ? Text('${rankList[rank]}',
                  style: TextStyle(
                    fontSize: 35.sp,
                    color: Colors.black,
                  )) : Text('${rankListReverse[rank]}',
                  style: TextStyle(
                    fontSize: 35.sp,
                    color: Colors.black,
                  )),
            ),
          ),
          DataCell(
            Center(
              child: LotteryDeleteButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.surface,
                minimumSize: Size(55.w, 40.h),
                elevation: 4.sw,
                shadowColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            TextButton(
              child: Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColorLight,
                foregroundColor: Theme.of(context).canvasColor,
                minimumSize: Size(55.w, 40.h),
                elevation: 4.sw,
                shadowColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  // 상품 추첨 로직
  Future<void> drawLottery() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(milliseconds: 550)); // gif 1회 반복 시간 대기

    try {
      LotteryStudent winner = await _lotteryViewModel.runLottery();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColorLight,
            title: Text('추첨 완료 🎉', style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 23.sp,
                fontWeight: FontWeight.bold
            )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('"${winner.department} ${winner.name}"',
                  style: TextStyle(
                    fontSize: 22.sp,
                  ),),
                // 이름 가져오기
                SizedBox(height: 16.h),
              ],
            ),
            actions: [  //순서 변경
              LotteryDialogRedrawButton(onPressed: () {
                Navigator.of(context).pop();
                drawLottery(); // 재추첨
              }),
              LotteryDialogRegisterButton(onPressed: () async {
                // 등록 버튼을 눌렀을 때 당첨자를 Firestore에 저장
                await _lotteryViewModel.registerWinner(winner);
                Navigator.of(context).pop();
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
              LotteryDialogRegisterButton(onPressed: () {
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