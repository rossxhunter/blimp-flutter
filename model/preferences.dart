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
  int learn;
  int relax;

  PreferenceScores({this.culture, this.learn, this.relax});

  Map<String, dynamic> toJson() =>
      {'culture': culture, 'learn': learn, 'relax': relax};
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
