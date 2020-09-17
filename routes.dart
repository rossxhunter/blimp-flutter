import 'package:blimp/screens/results/results.dart';
import 'package:blimp/screens/results/results.dart';
import 'package:flutter/material.dart';

import 'model/preferences.dart';

class ResultsPageRoute {
  Map holiday;
  Preferences preferences;
  ResultsPageRoute(Map holiday, Preferences preferences) {
    this.holiday = holiday;
    this.preferences = preferences;
  }
  ResultsPage page() {
    return ResultsPage(
      destId: holiday["destId"],
      name: holiday["name"],
      countryInfo: holiday["countryInfo"],
      weather: holiday["weather"],
      wiki: holiday["wiki"],
      imageURLs: holiday["imageURLs"],
      itinerary: holiday["itinerary"],
      flights: holiday["travel"],
      accommodation: holiday["accommodation"],
      allFlights: holiday["all_travel"],
      allAccommodation: holiday["all_accommodation"],
      allActivities: holiday["all_activities"],
      preferences: preferences,
    );
  }
}
