import 'dart:convert';

import 'package:blimp/model/preferences.dart';
import 'package:blimp/services/clicks.dart';
import 'package:blimp/services/user.dart';
import 'package:http/http.dart';

String encodePrefs(List prefs) {
  Map finalMap = {};
  for (var pref in prefs) {
    finalMap.addAll(pref.toJson());
  }
  return jsonEncode(finalMap);
}

Future<Map> getItinerariesForEvaluation(int destId) async {
  var response;
  try {
    response = await makeGetRequest(
        "itineraries_for_evaluation/" + destId.toString(), "");
  } catch (e) {
    print(e);
    throw e;
  }
  Map decodedResponse = json.decode(response);
  clicksId = decodedResponse["clicks_id"];
  return decodedResponse;
}

Future<List> getEvaluationItineraryFromActivities(
    List activities, int day, int destId, List window) async {
  String activitiesJson = jsonEncode(activities).replaceAll("&", "%26");
  String windowJson = jsonEncode(window);
  String params = "activities=$activitiesJson&day=$day&window=$windowJson";
  var itinerary;
  try {
    itinerary = await makeGetRequest(
        "itinerary_for_evaluation/" + destId.toString(), params);
  } catch (e) {
    print(e);
    throw e;
  }
  return json.decode(itinerary);
}

Future<Map> getCityDetailsFromId(int cityId) async {
  var details;
  String currency = isLoggedIn ? currentUser["currency"] ?? "GBP" : "GBP";
  int origin = isLoggedIn ? currentUser["origin"] ?? 2643743 : 2643743;
  var params = "currency=$currency&origin=${origin.toString()}";
  try {
    details = await makeGetRequest("city_details/" + cityId.toString(), params);
  } catch (e) {
    print(e);
    throw e;
  }
  return json.decode(details);
}

