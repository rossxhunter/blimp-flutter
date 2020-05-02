import 'dart:convert';

import 'package:async/async.dart';
import 'package:blimp/services/http.dart';

List destinationSuggestions;
List activitySuggestions;
Map currencySuggestions;
List exploreSuggestions;
List testingSuggestions;

Future<void> getSuggestions() async {
  try {
    String destinationSuggestionsResponse =
        await makeGetRequest("suggestions/destinations", "");
    String activitySuggestionsResponse =
        await makeGetRequest("suggestions/activities", "");
    String currencySuggestionsResponse =
        await makeGetRequest("suggestions/currencies", "");
    String exploreSuggestionsResponse =
        await makeGetRequest("suggestions/explore", "");
    String testingSuggestionsResponse =
        await makeGetRequest("suggestions/testing", "");
    destinationSuggestions = json.decode(destinationSuggestionsResponse);
    activitySuggestions = json.decode(activitySuggestionsResponse);
    currencySuggestions = json.decode(currencySuggestionsResponse);
    exploreSuggestions = json.decode(exploreSuggestionsResponse);
    testingSuggestions = json.decode(testingSuggestionsResponse);
  } on Exception catch (e) {
    print(e);
    throw e;
  }
}

List getDestinationSuggestionsForQuery(String query) {
  List sug = [];
  destinationSuggestions.forEach((destSug) {
    if (destSug["type"] == "city") {
      if (destSug["cityName"].contains(RegExp(query, caseSensitive: false)) ||
          destSug["countryName"]
              .contains(RegExp(query, caseSensitive: false))) {
        sug.add(destSug);
      }
    } else if (destSug["type"] == "airport") {
      if (destSug["airportName"]
              .contains(RegExp(query, caseSensitive: false)) ||
          destSug["cityName"].contains(RegExp(query, caseSensitive: false))) {
        sug.add(destSug);
      }
    }
  });
  return sug;
}

String getActivityFromId(String id) {
  return activitySuggestions.where((a) => a["id"] == id).toList()[0]["plural"];
}

String getActivityIconFromId(String id) {
  return activitySuggestions.where((a) => a["id"] == id).toList()[0]["icon"];
}

List getActivitySuggestionsForQuery(String query) {
  List sug = [];
  activitySuggestions.forEach((actSug) {
    if (actSug["name"].contains(RegExp(query, caseSensitive: false))) {
      sug.add(actSug);
    }
  });
  return sug;
}

List getSpecificActivitySuggestionsForQuery(List activities, String query) {
  if (query == "") {
    return [];
  }
  List sug = [];
  activities.forEach((actSug) {
    if (actSug["name"].contains(RegExp(query, caseSensitive: false)) ||
        actSug["category"].contains(RegExp(query, caseSensitive: false))) {
      sug.add(actSug);
    }
  });
  return sug;
}

Map getCurrencySuggestions() {
  return currencySuggestions;
}

List getExploreSuggestions() {
  return exploreSuggestions;
}

List getTestingSuggestions() {
  return testingSuggestions;
}
