import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Home/homeScreen.dart';
import 'Model/ApproveModel.dart';
import 'ViewModel/ApproveViewModel.dart';
import 'widget/CustomText.dart';

class ApproveListScreen extends StatefulWidget {
  final String role;
  final String id;

  ApproveListScreen({required this.role, required this.id});

  @override
  _ApproveListScreenState createState() => _ApproveListScreenState();
}

class _ApproveListScreenState extends State<ApproveListScreen> {
  final ApproveViewModel _viewModel = ApproveViewModel();
  final ScrollController _scrollController = ScrollController();
  List<Approvemodel> _pendingAdmins = [];
  bool _isLoading = false;
  bool _isRejectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadPendingAdmins(); // 관리자 리스트 로드
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPendingAdmins();
    }
  }

  // Firestore에서 승인 대기 중인 관리자를 가져오는 함수
  Future<void> _loadPendingAdmins() async {
    if (_isLoading || !_viewModel.hasMoreData()) return;

    setState(() {
      _isLoading = true;
    });

    final newAdmins = await _viewModel.fetchPendingAdmins();
    setState(() {
      _pendingAdmins.addAll(newAdmins);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 관리자 카드 UI
  Widget _buildAdminCard(BuildContext context, Approvemodel admin, int index) {
    return Padding(

      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(

        onTap: () => _showDetailsDialog(admin),
        child: Container(
          decoration: _buildCardDecoration(context),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.person, color: Theme
                    .of(context)
                    .colorScheme
                    .inverseSurface, size: 50),
                SizedBox(width: 16),
                _buildAdminInfo(context, admin),
                Spacer(),
                _buildActionButton(context, admin, index),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 관리자 정보 출력
  Widget _buildAdminInfo(BuildContext context, Approvemodel admin) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 5.w,),
        CustomText(id: admin.name, size: 22.sp),
        SizedBox(width: 13.w,),
        Column(
            children: [
              CustomText(id: '학과: ${admin.department}', size: 13.sp),
              CustomText(id: '학번: ${admin.studentId}', size: 13.sp),
            ]
        ),
      ],
    );
  }

  // 승인 및 거절 버튼
  Widget _buildActionButton(BuildContext context, Approvemodel admin,
      int index) {
    return ElevatedButton(
      onPressed: () async {
        if (_isRejectionMode) {
          await _viewModel.rejectAdmin(admin.studentId);
        } else {
          await _viewModel.approveAdmin(admin.studentId, widget.role);
        }
        setState(() {
          _pendingAdmins.removeAt(index); // 승인 또는 거절 후 리스트에서 제거
        });
      },
      child: CustomText(id: _isRejectionMode ? '거절' : '승인', color: Theme
          .of(context)
          .colorScheme
          .scrim, size: 20.sp),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isRejectionMode ?
        Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.secondaryFixedDim,
        shadowColor: Theme
            .of(context)
            .colorScheme
            .onSurface
            .withOpacity(0.7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
      ),
    );
  }

  // 카드 디자인
  BoxDecoration _buildCardDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Theme
            .of(context)
            .secondaryHeaderColor
            .withOpacity(0.8), Theme
            .of(context)
            .primaryColorDark
            .withOpacity(0.8)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.1, 0.9],
      ),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 2,
          offset: Offset(0, 5),
        )
      ],
    );
  }

  // 관리자 상세 정보 다이얼로그
  void _showDetailsDialog(Approvemodel admin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: CustomText(id: '${admin.name} 관리자 정보', size: 18),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(id: '학번: ${admin.studentId}', size: 16),
              CustomText(id: '학과: ${admin.department}', size: 16),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('닫기'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: CustomText(
            id: '관리자 승인 대기 목록',
            size: 20.sp,
            color: Theme.of(context).colorScheme.scrim,
          ),
          centerTitle: true,
          elevation: 1,

          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.scrim,
              size: 25.sp,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(role: widget.role, id: widget.id),
                ),
              );
            },
          ),

          actions: [
            IconButton(
              icon: Icon(
                _isRejectionMode ? Icons.check : Icons.edit,
                color: Theme.of(context).colorScheme.scrim,
                size: 25.sp,
              ),
              onPressed: () {
                setState(() {
                  _isRejectionMode = !_isRejectionMode;
                });
              },
            ),
          ],
        )
,
        body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme
                  .of(context)
                  .colorScheme
                  .onInverseSurface,
              Theme
                  .of(context)
                  .primaryColorLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.9],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 30.h), // AppBar와 body 사이에 간격 추가
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _pendingAdmins.length + 1,
                itemBuilder: (context, index) {
                  if (index == _pendingAdmins.length) {
                    return _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox.shrink();
                  }
                  final admin = _pendingAdmins[index];
                  return _buildAdminCard(context, admin, index);
                },
              ),
            ),
            if (_isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}