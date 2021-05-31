import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';

class FireStoreServices {
FirebaseFirestore _db = FirebaseFirestore.instance;

  //Read
  Stream<List<Post>> getPosts(){
    return _db.
    collection("posts").snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
  }

  //Upsert
  Future<void> setPost(Post post){
    var options = SetOptions(merge: true);
    return _db.collection("posts").doc(post.postId).set(post.toMap(), options);
  }

  //Delete
  Future<void> deletePost(String postId){
    return _db.collection("posts").doc(postId).delete();
  }

}