import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAPI {
  final CollectionReference _bookmarks =
      FirebaseFirestore.instance.collection('bookmarks');
  final User? _user = FirebaseAuth.instance.currentUser;

  Stream getSnapshot() {
    return _bookmarks.snapshots();
  }

  addToBookmark(movieId) {
    if (_user != null) {
      _bookmarks.add({"uID": _user!.uid, "mID": movieId}).catchError((error) {
        print("Failed to load bookmark : $error");
      });
    }
  }

  cancelBookmark(movieId) {
    if (_user != null) {
      _bookmarks
          .where("uID", isEqualTo: _user!.uid)
          .where("mID", isEqualTo: movieId)
          .get()
          .then((value) {
        var uId = value.docs;
        for (var docId in uId) {
          _bookmarks.doc(docId.id).delete();
        }
      });
    }
  }
}
