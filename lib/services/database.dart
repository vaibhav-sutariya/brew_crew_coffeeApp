import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  // collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future<void> updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    // Use doc.data() instead of doc.data
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Brew(
      name: data['name'] ?? '',
      strength: data['strength'] ?? 0,
      sugars: data['sugars'] ?? '0',
    );
  }).toList();
}

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
  // Use snapshot.data() instead of snapshot.data
  Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

  return UserData(
    uid: uid,
    name: data['name'],
    sugars: data['sugars'],
    strength: data['strength'],
  );
}

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
      .map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

}