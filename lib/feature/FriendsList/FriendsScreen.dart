import 'package:flutter/material.dart';
import ' widget/Dialog/AddFriendButton.dart';
import 'Model/FriendModel.dart';
import 'ViewModel/FriendViewModel.dart';

class FriendsScreen extends StatefulWidget {
  final String studentId;

  const FriendsScreen({Key? key, required this.studentId}) : super(key: key);

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
      friendList = await _friendViewModel.fetchFriendList(widget.studentId);
      pendingRequests = await _friendViewModel.fetchPendingRequests(widget.studentId);
    } catch (e) {
      errorMessage = "Error fetching friend data: $e";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // 친구 요청 수락
  Future<void> acceptFriendRequest(String friendId) async {
    await _friendViewModel.acceptFriendRequest(widget.studentId, friendId);
    fetchFriendData();
  }

  // 친구 요청 거절
  Future<void> declineFriendRequest(String friendId) async {
    await _friendViewModel.removePendingRequest(widget.studentId, friendId);
    fetchFriendData();
  }

  // 친구 삭제
  Future<void> removeFriend(String friendId) async {
    await _friendViewModel.removeFriend(widget.studentId, friendId);
    fetchFriendData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 관리'),
        actions: [AddFriendButton(currentUserId: widget.studentId)],
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: '친구 목록'), Tab(text: '요청 대기 목록')],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : TabBarView(
        controller: _tabController,
        children: [buildFriendList(), buildPendingRequests()],
      ),
    );
  }

  Widget buildFriendList() {
    return friendList.isNotEmpty
        ? ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: friendList.length,
      itemBuilder: (context, index) {
        return buildFriendCard(friendList[index], () => removeFriend(friendList[index].studentId), '삭제');
      },
    )
        : Center(child: Text('친구가 없습니다.'));
  }

  Widget buildPendingRequests() {
    return pendingRequests.isNotEmpty
        ? ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return buildFriendCard(pendingRequests[index],
              () => acceptFriendRequest(pendingRequests[index].studentId),
          '수락',
          declineAction: () => declineFriendRequest(pendingRequests[index].studentId),
        );
      },
    )
        : Center(child: Text('요청 대기 중인 친구가 없습니다.'));
  }

  Widget buildFriendCard(FriendModel friend, VoidCallback action, String actionLabel, {VoidCallback? declineAction}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: CircleAvatar(child: Text(friend.name[0])),
        title: Text(friend.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(friend.department),
        trailing: declineAction == null
            ? TextButton(onPressed: action, child: Text(actionLabel, style: TextStyle(color: Colors.red)))
            : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed: action, child: Text(actionLabel, style: TextStyle(color: Colors.green))),
            TextButton(onPressed: declineAction, child: Text('거절', style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }
}
