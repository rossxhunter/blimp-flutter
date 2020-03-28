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

Future<Map> getItinerary(Preferences prefs, int destId) async {
  String constraints = encodePrefs(prefs.constraints);
  String softPrefs = encodePrefs(prefs.softPreferences);
  String prefScores = jsonEncode(prefs.preferenceScores);
  String params =
      "destination=$destId&constraints=$constraints&softprefs=$softPrefs&pref_scores=$prefScores";
  var itinerary;
  try {
    itinerary = await makeGetRequest("itinerary", params);
  } on Exception catch (e) {
    print(e);
    throw e;
  }
  return json.decode(itinerary);
}

Future<Map> getDestination(Preferences prefs) async {
  String constraints = encodePrefs(prefs.constraints);
  String softPrefs = encodePrefs(prefs.softPreferences);
  String prefScores = jsonEncode(prefs.preferenceScores);
  String params =
      "constraints=$constraints&softprefs=$softPrefs&pref_scores=$prefScores";
  String destination;
  try {
    destination = await makeGetRequest('destination', params);
  } on Exception catch (e) {
    print(e);
    throw e;
  }
  return json.decode(destination);
}

Future<String> makeGetRequest(String path, String params) async {
  String url = '${_hostname()}/$path?$params';
  print(url);
  Response response = await get(url).catchError((e) {
    print(e);
    throw e;
  });
  if (response.statusCode != 200) {
    throw Exception(json.decode(response.body)["message"]);
  }
  return response.body;
}

String _hostname() {
  return "http://localhost:5000";
}
