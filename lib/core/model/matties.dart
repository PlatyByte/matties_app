enum Matties {
  pj,
  bramC,
  bramT,
  ;

  static Matties fromString(String name) =>
      Matties.values.firstWhere((element) => element.name == name);
}
