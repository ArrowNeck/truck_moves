import 'dart:convert';

VehicleDetails vehicleDetailsFromJson(String str) =>
    VehicleDetails.fromJson(json.decode(str));

String vehicleDetailsToJson(VehicleDetails data) => json.encode(data.toJson());

class VehicleDetails {
  List<String> notes;
  List<dynamic> images;
  int id;
  int jobId;
  String? make;
  String? model;
  String? rego;
  String? vin;
  String? year;
  String? colour;
  // int? jobStatus;

  VehicleDetails({
    required this.notes,
    required this.images,
    required this.id,
    required this.jobId,
    this.make,
    this.model,
    this.rego,
    this.vin,
    this.year,
    this.colour,
    // this.jobStatus,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) => VehicleDetails(
        notes: (json["notes"] as List<dynamic>)
            .map((x) => x["noteText"] as String)
            .toList(),
        images: List<dynamic>.from(json["images"].map((x) => x)),
        id: json["id"],
        jobId: json["jobId"],
        make: json["make"],
        model: json["model"],
        rego: json["rego"],
        vin: json["vin"],
        year: json["year"],
        colour: json["colour"],
        // jobStatus: json["jobStatus"],
      );

  Map<String, dynamic> toJson() => {
        "notes": notes,
        "images": List<dynamic>.from(images.map((x) => x)),
        "id": id,
        "jobId": jobId,
        "make": make,
        "model": model,
        "rego": rego,
        "vin": vin,
        "year": year,
        "colour": colour,
        // "jobStatus": jobStatus,
      };
}
