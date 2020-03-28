import 'package:meta/meta.dart';

class Place {
  String name;
  String type;
  int id;

  Place({this.name, this.id, this.type});

  Map<String, String> toJson() => {'type': type, "id": id.toString()};
}

class DateRange {
  DateTime startDate;
  DateTime endDate;

  DateRange(DateTime startDate, DateTime endDate) {
    this.startDate = startDate;
    this.endDate = endDate;
  }

  Map<String, String> toJson() => {
        'startDate': startDate.toString(),
        'endDate': endDate.toString(),
      };
}

class Travellers {
  int adults;
  int children;
  int students;
  int oap;

  Travellers(
      {this.adults = 0, this.children = 0, this.students = 0, this.oap = 0});

  Map<String, String> toJson() => {
        'adults': adults.toString(),
        'children': children.toString(),
        'students': students.toString(),
        'oap': oap.toString(),
      };
}

enum TravelMethod { plane, train, car, bus }

enum TravelClass { first, economy }

enum AccommodationType { hotel, hostel, apartment }

class LocationCircle {
  double latitude;
  double longitude;
  int radius;

  LocationCircle({this.latitude, this.longitude, this.radius});

  Map<String, String> toJson() => {
        'latitude': latitude.toString(),
        'latitude': longitude.toString(),
        'radius': radius.toString()
      };
}

class SpecificLocation {
  SpecificLocation();
}

enum Amenity { bathroom, spa, wifi, parking }

class Activity {
  String name;

  Activity(String name) {
    this.name = name;
  }

  String toJson() => name;
}

class TimeBounds {
  int time;
  int margin;

  TimeBounds(int time, int margin) {
    this.time = time;
    this.margin = margin;
  }

  Map<String, String> toJson() =>
      {'time': time.toString(), 'margin': margin.toString()};
}

enum Currency { gbp, usb, eur }

class Money {
  int amount;
  Currency currency;

  Money(int amount, Currency currency) {
    this.amount = amount;
    this.currency = currency;
  }

  Map<String, String> toJson() =>
      {'amount': amount.toString(), 'currency': currency.toString()};
}

enum Cuisine { british, american, indian, chinese, italian, french }
