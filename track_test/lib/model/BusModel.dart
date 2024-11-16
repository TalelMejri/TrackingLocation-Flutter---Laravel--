class BusModel {
  int id;
  String name;
  double latitude;
  double longitude;

  BusModel(
      {required this.id,
      required this.name,
      required this.latitude,
      required this.longitude});

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
        id: json["id"],
        latitude: json['latitude'],
        longitude: json['longitude'],
        name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name
    };
  }

  @override
  String toString() {
    return 'BusModel{id: $id, longitude: $longitude, latitude: $latitude, name: $name}';
  }
}
