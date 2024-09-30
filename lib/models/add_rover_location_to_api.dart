class AddRoverLocationModel {
  final List<RoverLocations>? roverLocations;

  AddRoverLocationModel({
    this.roverLocations,
  });

  AddRoverLocationModel.fromJson(Map<String, dynamic> json)
      : roverLocations = (json['rover_locations'] as List?)
            ?.map((dynamic e) =>
                RoverLocations.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'rover_locations': roverLocations?.map((e) => e.toJson()).toList()};
}

class RoverLocations {
  final double? lat;
  final double? lng;

  RoverLocations({
    this.lat,
    this.lng,
  });

  RoverLocations.fromJson(Map<String, dynamic> json)
      : lat = json['lat'] as double?,
        lng = json['lng'] as double?;

  Map<String, dynamic> toJson() => {'lat': lat, 'lng': lng};
}
