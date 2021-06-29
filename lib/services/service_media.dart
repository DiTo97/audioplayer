import 'dart:io';

import 'package:http/http.dart' as http;

// Custom imports
import 'package:companion/exceptions/exception_http.dart';
import 'package:companion/services/service_base.dart';


class MediaService extends BaseService {
  final String baseUrl = "https://itunes.apple.com/search?term=";

  @override
  Future getResponse(String query) async {
    dynamic responseJson;

    try {
      final httpResponse = await http.get(Uri.parse(baseUrl + query));
      responseJson = decodeResponse(httpResponse);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }

    return responseJson;
  }
}
