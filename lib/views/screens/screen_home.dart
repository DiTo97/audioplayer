import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Custom imports
import 'package:companion/views/widgets/media/listview.dart';
import 'package:companion/views/widgets/media/searchbox.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Companion')
      ),
      body: Column(
        children: <Widget>[
          Padding(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: MediaSearchbox()
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
          Expanded(
            child: MediaListView()
          ),
        ],
      )
    );
  }
}
