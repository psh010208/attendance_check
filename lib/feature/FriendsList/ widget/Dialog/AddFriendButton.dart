import 'package:flutter/material.dart';
import '../../ViewModel/FriendViewModel.dart';

class AddFriendButton extends StatefulWidget {
  final String currentUserId;

  const AddFriendButton({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _AddFriendButtonState createState() => _AddFriendButtonState();
}

class _AddFriendButtonState extends State<AddFriendButton> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FriendViewModel _friendViewModel = FriendViewModel();

  // 친구 추가 요청 메서드
  Future<void> sendFriendRequest() async {
    String friendId = _studentIdController.text.trim();
    String friendName = _nameController.text.trim();
print('친구 아이디 $friendId');
    if (friendId.isEmpty || friendName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('학번과 이름을 모두 입력해주세요.')),
      );
      return;
    }

    try {
      // FriendViewModel의 sendFriendRequest 메서드를 호출하여 요청 대기 목록에 추가
      await _friendViewModel.sendFriendRequest(friendId, widget.currentUserId);
      print('친구 아이디 $friendId');

      print(friendId);
      Navigator.of(context).pop(); // 다이얼로그 닫기
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('친구 요청이 성공적으로 전송되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('친구 추가 요청 중 오류가 발생했습니다.$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('친구 추가 요청'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _studentIdController,
                    decoration: InputDecoration(labelText: '학번'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: '이름'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('취소'),
                ),
                TextButton(
                  onPressed: sendFriendRequest,
                  child: Text('친구 추가 요청'),
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.group_add), // group_add 아이콘 추가
    );
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
