import 'dart:convert';

import 'package:http/http.dart' as http;

// Custom imports
import 'package:companion/exceptions/exception_http.dart';


abstract class BaseService {
  Future<dynamic> getResponse(String url);

  dynamic decodeResponse(http.Response httpResponse) {
    int statusCode = httpResponse.statusCode;

    switch (statusCode) {
      case 200:
        return jsonDecode(httpResponse.body);
      case 400:
        throw BadRequestException(httpResponse.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(httpResponse.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Failed to connect to the server' +
                ' with status code: $statusCode');
    }
  }
}
