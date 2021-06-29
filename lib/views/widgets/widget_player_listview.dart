import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Custom imports
import 'package:companion/models/media.dart';
import 'package:companion/viewmodels/view_model_media.dart';


class PlayerListViewWidget extends StatefulWidget {
  final List<Media> medias;
  final Function callback;

  PlayerListViewWidget({Key? key,
      required this.medias,
      required this.callback}):
    super(key: key);

  @override
  _PlayerListViewWidgetState createState() => _PlayerListViewWidgetState();
}

class _PlayerListViewWidgetState extends State<PlayerListViewWidget> {
  Widget _SongItem(Media media) {
    Media? _media = Provider.of<MediaViewModel>(context).media;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              width: 50,
              height: 50,
              child: Image.network(media.artworkUrl ?? ''),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    media.trackName ?? '',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    media.artistName ?? '',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    media.collectionName ?? '',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
          ),
          if (_media != null &&
              _media.trackName == media.trackName)
            Icon(
              Icons.play_circle_outline,
              color: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildSongItem(int idx) {
    Media media = widget.medias[idx];

    return InkWell(
      onTap: () {
        if (null != media.artistName) {
          widget.callback(media);
        }
      },
      child: _SongItem(media),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        ListView.separated(
          itemBuilder: (BuildContext _, int idx) {
            return _buildSongItem(idx);
          },
          itemCount: widget.medias.length,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) {
            return Divider();
          },
          shrinkWrap: true
        ),
      ]),
    );
  }
}