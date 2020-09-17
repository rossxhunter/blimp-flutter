import 'dart:convert';

import 'package:async/async.dart';
import 'package:blimp/services/http.dart';
import 'package:flutter_launcher_icons/constants.dart';

List destinationSuggestions;
List activitySuggestions;
Map currencySuggestions;
Map exploreSuggestions;
List testingSuggestions;
List attractionsSuggestions;
Map searchSuggestions;
List availableFlights;

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
    String attractionsSuggestionsResponse =
        await makeGetRequest("suggestions/attractions", "");
    String searchSuggestionsResponse =
        await makeGetRequest("suggestions/search", "");
    String availableFlightsResponse =
        await makeGetRequest("suggestions/available_flights", "");
    String testingSuggestionsResponse =
        await makeGetRequest("suggestions/testing", "");
    destinationSuggestions = json.decode(destinationSuggestionsResponse);
    activitySuggestions = json.decode(activitySuggestionsResponse);
    currencySuggestions = json.decode(currencySuggestionsResponse);
    exploreSuggestions = json.decode(exploreSuggestionsResponse);
    attractionsSuggestions = json.decode(attractionsSuggestionsResponse);
    searchSuggestions = json.decode(searchSuggestionsResponse);
    availableFlights = json.decode(availableFlightsResponse);
    testingSuggestions = json.decode(testingSuggestionsResponse);
  } on Exception catch (e) {
    print(e);
    throw e;
  }
}

List getDestinationSuggestionsForQuery(
    String query, String point, int originId, int destId) {
  List sug = [];
  destinationSuggestions.forEach((destSug) {
    if (destSug["type"] == "city") {
      if (destSug["cityName"].contains(RegExp(query, caseSensitive: false)) ||
          destSug["countryName"]
              .contains(RegExp(query, caseSensitive: false))) {
        if (availableFlights
                .where((f) => point == "From"
                    ? f["origin"] == destSug["id"] &&
                        (destId == null || f["destination"] == destId)
                    : f["destination"] == destSug["id"] &&
                        f["origin"] == originId)
                .toList()
                .length >
            0) {
          sug.add(destSug);
        }
      }
    } else if (destSug["type"] == "airport") {
      if (destSug["airportName"]
              .contains(RegExp(query, caseSensitive: false)) ||
          destSug["cityName"].contains(RegExp(query, caseSensitive: false))) {
        if (availableFlights
                .where((f) => point == "From"
                    ? f["origin"] == destSug["cityId"] &&
                        (destId == null || f["destination"] == destId)
                    : f["destination"] == destSug["cityId"] &&
                        f["origin"] == originId)
                .toList()
                .length >
            0) {
          sug.add(destSug);
        }
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

List getSearchSuggestionsForQuery(String query) {
  List sug = [];
  List destinations = searchSuggestions["destinations"];
  List hotels = searchSuggestions["hotels"];
  List attractions = searchSuggestions["attractions"];
  destinations.forEach((s) {
    if (s["name"].contains(RegExp(query, caseSensitive: false))) {
      sug.add({"type": "destination", "suggestion": s});
    }
  });
  hotels.forEach((s) {
    if (s["name"].contains(RegExp(query, caseSensitive: false))) {
      sug.add({"type": "hotel", "suggestion": s});
    }
  });
  attractions.forEach((s) {
    if (s["name"].contains(RegExp(query, caseSensitive: false))) {
      sug.add({"type": "attraction", "suggestion": s});
    }
  });
  return sug;
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

Map getExploreSuggestions() {
  return exploreSuggestions;
}

List getAttractionSuggestions() {
  return attractionsSuggestions;
}

List getTestingSuggestions() {
  return testingSuggestions;
}

List getDestinationSuggestions() {
  return destinationSuggestions;
}

Map getSearchSuggesions() {
  return searchSuggestions;
}

List getAvailableFlights() {
  return availableFlights;
}
