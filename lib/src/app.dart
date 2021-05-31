import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Post> _posts = [];

  late TextEditingController _controller01;
  late TextEditingController _controller02;

  @override
  void initState() {
    super.initState();
    _controller01 = TextEditingController();
    _controller02 = TextEditingController();
  }

  @override
  void dispose() {
    _controller01.dispose();
    _controller02.dispose();
    super.dispose();
  }

  Widget postAdder(context) {
    return Dialog(
      backgroundColor: Theme.of(context).primaryColor,
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).accentColor)),
              child: TextField(
                controller: _controller01,
                decoration: InputDecoration(hintText: "Your Name"),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).accentColor)),
              child: TextField(
                controller: _controller02,
                decoration:
                    InputDecoration(hintText: "Tell The World How You Feel"),
              ),
            ),
            SizedBox(height: 15.0),
            MaterialButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                setState(
                  () => _posts.add(
                    Post(
                      userName: _controller01.text,
                      text: _controller02.text,
                      postId: _posts.length,
                      publishDate: DateTime.now(),
                    ),
                  ),
                );
                _controller01.text = '';
                _controller02.text = '';
                Navigator.pop(context);
              },
              child: Text(
                "Publish",
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Demo Posts App".toUpperCase(),
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return this.postAdder(context);
                },
              );
            },
            icon: Icon(
              Icons.add_outlined,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_posts[index].text),
            subtitle: Text("From: ${_posts[index].userName}"),
          );
        },
      ),
    );
  }
}
