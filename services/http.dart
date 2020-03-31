import 'dart:convert';

import 'package:blimp/model/preferences.dart';
import 'package:http/http.dart';

String encodePrefs(List prefs) {
  Map finalMap = {};
  for (var pref in prefs) {
    finalMap.addAll(pref.toJson());
  }
  return jsonEncode(finalMap);
}

Future<Map> getHoliday(Preferences prefs) async {
  String constraints = encodePrefs(prefs.constraints);
  String softPrefs = encodePrefs(prefs.softPreferences);
  String prefScores = jsonEncode(prefs.preferenceScores);
  String params =
      "constraints=$constraints&softprefs=$softPrefs&pref_scores=$prefScores";
  var itinerary;
  try {
    itinerary = await makeGetRequest("holiday", params);
  } on Exception catch (e) {
    print(e);
    throw e;
  }
  return json.decode(itinerary);
}

Future<String> makeGetRequest(String path, String params) async {
  String url = '${_hostname()}/$path?$params';
  print(url);
  Response response = await get(url).catchError((e) {
    print(e);
    throw e;
  });
  if (response.statusCode != 200) {
    try {
      throw Exception(json.decode(response.body)["message"]);
    } on Exception {
      throw Exception("Unexpected error");
    }
  }
  return response.body;
}

String _hostname() {
  return "http://localhost:5000";
}
