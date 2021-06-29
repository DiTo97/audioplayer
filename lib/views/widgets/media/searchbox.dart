import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Custom imports
import 'package:companion/viewmodels/view_model_media.dart';


class MediaSearchbox extends StatelessWidget {
  final _teInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: _teInputController,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "Enter an artist's name",
          isCollapsed: true,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ),
        onChanged: (artistName) {},
        onSubmitted: (artistName) {
          if (artistName.isNotEmpty) {
            Provider.of<MediaViewModel>(context, listen: false)
                .selectMedia(null);

            Provider.of<MediaViewModel>(context, listen: false)
                .fetchMediasByArtist(artistName);
          }
        },
        textAlignVertical: TextAlignVertical.center,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).accentColor.withAlpha(50)
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.0),
    );
  }
}
