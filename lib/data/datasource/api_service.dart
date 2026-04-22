import 'dart:convert';
import 'dart:io';

import 'package:movrev/core/utils/utils.dart';
import 'package:movrev/data/datasource/api_exception.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future getResponse(String url, Map<String, String>? header) async {
    dynamic jsonResponse;
    try {
      final response = await http.get(Uri.parse(url), headers: header);
      jsonResponse = returnResponse(response, url: url);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return jsonResponse;
  }

  dynamic returnResponse(http.Response response, {String? url = ""}) {
    // Log response for easy debugging
    debug("URL : $url, RESPONSE CODE :${response.statusCode}");
    debug("BODY : ${response.body}");
    debug("HEADER : ${response.headers}");
    debug("");
    debug("");

    // ONLY 200 are considered successful
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body.toString());
      return jsonResponse;
    } else {
      // Handle status codes other than 200 (including 401 Unauthorized)
      var res = json.decode(response.body.toString());
      // TMDB puts error messages in 'status_message'
      var message = res['status_message'] ?? 'Terjadi kesalahan pada server';

      // MUST USE 'throw' to be caught by catch in the Repository/BLoC
      // Note: Use the appropriate Exception class in your api_exception.dart file.
      // If you have an ErrorException class, make sure it says: throw ErrorException(message);
      throw FetchDataException(message);
    }
  }
}
