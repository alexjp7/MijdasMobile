class Assessment {
  String id;
  String a_number;
  String name;
  String maxMark;
  String isActive;

  Assessment({
    this.id,
    this.a_number,
    this.name,
    this.maxMark,
    this.isActive,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) => new Assessment(
    id: json["id"],
    a_number: json["a_number"],
    name: json["name"],
    maxMark: json["max_mark"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "a_number": a_number,
    "name": name,
    "max_mark": maxMark,
    "isActive":isActive,
  };
}