import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DatabaseWidget(),
    );
  }
}

class DatabaseWidget extends StatefulWidget {
  @override
  _DatabaseWidgetState createState() => new _DatabaseWidgetState();
}

class _DatabaseWidgetState extends State<DatabaseWidget> {
  List<Tweet> _tweets = [];

  @override
  void initState() {
    super.initState();

    final database = FirebaseDatabase.instance;
    database.reference().child("tweets").once().then((snapshot) {
      final Map<String, dynamic> data = snapshot.value;
      final tweets = data.values.map((t) => new Tweet(text: t["text"]));
      setState(() => _tweets = tweets.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new TweetList(
      tweets: _tweets,
    );
  }
}

class TweetList extends StatelessWidget {
  TweetList({this.tweets});

  final List<Tweet> tweets;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Timeline"),
      ),
      body: new ListView.builder(
        itemCount: tweets.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text("${tweets[index].user}  ${tweets[index].date}"),
            subtitle: new Text(tweets[index].text),
          );
        },
      ),
    );
  }
}

class Tweet {
  Tweet({this.user, this.text, this.date});

  final String user;
  final String text;
  final String date;
}
