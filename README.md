
# Plan

* Setup
  * Install Flutter 
    * Guide for [windows](https://flutter.io/setup-windows/)
    * Guide for [linux](https://flutter.io/setup-linux/)
    * Guide for [macOS](https://flutter.io/setup-macos/)
  * [IDE Setup](https://flutter.io/ide-setup/)
## Step 0. Setup the project
  * Create new Flutter project in IntelliJ IDEA
    * File -> New -> Project... -> Flutter -> Use name `twitter` and organization `com.example.flutter`
  * Run the app
    * Run -> Run 'main.dart' 
## Step 1. Build simple list of Tweets
* Replace content of main.dart with
```dart
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
@override
  Widget build(BuildContext context) {
    return new Container();
  }
}
```   
  
* Add Tweet model
  
```dart
class Tweet {
  
  Tweet({this.user, this.text, this.date});
  
  final String user;
  final String text;
  final String date;
}
```

* Add widget for the list
```dart
class TweetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Tweet> tweets = [];

    return new Scaffold(
      body: new ListView.builder(
        itemCount: tweets.length,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text(tweets[index].user + tweets[index].date),
            subtitle: new Text(tweets[index].text),
          );
        },
      ),
    );
  }

```
* Update return of build function in MyApp class to 
```dart
@override
Widget build(BuildContext context) {
  return new MaterialApp(home: new TweetList());
}
```
* Add function to Tweet class
```dart
static List<Tweet> all() => new List.generate(
    10,
    (i) => new Tweet(user: "User $i", text: "Tweet $i", date: "${i}h"),
);
```
* Update build function of TweetList to use mocks
```dart
final List<Tweet> tweets = Tweet.all();
```
* Add navbar to Scaffold 
```dart
return new Scaffold(
      appBar: new AppBar(
        title: new Text("Timeline"),
      ),
      ...
    );
```

## Step 2. Integrate Firebase
 * Install [Firebase Database plugin](https://pub.dartlang.org/packages/firebase_database#-installing-tab-)
 * Pass tweets as a parameter to TweetList class
 ```dart
 class TweetList extends StatelessWidget {
  TweetList({this.tweets});

  final List<Tweet> tweets;
  ...
 ```
 * Add Database widget
 ```dart
class DatabaseWidget extends StatefulWidget {
  @override
  _DatabaseWidgetState createState() => new _DatabaseWidgetState();
}

class _DatabaseWidgetState extends State<DatabaseWidget> {
  @override
  Widget build(BuildContext context) {
    final tweets = Tweet.all();
    return new TweetList(
      tweets: tweets,
    );
  }
}
 ```
 * Update MyApp widget to use DatabaseWidget
 ```dart
home: new DatabaseWidget(),
 ```
 * Update DatabaseWidget to generate mock once
 ```dart
 class DatabaseWidget extends StatefulWidget {
  @override
  _DatabaseWidgetState createState() => new _DatabaseWidgetState();
}

class _DatabaseWidgetState extends State<DatabaseWidget> {

  List<Tweet> _tweets;

  @override
  void initState() {
    super.initState();
    _tweets = Tweet.all();
  }

  @override
  Widget build(BuildContext context) {
    return new TweetList(
      tweets: _tweets,
    );
  }
}
 ```
 * Add config files
    * iOS
      * Open the project in Xcode
      * Add [google-services.plist](https://drive.google.com/open?id=1KeobfyMf4G3lTir8pcIGvScnr59VBWKK) to the project
    * [Android](https://firebase.google.com/docs/android/setup#add_the_sdk)
      * Copy [google-services.json](https://drive.google.com/open?id=1QLNaPdNPgmpgT1yZ_gT1mV1OWHORs3ip) to `android/app` folder
      * Add rules to your root-level `android/build.gradle` file 
```
buildscript {
    // ...
    dependencies {
        classpath 'com.android.tools.build:gradle:3.0.1'
        classpath 'com.google.gms:google-services:3.1.1'
    }
}

allprojects {
    // ...
    repositories {
        // ...
        maven {
            url "https://maven.google.com" // Google's Maven repository
        }
    }
}
```
* Add rules to module `android/app/build.gradle` file
```
...
// ADD THIS AT THE BOTTOM
apply plugin: 'com.google.gms.google-services'
```
 > If you have issue with wrong gradle version, update `distributionUrl` to `https\://services.gradle.org/distributions/gradle-4.1-all.zip` in gradle-wrapper.properties
 
 * Add import to main.dart `import 'package:firebase_database/firebase_database.dart';`
 * Update _DatabaseWidgetState to 
```dart
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
```
