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

Future<List> getItineraryFromActivities(List<Map> activities, int day,
    Map travel, Map accommodation, Preferences preferences) async {
  String activitiesJson = jsonEncode(activities);
  String travelJson = jsonEncode(travel);
  String accommodationJson = jsonEncode(accommodation);
  String constraints = encodePrefs(preferences.constraints);
  String softPrefs = encodePrefs(preferences.softPreferences);
  String prefScores = jsonEncode(preferences.preferenceScores);
  String params =
      "activities=$activitiesJson&day=$day&travel=$travelJson&accommodation=$accommodationJson&constraints=$constraints&softprefs=$softPrefs&pref_scores=$prefScores";
  var itinerary;
  try {
    itinerary = await makeGetRequest("itinerary", params);
  } catch (e) {
    print(e);
    throw e;
  }
  return json.decode(itinerary);
}

Future<Map> getHolidayWithFeedback(Preferences prefs, Map feedback) async {
  String constraints = encodePrefs(prefs.constraints);
  String softPrefs = encodePrefs(prefs.softPreferences);
  String prefScores = jsonEncode(prefs.preferenceScores);
  String feedbackJson = jsonEncode(feedback);
  String params =
      "constraints=$constraints&softprefs=$softPrefs&pref_scores=$prefScores&feedback=$feedbackJson";
  var itinerary;
  try {
    itinerary = await makeGetRequest("holiday_from_feedback", params);
  } catch (e) {
    print(e);
    throw e;
  }
  return json.decode(itinerary);
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
  } catch (e) {
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
    Map decodedResponseBody;
    try {
      decodedResponseBody = json.decode(response.body);
    } catch (e) {
      throw Exception("Unexpected Error");
    }
    throw Exception(decodedResponseBody["message"]);
  }
  return response.body;
}

String _hostname() {
  return "http://localhost:5000";
}
