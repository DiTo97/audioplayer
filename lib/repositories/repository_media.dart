// Custom imports
import 'package:companion/models/media.dart';
import 'package:companion/services/service_base.dart';
import 'package:companion/services/service_media.dart';


class MediaRepository {
  BaseService _mediaService = MediaService();

  Future<List<Media>> fetchMedias(String query) async {
    dynamic responseJson = await _mediaService.getResponse(query);
    final dataJson = responseJson['results'] as List;

    return dataJson.map((d) =>
        Media.fromJson(d)).toList();
  }
}
