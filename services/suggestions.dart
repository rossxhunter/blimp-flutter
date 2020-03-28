import 'dart:convert';

import 'package:blimp/services/http.dart';

List destinationSuggestions;
List activitySuggestions;

void getSuggestions() async {
  try {
    String destinationSuggestionsResponse =
        await makeGetRequest("suggestions", "suggestion=destinations");
    String activitySuggestionsResponse =
        await makeGetRequest("suggestions", "suggestion=activities");
    destinationSuggestions = json.decode(destinationSuggestionsResponse);
    activitySuggestions = json.decode(activitySuggestionsResponse);
  } on Exception catch (e) {
    print(e);
    throw e;
  }
}

List getDestinationSuggestionsForQuery(String query) {
  List sug = [];
  destinationSuggestions.forEach((destSug) {
    if (destSug["heading"].contains(RegExp(query, caseSensitive: false)) ||
        destSug["subheading"].contains(RegExp(query, caseSensitive: false))) {
      sug.add(destSug);
    }
  });
  return sug;
}

List getActivitySuggestionsForQuery(String query) {
  List sug = [];
  activitySuggestions.forEach((actSug) {
    if (actSug["heading"].contains(RegExp(query, caseSensitive: false))) {
      sug.add(actSug);
    }
  });
  return sug;
}
