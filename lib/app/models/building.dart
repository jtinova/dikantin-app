class Building {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  Building({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'],
      name: json['name'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
    );
  }
}
