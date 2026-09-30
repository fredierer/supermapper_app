class Spot {
  final String id;
  final String title;
  final String description;
  final double lat;
  final double lng;

  Spot({
    required this.id,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '', 
      lat : (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }
}