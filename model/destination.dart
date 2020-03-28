import 'properties.dart';

class Holiday {
  Place place;
  Itinerary itinerary;
}

class Itinerary {}

class DestinationResult {
  Place place;
  Travel travel;
  Accommodation accommodation;
  Activities activities;
  Restaurants restaurants;

  DestinationResult(
      {this.place,
      this.travel,
      this.accommodation,
      this.activities,
      this.restaurants});
}

class Travel {}

class Accommodation {}

class Activities {}

class Restaurants {}
