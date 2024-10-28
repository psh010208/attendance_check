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
      selectedFriendId = friendId;
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
        actions: [
          AddFriendButton(currentUserId: widget.studentId),
        ],
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
      ),
      endDrawer: DrawerScreen(
        role: '학부생',
        id: selectedFriendId,
        isFriendView: true
        ,
      ),
      drawerScrimColor: Colors.black.withOpacity(0.5),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Builder(
            builder: (context) => ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: CircleAvatar(
                child: Text(friendList[index].name[0]),
              ),
              title: Text(friendList[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(friendList[index].department),
              trailing: TextButton(
                onPressed: () => removeFriend(friendList[index].studentId),
                child: Text('삭제', style: TextStyle(color: Colors.red)),
              ),
              onTap: () => openFriendDrawer(context, friendList[index].studentId),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(pendingRequests[index].name[0]),
            ),
            title: Text(pendingRequests[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(pendingRequests[index].department),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => acceptFriendRequest(pendingRequests[index].studentId),
                  child: Text('수락', style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () => declineFriendRequest(pendingRequests[index].studentId),
                  child: Text('거절', style: TextStyle(color: Colors.red)),
                ),
              ],
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
}
