import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/FriendModel.dart';

class FriendViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 친구 목록 가져오기
  Future<List<FriendModel>> fetchFriendList(String currentUserId) async {
    final userDocId = "${currentUserId}-학부생";
    final userDoc = await _firestore.collection('user').doc(userDocId).get();

    if (userDoc.exists) {
      List<String> friendIds = List<String>.from(userDoc.data()?['friend'] ?? []);
      return await Future.wait(friendIds.map((friendId) => fetchFriendData(friendId)));
    } else {
      return [];
    }
  }

  // 요청 대기 목록 가져오기
  Future<List<FriendModel>> fetchPendingRequests(String currentUserId) async {
    final userDocId = "${currentUserId}-학부생";
    final userDoc = await _firestore.collection('user').doc(userDocId).get();

    if (userDoc.exists) {
      List<String> pendingIds = List<String>.from(userDoc.data()?['pending_requests'] ?? []);
      return await Future.wait(pendingIds.map((requestId) => fetchFriendData(requestId)));
    } else {
      return [];
    }
  }

  // 특정 친구의 데이터를 가져오는 함수
  Future<FriendModel> fetchFriendData(String friendId) async {
    final friendDocId = "${friendId}-학부생";
    final friendDoc = await _firestore.collection('user').doc(friendDocId).get();

    if (friendDoc.exists) {
      return FriendModel.fromFirestore(friendDoc.data()!);
    } else {
      throw Exception('Friend not found');
    }
  }

  // 친구 추가
  Future<void> addFriend(String currentUserId, String friendId) async {
    final userDocId = "${currentUserId}-학부생";
    final friendDocId = "${friendId}-학부생";

    final userDocRef = _firestore.collection('user').doc(userDocId);
    final friendDocRef = _firestore.collection('user').doc(friendDocId);

    await _firestore.runTransaction((transaction) async {
      // 먼저 모든 읽기 작업을 수행
      final userSnapshot = await transaction.get(userDocRef);
      final friendSnapshot = await transaction.get(friendDocRef);

      if (userSnapshot.exists && friendSnapshot.exists) {
        // 읽기 작업 완료 후, 각각의 친구 목록을 업데이트
        List<String> userFriends = List<String>.from(userSnapshot.data()?['friend'] ?? []);
        List<String> friendFriends = List<String>.from(friendSnapshot.data()?['friend'] ?? []);

        // 현재 사용자가 친구 목록에 friendId를 포함하지 않는 경우 추가
        if (!userFriends.contains(friendId)) {
          userFriends.add(friendId);
          transaction.update(userDocRef, {'friend': userFriends});
        }

        // friendId 사용자의 친구 목록에 currentUserId를 포함하지 않는 경우 추가
        if (!friendFriends.contains(currentUserId)) {
          friendFriends.add(currentUserId);
          transaction.update(friendDocRef, {'friend': friendFriends});
        }
      }
    });
  }

  // 친구 요청 보내기
  Future<void> sendFriendRequest(String targetUserId, String currentUserId) async {
    final targetUserDocId = "${targetUserId}-학부생";
    final targetUserDocRef = _firestore.collection('user').doc(targetUserDocId);

    final snapshot = await targetUserDocRef.get();
    if (!snapshot.exists) {
      throw Exception("User does not exist");
    }

    await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(targetUserDocRef);
      List<String> pendingRequests = List<String>.from(userSnapshot.data()?['pending_requests'] ?? []);

      if (!pendingRequests.contains(currentUserId)) {
        pendingRequests.add(currentUserId);
        transaction.update(targetUserDocRef, {'pending_requests': pendingRequests});
      }
    });
  }

// FriendViewModel에 있는 친구 요청 수락 메서드
  Future<void> acceptFriendRequest(String currentUserId, String friendId) async {
    // 친구 추가
    await addFriend(currentUserId, friendId);

    // 요청 대기 목록에서 친구 요청 제거
    await removePendingRequest(currentUserId, friendId);
    await removePendingRequest(friendId, currentUserId); // 상대방의 대기 목록에서도 제거
  }

  // 친구 삭제
  Future<void> removeFriend(String currentUserId, String friendId) async {
    final userDocId = "${currentUserId}-학부생";
    final userDocRef = _firestore.collection('user').doc(userDocId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDocRef);
      if (snapshot.exists) {
        List<String> friends = List<String>.from(snapshot.data()?['friend'] ?? []);
        if (friends.contains(friendId)) {
          friends.remove(friendId);
          transaction.update(userDocRef, {'friend': friends});
        }
      }
    });
  }

  // 요청 대기 목록에서 친구 요청 제거
  Future<void> removePendingRequest(String currentUserId, String friendId) async {
    final userDocId = "${currentUserId}-학부생";
    final userDocRef = _firestore.collection('user').doc(userDocId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(userDocRef);
      if (snapshot.exists) {
        List<String> pendingRequests = List<String>.from(snapshot.data()?['pending_requests'] ?? []);
        if (pendingRequests.contains(friendId)) {
          pendingRequests.remove(friendId);
          transaction.update(userDocRef, {'pending_requests': pendingRequests});
        }
      }
    });
  }
}
