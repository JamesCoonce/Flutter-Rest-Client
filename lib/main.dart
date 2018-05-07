import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_startup/user_manager.dart';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: new UsersListView(),
      //routes: <String, WidgetBuilder>{
      //  '/userslist': (BuildContext context) => new UsersListView(),
      //  '/usersprofile': (BuildContext context) => new UserProfile(),
      //},
    );
  }

}

class UsersListView extends StatefulWidget {
  @override
  createState() => UsersListState();
}

class UsersListState extends State<UsersListView>{
  final _users = fetchUsers();

  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list)),
        ],
      ),
      body: _builduserlistview(),
    );
  }

  Widget _builduserlistview() {
    return new FutureBuilder(
      future: fetchUsers(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if (!snapshot.hasData)
          return new Container();
        List<User> content = snapshot.data;
        return new ListView.builder(
            padding: const EdgeInsets.all(16.0),
            // The itemBuilder callback is called once per suggested word pairing,
            // and places each suggestion into a ListTile row.
            // For even rows, the function adds a ListTile row for the word pairing.
            // For odd rows, the function adds a Divider widget to visually
            // separate the entries. Note that the divider may be difficult
            // to see on smaller devices.
            itemCount: content.length,
            itemBuilder: (context, i) {
              // Add a one-pixel-high divider widget before each row in theListView.
              //if (i.isOdd) return new Divider();

              // The syntax "i ~/ 2" divides i by 2 and returns an integer result.
              // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
              // This calculates the actual number of word pairings in the ListView,
              // minus the divider widgets.
              //final index = i ~/ 2;
              // If you've reached the end of the available word pairings...
              //\*if (index >= _users.length) {
              // ...then generate 10 more and add them to the suggestions list.
              //_suggestions.addAll(generateWordPairs().take(10));
              //}
              //return _buildRow(_suggestions[index]);
              return _buildRow(content[i]);
            }
        );
      },
    );
  }

  Widget _buildRow(User user) {

    var tile = new ListTile(
      title: new Text(
        user.name,
        style: _biggerFont,
      ),
      onTap: () {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (context) => new UserProfile(user)
            )
        );
      },
    );

    var children = <Widget>[
      tile,
      new Divider(height: 10.0, color: Colors.black,)
    ];

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

}

class UserProfile extends StatefulWidget {
  final User user;

  UserProfile(this.user){
    if(user == null){
      throw new ArgumentError("user of userProfile cannot be null. "
          "Received: '$user'");
    }
  }

  @override
  createState() => new UserProfileState(user);
}

class UserProfileState extends State<UserProfile>{
  final User user;

  UserProfileState(this.user);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("User Profile"),
      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text('Go back!' + user.name),
        ),
      ),
    );
  }
}
