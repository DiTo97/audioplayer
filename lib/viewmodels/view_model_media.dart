import 'package:flutter/cupertino.dart';

// Custom imports
import 'package:companion/models/api_response.dart';
import 'package:companion/models/media.dart';

import 'package:companion/repositories/repository_media.dart';


class MediaViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');
  ApiResponse get apiResponse => _apiResponse;

  Media? _media;
  Media? get media => _media;

  Future<void> fetchMediasByArtist(String artistName) async {
    _apiResponse = ApiResponse.loading("Fetching $artistName's medias...");
    notifyListeners();

    try {
      List<Media> artistMedias = await MediaRepository()
          .fetchMedias(artistName);

      _apiResponse = ApiResponse.completed(artistMedias);
    } catch (e) {
      _apiResponse = ApiResponse.error(e.toString());
    }

    notifyListeners();
  }

  void selectMedia(Media? media) {
    _media = media;
    notifyListeners();
  }
}
