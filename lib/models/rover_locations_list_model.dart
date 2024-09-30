class RoverLocationsListModel {
  final String? id;
  final List<RoverLocation>? roverLocations;

  RoverLocationsListModel({
    this.id,
    this.roverLocations,
  });

  RoverLocationsListModel.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        roverLocations = (json['rover_locations'] as List?)
            ?.map((dynamic e) =>
                RoverLocation.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        '_id': id,
        'rover_locations': roverLocations?.map((e) => e.toJson()).toList()
      };
}

class RoverLocation {
  final double? lat;
  final double? lng;

  RoverLocation({
    this.lat,
    this.lng,
  });

  RoverLocation.fromJson(Map<String, dynamic> json)
      : lat = (json['lat'] as num?)?.toDouble(),
        lng = (json['lng'] as num?)?.toDouble();

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}
