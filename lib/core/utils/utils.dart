import 'package:flutter/foundation.dart';

export 'movie_grouping_utils.dart';

void debug(dynamic response){
  if(kDebugMode){
    print(response);
  }
}

String formatRuntime(int minutes) {
  final int hour = minutes ~/ 60;
  final int mins = minutes % 60;

  if(hour > 0){
    return "${hour}h ${mins}m";
  }
  return "${mins}m";
}