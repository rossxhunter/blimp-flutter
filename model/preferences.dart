class Preferences {
  List<Constraint> constraints;
  List<SoftPreference> softPreferences;
  PreferenceScores preferenceScores;

  Preferences(List<Constraint> constraints,
      List<SoftPreference> softPreferences, PreferenceScores preferenceScores) {
    this.constraints = constraints;
    this.softPreferences = softPreferences;
    this.preferenceScores = preferenceScores;
  }
}

class Constraint {
  String property;
  dynamic value;

  Constraint(String property, dynamic value) {
    this.property = property;
    this.value = value;
  }

  Map<String, dynamic> toJson() => {property: value};
}

class SoftPreference {
  String property;
  dynamic value;

  SoftPreference(String property, dynamic value) {
    this.property = property;
    this.value = value;
  }

  Map<String, dynamic> toJson() => {property: value};
}

class PreferenceScores {
  int culture;
  int active;
  int nature;
  int shopping;
  int food;
  int nightlife;

  PreferenceScores({
    this.culture,
    this.active,
    this.nature,
    this.shopping,
    this.food,
    this.nightlife,
  });

  Map<String, dynamic> toJson() => {
        'culture': culture,
        'active': active,
        'nature': nature,
        'shopping': shopping,
        'food': food,
        'nightlife': nightlife,
      };
}

class Property {
  String name;

  Property(String name) {
    this.name = name;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

// enum Relation { lt, gt, leq, geq, eq, neq }
