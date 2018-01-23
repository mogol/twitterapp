import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new TweetList(),
    );
  }
}

class TweetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Tweet> tweets = Tweet.all();

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

  static List<Tweet> all() => new List.generate(
        10,
        (i) => new Tweet(user: "User $i", text: "Tweet $i", date: "${i}h"),
      );
}
