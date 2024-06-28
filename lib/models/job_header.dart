import 'dart:convert';

JobHeader jobHeaderFromJson(String str) => JobHeader.fromJson(json.decode(str));

String jobHeaderToJson(JobHeader data) => json.encode(data.toJson());

class JobHeader {
  int id;
  String pickupLocation;
  String dropOfLocation;
  VehicleNavigation? vehicleNavigation;
  DateTime pickupDate;
  int status;

  JobHeader({
    required this.id,
    required this.pickupLocation,
    required this.dropOfLocation,
    required this.vehicleNavigation,
    required this.pickupDate,
    required this.status,
  });

  factory JobHeader.fromJson(Map<String, dynamic> json) => JobHeader(
        id: json["Id"],
        pickupLocation: json["PickupLocation"],
        dropOfLocation: json["DropOfLocation"],
        vehicleNavigation: json["VehicleNavigation"] == null
            ? null
            : VehicleNavigation.fromJson(json["VehicleNavigation"]),
        pickupDate: json["PickupDate"] == null
            ? DateTime.now()
            : DateTime.parse(json["PickupDate"]),
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PickupLocation": pickupLocation,
        "DropOfLocation": dropOfLocation,
        "VehicleNavigation": vehicleNavigation?.toJson(),
        "PickupDate": pickupDate.toIso8601String(),
        "Status": status,
      };
}

class VehicleNavigation {
  int id;
  int jobId;
  String make;
  String model;
  String rego;
  String vin;
  String year;
  String colour;

  VehicleNavigation({
    required this.id,
    required this.jobId,
    required this.make,
    required this.model,
    required this.rego,
    required this.vin,
    required this.year,
    required this.colour,
  });

  factory VehicleNavigation.fromJson(Map<String, dynamic> json) =>
      VehicleNavigation(
        id: json["Id"],
        jobId: json["JobId"],
        make: json["Make"],
        model: json["Model"],
        rego: json["Rego"],
        vin: json["Vin"],
        year: json["Year"],
        colour: json["Colour"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "JobId": jobId,
        "Make": make,
        "Model": model,
        "Rego": rego,
        "Vin": vin,
        "Year": year,
        "Colour": colour,
      };
}
