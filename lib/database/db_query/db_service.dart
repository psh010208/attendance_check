import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> add(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
    } catch (e) {
      print('Error adding document to $collection: $e');
    }
  }

  Future<void> update(String collection, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(docId).update(data);
    } catch (e) {
      print('Error updating document in $collection: $e');
    }
  }

  Future<void> delete(String collection, String docId) async {
    try {
      await _firestore.collection(collection).doc(docId).delete();
    } catch (e) {
      print('Error deleting document from $collection: $e');
    }
  }

  Future<List<Map<String, dynamic>>> get(String collection) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collection).get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching documents from $collection: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getDocumentById(String collection, String docId) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection(collection).doc(docId).get();
      return docSnapshot.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching document from $collection with ID $docId: $e');
      return null;
    }
  }
}