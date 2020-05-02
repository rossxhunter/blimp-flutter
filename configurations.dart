import 'model/preferences.dart';
import 'model/properties.dart';

List<Constraint> constraintsConfig = [
  Constraint("trip_type", "Return"),
  Constraint("origin", {"type": "city", "id": 2643743}),
  Constraint("departure_date", "2020-08-27"),
  Constraint("return_date", "2020-08-30"),
  Constraint("travellers",
      Travellers(adults: 2, children: 0, students: 0, oap: 0, infants: 0)),
  Constraint("travel_method", "plane"),
  Constraint("travel_class", "economy"),
  Constraint("accommodation_type", "hotel"),
  Constraint("accommodation_stars", 3),
  Constraint("accommodation_amenities", ["WIFI_IN_ROOM"]),
  Constraint("essential_activities", []),
  Constraint("budget_leq", 1500),
  Constraint("budget_geq", 300),
  Constraint("budget_currency", "GBP"),
];

List<SoftPreference> softPrefConfig = [
  SoftPreference("preferred_activities",
      ["4bf58dd8d48988d181941735", "4bf58dd8d48988d163941735"]),
  SoftPreference("preferred_cuisine", ["french", "indian"]),
  SoftPreference("temperature", 25)
];

List<Preferences> prefsConfig = [
  Preferences(constraintsConfig, softPrefConfig,
      PreferenceScores(culture: 5, learn: 5, relax: 5))
];
