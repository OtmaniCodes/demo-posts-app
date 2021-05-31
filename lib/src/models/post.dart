class Post {
  final String? postId;
  final String? userName;
  final String? text;
  final String? publishDate;
  Post({
    required this.postId,
    required this.userName,
    required this.text,
    required this.publishDate,
  });

  factory Post.fromJson(Map<String, dynamic> data) {
    return Post(
      postId: data["postId"],
      userName: data["userName"],
      text: data["text"],
      publishDate: data["publishDate"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "postId": this.postId,
      "userName": this.userName,
      "text": this.text,
      "publishDate": this.publishDate,
    };
  }
}
