import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Custom imports
import 'package:companion/models/api_response.dart';
import 'package:companion/models/media.dart';
import 'package:companion/viewmodels/view_model_media.dart';
import 'package:companion/views/widgets/widget_player.dart';
import 'package:companion/views/widgets/widget_player_listview.dart';


class MediaListView extends StatefulWidget {
  @override
  _MediaListViewState createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  @override
  Widget build(BuildContext context) {
    ApiResponse apiResponse = Provider.of<MediaViewModel>(context)
                                      .apiResponse;

    List<Media>? medias = apiResponse.data as List<Media>?;

    switch (apiResponse.status) {
      case Status.loading:
        return Center(child: CircularProgressIndicator());

      case Status.completed:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 8,
              child: PlayerListViewWidget(
                callback: (m) =>
                    Provider.of<MediaViewModel>(context, listen: false)
                            .selectMedia(m),
                medias: medias!
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: PlayerWidget(
                  callback: () {
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        );

      case Status.error:
        return Center(
          child: Text('Something wrong happened.\n'
                      'Please try again later!'),
        );

      case Status.initial:
      default:
        return Center(
          child: Text('Search for songs by artist.'),
        );
    }
  }
}