Future<List> getItineraryFromActivities(List activities, int day, Map travel,
    Map accommodation, Preferences preferences, List window, int destId) async {
  String activitiesJson = jsonEncode(activities).replaceAll("&", "%26");
  String windowJson = jsonEncode(window);
  String travelJson = jsonEncode(travel);
  String accommodationJson = jsonEncode(accommodation);
  String constraints = encodePrefs(preferences.constraints);
  String softPrefs = encodePrefs(preferences.softPreferences);
  String prefScores = jsonEncode(preferences.preferenceScores);
  String params =
      "destId=$destId&activities=$activitiesJson&day=$day&window=$windowJson&travel=$travelJson&accommodation=$accommodationJson&constraints=$constraints&softprefs=$softPrefs&pref_scores=$prefScores";
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

Future<List> getItineraryFromChange(
    Preferences prefs, Map travel, Map accommodation, int destId) async {
  String constraints = encodePrefs(prefs.constraints);
  String softPrefs = encodePrefs(prefs.softPreferences);
  String prefScores = jsonEncode(prefs.preferenceScores);
  String travelJson = jsonEncode(travel);
  String accommodationJson = jsonEncode(accommodation);
  String params =
      "destination_id=$destId&travel=$travelJson&accommodation=$accommodationJson&constraints=$constraints&softprefs=$softPrefs&pref_scores=$prefScores&should_register_clicks=$testingSwitchOn";
  var itinerary;
  try {
    itinerary = await makeGetRequest("itinerary_from_change", params);
  } catch (e) {
    print(e);
    throw e;
  }
  List decodedResponse = json.decode(itinerary);
  return decodedResponse;
}

Future<Map> getHoliday(Preferences prefs) async {
  String constraints = encodePrefs(prefs.constraints);
  String softPrefs = encodePrefs(prefs.softPreferences);
  String prefScores = jsonEncode(prefs.preferenceScores);
  String params =
      "constraints=$constraints&softprefs=$softPrefs&pref_scores=$prefScores&should_register_clicks=$testingSwitchOn";
  var holiday;
  try {
    holiday = await makeGetRequest("holiday", params);
  } catch (e) {
    print(e);
    throw e;
  }
  Map decodedResponse = json.decode(holiday);
  if (testingSwitchOn) {
    clicksId = decodedResponse["clicks_id"];
  }
  return json.decode(decodedResponse["holiday"]);
}

Future<void> registerClick(String click, String mode, Map metadata) async {
  if (testingSwitchOn == true || mode == "evaluation") {
    try {
      await makePostRequest("clicks/$clicksId/$click",
          {"mode": mode, "metadata": jsonEncode(metadata)});
    } catch (e) {
      print(e);
      throw e;
    }
  }
}

Future<void> saveHoliday(String userId, Map holiday) async {
  var newValue;
  try {
    newValue = await makePostRequest("holiday", {
      "type": "saved",
      "user": userId,
      "destination": holiday["destination"].toString(),
      "departure_date": holiday["departure_date"],
      "return_date": holiday["return_date"],
    });
  } catch (e) {
    print(e);
    throw e;
  }
  List decodedResponse = json.decode(newValue);
  currentUser["trips"]["saved"] = decodedResponse;
}

Future<List> deleteHoliday(String userId, int holidayId, String type) async {
  var newValue;
  try {
    newValue = await makeDeleteRequest("holiday/$type/$userId/$holidayId", {});
  } catch (e) {
    print(e);
    throw e;
  }
  List decodedResponse = json.decode(newValue);
  return decodedResponse;
}

Future<List> addNewTraveller() async {
  var newValue;
  try {
    newValue = await makePostRequest(
        "user/${currentUser["id"].toString()}/traveller", {});
  } catch (e) {
    print(e);
    throw e;
  }
  List decodedResponse = json.decode(newValue);
  return decodedResponse;
}

Future<void> incrementSearches(String userId) async {
  var newValue;
  try {
    newValue = await makePutRequest("user/searches/$userId", {});
  } catch (e) {
    print(e);
    throw e;
  }
  Map decodedResponse = json.decode(newValue);
  currentUser["searches"] = decodedResponse["searches"];
  currentUser["score"] = decodedResponse["score"];
}

Future<List> removeTraveller(int travellerId) async {
  var newValue;
  try {
    newValue = await makeDeleteRequest(
        "user/${currentUser["id"].toString()}/traveller/$travellerId", {});
  } catch (e) {
    print(e);
    throw e;
  }
  List decodedResponse = json.decode(newValue);
  return decodedResponse;
}

Future<Map> updateUserDetails(Map values) async {
  var newValue;
  try {
    newValue =
        await makePutRequest("user/${currentUser["id"].toString()}", values);
  } catch (e) {
    print(e);
    throw e;
  }
  Map decodedResponse = json.decode(newValue);
  return decodedResponse;
}

Future<List> updateTraveller(int travellerId, Map values) async {
  var newValue;
  try {
    newValue = await makePutRequest(
        "user/${currentUser["id"].toString()}/traveller/$travellerId", values);
  } catch (e) {
    print(e);
    throw e;
  }
  List decodedResponse = json.decode(newValue);
  return decodedResponse;
}

Future<void> addNewUserDetails(
    String id, String email, String firstName, String lastName) async {
  try {
    await makePostRequest("user", {
      "id": id,
      "email": email,
      "first_name": firstName,
      "last_name": lastName
    });
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<Map> getUserDetails(String id) async {
  var userDetails;
  try {
    userDetails = await makeGetRequest("user/$id", "");
  } catch (e) {
    print(e);
    throw e;
  }
  return json.decode(userDetails);
}

Future<dynamic> makePutRequest(String path, Map body) async {
  String url = '${_hostname()}/$path';
  Map<String, String> headers = {
    "credentials": 'same-origin',
  };
  Response response =
      await put(url, headers: headers, body: body).catchError((e) {
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

Future<dynamic> makeDeleteRequest(String path, Map<String, String> body) async {
  String url = '${_hostname()}/$path';
  Map<String, String> headers = {
    "credentials": 'same-origin',
  };
  Response response = await delete(url, headers: headers).catchError((e) {
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

Future<dynamic> makePostRequest(String path, Map<String, String> body) async {
  String url = '${_hostname()}/$path';
  Map<String, String> headers = {
    "credentials": 'same-origin',
  };
  Response response =
      await post(url, headers: headers, body: body).catchError((e) {
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

Future<String> makeGetRequest(String path, String params) async {
  String url = '${_hostname()}/$path?$params';
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
  // return "http://blimp-dev-env.eu-west-2.elasticbeanstalk.com";
}
