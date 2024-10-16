import 'package:attendance_check/feature/Home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'Model/model.dart';
import 'ViewModel/viewModel.dart';
import 'widget/button/lottery_delete_button.dart';
import 'widget/button/lottery_dialog_register_button.dart';
import 'widget/button/lottery_dialog_redraw_button.dart';
import 'widget/button/lottery_draw_button.dart';
import 'package:attendance_check/feature/Drawer/drawerScreen.dart';

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('상품 추첨하기', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        elevation: 1,

        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onSurface, size: 30),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(role: widget.role, id: widget.id)));
            }),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                color: Theme.of(context).iconTheme.color,
              );
            },
          ),
        ],
      ),
      endDrawer: DrawerScreen(role: widget.role, id: widget.id),
      body: Column(
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
                  margin: EdgeInsets.fromLTRB(5.w, 3, 3.w, 0),
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
    );
  }

  // 열 생성 함수
  List<DataColumn> createColumns() {
    return [
      DataColumn(
          label: Text("         학과",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("       학번",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("    이름",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("참여 횟수",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold))),
      DataColumn(
          label: Text("",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold))),
      // 삭제 열 추가
    ];
  }

  // Firestore에서 불러온 학부생 데이터를 행으로 변환
  List<DataRow> createRows(List<LotteryStudent> students) {
    return students.map((student) {
      return DataRow(

        cells: [
          DataCell(
            Container(
              alignment: Alignment.center, // 중앙 정렬
              child: Text(student.department, style: TextStyle(fontSize: 28.sp)),
            ),
          ),
          DataCell(
            Container(
              alignment: Alignment.center, // 중앙 정렬
              child: Text(student.studentId, style: TextStyle(fontSize: 28.sp)),
            ),
          ),
          DataCell(
            Container(
              alignment: Alignment.center, // 중앙 정렬
              child: Text(student.name, style: TextStyle(fontSize: 28.sp)),
            ),
          ),
          DataCell(
            Container(
              alignment: Alignment.center, // 중앙 정렬
              child: Text(student.attendanceCount.toString(), style: TextStyle(fontSize: 28.sp)),
            ),
          ),
          DataCell(
            LotteryDeleteButton(

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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
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
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
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

    await Future.delayed(Duration(milliseconds: 3550)); // gif 1회 반복 시간 대기

    try {
      LotteryStudent winner = await _lotteryViewModel.runLottery();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('추첨 완료', style: TextStyle(color: Colors.black, fontSize: 23.sp, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${winner.department}의 ${winner.name}님이 당첨되었습니다!'),
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
