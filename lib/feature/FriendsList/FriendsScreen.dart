import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import ' widget/Dialog/AddFriendButton.dart';
import '../ApproveList/widget/CustomText.dart';
import '../Drawer/drawerScreen.dart';
import '../Home/homeScreen.dart';
import 'Model/FriendModel.dart';
import 'ViewModel/FriendViewModel.dart';

class FriendsScreen extends StatefulWidget {
  final String studentId;
  final String role;
  final String id;

  const FriendsScreen({Key? key, required this.studentId, required this.role, required this.id}) : super(key: key);

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FriendViewModel _friendViewModel = FriendViewModel();

  List<FriendModel> friendList = [];
  List<FriendModel> pendingRequests = [];
  bool isLoading = true;
  String errorMessage = '';
  String selectedFriendId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    selectedFriendId = widget.studentId; // 자신의 ID로 초기화
    fetchFriendData();
  }

  Future<void> fetchFriendData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      final fetchedFriends = await _friendViewModel.fetchFriendList(widget.studentId);
      final fetchedPendingRequests = await _friendViewModel.fetchPendingRequests(widget.studentId);

      setState(() {
        friendList = fetchedFriends;
        pendingRequests = fetchedPendingRequests;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "친구 데이터를 불러오는 중 오류가 발생했습니다: $e";
        isLoading = false;
      });
    }
  }

  // Method to open friend drawer
  void openFriendDrawer(BuildContext context, String friendId) {
    setState(() {
      selectedFriendId = friendId; // 친구 ID로 업데이트
    });
    Scaffold.of(context).openEndDrawer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .scrim,
                  size: 25.sp),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(role: widget.role, id: widget.id),
                  ),
                );
              },
            ),Spacer(),
            CustomText(id : '친구 관리',size: 20.sp, color: Theme
                .of(context)
                .colorScheme
                .scrim),
            Spacer(),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                '친구 목록',
                style: TextStyle(
                  fontSize: 16, // 원하는 두께
                    color: Theme
                        .of(context)
                        .colorScheme
                        .scrim // 원하는 색상
                ),
              ),
            ),
            Tab(
              child: Text(
                '요청 대기 목록',
                style: TextStyle(
                  fontSize: 16,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .scrim
                ),
              ),
            ),
          ],
        ),
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
      endDrawer: Drawer(
        backgroundColor: Colors.black, // 배경색을 검은색으로 설정
        child: DrawerScreen(
          role: '학부생',
          id: selectedFriendId,
          isFriendView: true,
        ),
      ),

      floatingActionButton: AddFriendButton(currentUserId: widget.studentId),
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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : TabBarView(
          controller: _tabController,
          children: [
            buildFriendList(),
            buildPendingRequests(),

        ],
        ),
      ),
    );
  }

  Widget buildFriendList() {
    return friendList.isNotEmpty
        ? ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: friendList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Container(
            decoration: _buildCardDecoration(context),
            child: Builder(
              builder: (context) => ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: CircleAvatar(
                  child: Text(friendList[index].name[0]),
                ),
                title: Text(friendList[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(friendList[index].department),
                trailing: ElevatedButton(
                  onPressed: () => removeFriend(friendList[index].studentId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface, // 버튼 배경색 설정
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1), // 버튼 패딩 설정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
                    ),
                    elevation: 3, // 그림자 높이 설정
                    shadowColor: Theme.of(context).primaryColorDark, // 그림자 색상 설정
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // 버튼 크기를 텍스트와 아이콘에 맞게 최소화
                    children: [
                      Icon(Icons.delete, color: Colors.red), // 삭제 아이콘과 색상
                      SizedBox(width: 1), // 아이콘과 텍스트 사이의 간격
                      Text('삭제', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                onTap: () => openFriendDrawer(context, friendList[index].studentId

                ),
              ),
            ),
          ),
        );
      },
    )
        : Center(child: Text('아직 목록이 추가 되지 않았습니다.'));
  }

  Widget buildPendingRequests() {
    return pendingRequests.isNotEmpty
        ? ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Container(
            decoration: _buildCardDecoration(context),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: CircleAvatar(
                child: Text(pendingRequests[index].name[0]),
              ),
              title: Text(pendingRequests[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(pendingRequests[index].department),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => acceptFriendRequest(pendingRequests[index].studentId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface, // 버튼 배경색 설정
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1), // 버튼 패딩 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
                      ),
                      elevation: 5, // 그림자 높이 설정 (값이 높을수록 진해짐)
                      shadowColor: Theme.of(context).primaryColorDark, // 그림자 색상 설정
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // 버튼 크기를 텍스트와 아이콘에 맞게 최소화
                      children: [
                        Icon(Icons.check, color: Colors.green), // 아이콘과 색상
                        SizedBox(width: 1), // 아이콘과 텍스트 사이의 간격
                        Text('수락', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                  SizedBox(width: 3,),
                  ElevatedButton(
                    onPressed: () => declineFriendRequest(pendingRequests[index].studentId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface, // 버튼 배경색 설정
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1), // 버튼 패딩 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 버튼 모서리 둥글게
                      ),
                      elevation: 5, // 그림자 높이 설정 (값이 높을수록 진해짐)
                      shadowColor: Theme.of(context).primaryColorDark, // 그림자 색상 설정
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // 버튼 크기를 텍스트와 아이콘에 맞게 최소화
                      children: [
                        Icon(Icons.close, color: Colors.red), // 거절 아이콘과 색상
                        SizedBox(width: 1), // 아이콘과 텍스트 사이의 간격
                        Text('거절', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    )
        : Center(child: Text('요청 대기 중인 친구가 없습니다.'));
  }

  Future<void> removeFriend(String friendId) async {
    await _friendViewModel.removeFriend(widget.studentId, friendId);
    fetchFriendData();
  }

  Future<void> acceptFriendRequest(String friendId) async {
    await _friendViewModel.acceptFriendRequest(widget.studentId, friendId);
    fetchFriendData();
  }

  Future<void> declineFriendRequest(String friendId) async {
    await _friendViewModel.removePendingRequest(widget.studentId, friendId);
    fetchFriendData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        ),
      ],
    );
  }
}
