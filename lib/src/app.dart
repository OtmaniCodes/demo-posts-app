import 'package:date_format/date_format.dart';
import 'package:demo_posts_app/src/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/post.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  Widget postAdder(context, {Post? post}) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    if (post != null) {
      _controller01.text = postProvider.getUserName!;
      _controller02.text = postProvider.getText!;
      postProvider.loadAll(post);
    } else {
      postProvider.loadAll(null);
    }
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
                // setState(
                //   () => _posts.add(
                //     Post(
                //       userName: _controller01.text,
                //       text: _controller02.text,
                //       postId: _posts.length.toString(),
                //       publishDate: DateTime.now().toIso8601String(),
                //     ),
                //   ),
                // );
                postProvider.setUserName = _controller01.text;
                postProvider.setText = _controller02.text;
                _controller01.text = '';
                _controller02.text = '';
                postProvider.savePost();
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
    final postProvider = Provider.of<PostProvider>(context);
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
      body: StreamBuilder<List<Post>>(
          stream: postProvider.getPosts,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).accentColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: ListTile(
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Icon(Icons.edit),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return this.postAdder(context,
                                    post: snapshot.data![index]);
                              },
                            );
                          },
                        ),
                        GestureDetector(
                          child: Icon(Icons.delete),
                          onTap: () {
                            postProvider.removePost(snapshot.data![index].postId!);
                          },
                        ),
                      ],
                    ),
                    title: Text(
                      snapshot.data![index].text!,
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top:8.0),
                      child: Text(
                        "From: ${snapshot.data![index].userName}, on: ${formatDate(DateTime.parse(snapshot.data![index].publishDate!), [
                              MM,
                              ' ',
                              d,
                              ' ',
                              yyyy
                            ])}",
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
