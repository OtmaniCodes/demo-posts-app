import 'package:demo_posts_app/src/models/post.dart';
import 'package:demo_posts_app/src/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PostProvider with ChangeNotifier {
  final db = FireStoreServices();
  Uuid uuid = Uuid();
  String? _postId;
  String? _userName;
  String? _text;
  DateTime? _publishDate;

  //Getters
  String? get getUserName => _userName;
  String? get getText => _text;
  DateTime? get getDate => _publishDate;
  Stream<List<Post>> get getPosts => db.getPosts();

  //Setters
  set setText(String value) {
    _text = value;
    notifyListeners();
  }

  set setUserName(String value) {
    _userName = value;
    notifyListeners();
  }

  set setDate(DateTime value) {
    _publishDate = value;
    notifyListeners();
  }

  //Functions
  loadAll(Post? post) {
    if (post != null) {
      _userName = post.userName;
      _text = post.text;
      _publishDate = DateTime.parse(post.publishDate!);
      _postId = post.postId;
    } else {
      _publishDate = DateTime.now();
      _text = null;
      _userName = null;
      _postId = null;
    }
  }

  savePost() {
    if (_postId == null) {
      Post newPost = Post(
        //add
        postId: uuid.v1(),
        publishDate: _publishDate!.toIso8601String(),
        text: _text,
        userName: _userName,
      );
      db.setPost(newPost);
    } else {
      Post editedPost = Post(
          postId: _postId,
          text: _text,
          publishDate: _publishDate!.toIso8601String(),
          userName: _userName);
      db.setPost(editedPost);
    }
  }

  removePost(String id){
    db.deletePost(id);
  }
}
