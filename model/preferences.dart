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
  int action;
  int party;
  int sport;
  int food;
  int nature;
  int shopping;
  int romantic;
  int family;

  PreferenceScores(
      {this.culture,
      this.learn,
      this.relax,
      this.action,
      this.party,
      this.sport,
      this.food,
      this.nature,
      this.shopping,
      this.romantic,
      this.family});

  Map<String, dynamic> toJson() => {
        'culture': culture,
        'learn': learn,
        'relax': relax,
        'action': action,
        'party': party,
        'sport': sport,
        'food': food,
        'nature': nature,
        'shopping': shopping,
        'romantic': romantic,
        'family': family
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
