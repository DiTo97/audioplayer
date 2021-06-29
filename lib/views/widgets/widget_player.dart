import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Custom imports
import 'package:companion/models/media.dart';
import 'package:companion/viewmodels/view_model_media.dart';


enum PlayerState { stopped, playing, paused }

final playerMode = PlayerMode.MEDIA_PLAYER;
final routeState = PlayingRouteState.SPEAKERS;
final rewindJump = 10; // sec


class PlayerWidget extends StatefulWidget {
  final Function callback;

  PlayerWidget({Key? key,
      required this.callback}):
    super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String? _prevTrack;

  late AudioPlayer _audioPlayer;

  Duration? _trackDuration;
  Duration? _trackPosition;

  PlayerState _playerState = PlayerState.stopped;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;

  _PlayerWidgetState();

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Media? media = Provider.of<MediaViewModel>(context).media;
    _stopAndPlay(media);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => null,
              icon: Icon(
                Icons.fast_rewind,
                size: 25.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).accentColor
                    : Color(0xFF787878),
              ),
            ),
            ClipOval(
                child: Container(
                  color: Theme.of(context).accentColor.withAlpha(30),
                  width: 50.0,
                  height: 50.0,
                  child: IconButton(
                    onPressed: () {
                      if (_isPlaying) {
                        widget.callback();
                        _pauseMedia();
                      } else {
                        if (media != null) {
                          widget.callback();
                          _playMedia(media);
                        }
                      }
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 30.0,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                )),
            IconButton(
              onPressed: () => null,
              icon: Icon(
                Icons.fast_forward,
                size: 25.0,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).accentColor
                    : Color(0xFF787878),
              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 12.0, right: 12.0),
              child: Stack(
                children: [
                  Slider(
                      onChanged: (v) {
                        final positionMillis = v * _trackDuration!.inMilliseconds;
                        _audioPlayer.seek(Duration(
                            milliseconds: positionMillis.round()));
                      },
                      value: (_trackPosition != null &&
                          _trackDuration != null &&
                          _trackPosition!.inMilliseconds > 0 &&
                          _trackPosition!.inMilliseconds < _trackDuration!.inMilliseconds)
                        ? _trackPosition!.inMilliseconds
                            / _trackDuration!.inMilliseconds : 0.0),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: playerMode);
    _audioPlayer.playingRouteState = routeState;

    _durationSubscription =
        _audioPlayer.onDurationChanged.listen((d) =>
            setState(() => _trackDuration = d));

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) =>
            setState(() => _trackPosition = p));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((e) {
          setState(() {
            _playerState = PlayerState.stopped;
            _trackPosition = _trackDuration;
          });
        });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');

      setState(() {
        _playerState = PlayerState.stopped;

        _trackDuration = Duration(seconds: 0);
        _trackPosition = Duration(seconds: 0);
      });
    });
  }

  void _stopAndPlay(Media? media) {
    if (media != null
        && _prevTrack != media.trackName) {
      _prevTrack = media.trackName;
      _trackPosition = null;

      _stopMedia();
      _playMedia(media);
    }
  }

  Future<int> _playMedia(Media media) async {
    final playPosition = (_trackPosition != null &&
        _trackDuration != null &&
        _trackPosition!.inMilliseconds > 0 &&
        _trackPosition!.inMilliseconds < _trackDuration!.inMilliseconds)
      ? _trackPosition : null;

    final apStatus = await _audioPlayer.play(
        media.previewUrl!, position: playPosition);

    if (apStatus == 1)
      setState(() =>
          _playerState = PlayerState.playing);

    // setPlaybackRate should be called after _audioPlayer.play() or _audioPlayer.resume(),
    // or anytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);

    return apStatus;
  }

  Future<int> _pauseMedia() async {
    final apStatus = await _audioPlayer.pause();

    if (apStatus == 1)
      setState(() =>
        _playerState = PlayerState.paused);

    return apStatus;
  }

  Future<int> _stopMedia() async {
    final apStatus = await _audioPlayer.stop();

    if (apStatus == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _trackPosition = Duration();
      });
    }

    return apStatus;
  }
}