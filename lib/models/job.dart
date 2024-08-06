import 'dart:convert';

import 'package:truck_moves/models/vehicle_details.dart';

List<Job> jobFromJson(String str) =>
    List<Job>.from(json.decode(str).map((x) => Job.fromJson(x)));

String jobToJson(List<Job> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Job {
  int id;
  int status;
  String pickupLocation;
  String dropOfLocation;
  String? pickupCoordinates;
  String? dropOfCoordinates;
  DateTime? pickupDate;
  DateTime? estimatedDeliveryDate;
  int? vehicleId;
  double? totalDistance;
  int? totalDrivingTime;
  int? estimatedDaysofTravel;
  PreDepartureChecklist? preDepartureChecklist;
  VehicleDetails? vehicleDetails;
  List<WayPoint> wayPoints;
  List<Trailer> trailers;
  List<Leg> legs;

  Job({
    required this.id,
    required this.status,
    required this.pickupLocation,
    required this.dropOfLocation,
    this.pickupCoordinates,
    this.dropOfCoordinates,
    this.pickupDate,
    this.estimatedDeliveryDate,
    this.vehicleId,
    this.totalDistance,
    this.totalDrivingTime,
    this.estimatedDaysofTravel,
    this.preDepartureChecklist,
    this.vehicleDetails,
    required this.wayPoints,
    required this.trailers,
    required this.legs,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"],
        status: json["status"],
        pickupLocation: json["pickupLocation"] ?? " -",
        dropOfLocation: json["dropOfLocation"] ?? " -",
        pickupCoordinates: json["pickupCoordinates"],
        dropOfCoordinates: json["dropOfCoordinates"],
        pickupDate: json["pickupDate"] != null
            ? DateTime.parse(json["pickupDate"])
            : null,
        estimatedDeliveryDate: json["estimatedDeliveryDate"] != null
            ? DateTime.parse(json["estimatedDeliveryDate"])
            : null,
        vehicleId: json["vehicleId"],
        totalDistance: json["totalDistance"]?.toDouble(),
        totalDrivingTime: json["totalDrivingTime"],
        estimatedDaysofTravel: json["estimatedDaysofTravel"],
        preDepartureChecklist: (json["checklists"] as List).isEmpty
            ? null
            : PreDepartureChecklist.fromJson(
                (json["checklists"] as List<dynamic>)
                    .firstWhere((item) => item["isPre"] == true)),
        vehicleDetails: json["vehicleNavigation"] != null
            ? VehicleDetails.fromJson(json["vehicleNavigation"])
            : null,
        wayPoints: List<WayPoint>.from(
            json["wayPoints"].map((x) => WayPoint.fromJson(x))),
        trailers: List<Trailer>.from(
            json["trailers"].map((x) => Trailer.fromJson(x))),
        legs: List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "pickupLocation": pickupLocation,
        "dropOfLocation": dropOfLocation,
        "pickupCoordinates": pickupCoordinates,
        "dropOfCoordinates": dropOfCoordinates,
        "pickupDate": pickupDate?.toIso8601String(),
        "estimatedDeliveryDate": estimatedDeliveryDate?.toIso8601String(),
        "vehicleId": vehicleId,
        "totalDistance": totalDistance,
        "totalDrivingTime": totalDrivingTime,
        "estimatedDaysofTravel": estimatedDaysofTravel,
        "preDepartureChecklist": preDepartureChecklist,
        "wayPoints": List<dynamic>.from(wayPoints.map((x) => x.toJson())),
        "trailers": List<dynamic>.from(trailers.map((x) => x.toJson())),
        "legs": List<dynamic>.from(legs.map((x) => x.toJson())),
      };
}

class Leg {
  int id;
  int jobId;
  // int legNumber;
  String? startLocation;
  String? endLocation;
  // int status;
  bool acknowledged;

  Leg({
    required this.id,
    required this.jobId,
    // required this.legNumber,
    this.startLocation,
    this.endLocation,
    // required this.status,
    required this.acknowledged,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        id: json["id"],
        jobId: json["jobId"],
        // legNumber: json["legNumber"],
        startLocation: json["startLocation"] ?? "",
        endLocation: json["endLocation"] ?? "",
        // status: json["status"],
        acknowledged: json["acknowledged"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobId": jobId,
        // "legNumber": legNumber,
        "startLocation": startLocation,
        "endLocation": endLocation,
        // "status": status,
        "acknowledged": acknowledged,
      };
}

class Trailer {
  HookupTypeNavigation hookupTypeNavigation;
  List<String> notes;
  List<dynamic> images;
  int id;
  int hookupType;
  int jobId;
  String hookupLocation;
  String dropOffLocation;
  String rego;
  String type;
  String? hookupCoordinate;
  String? dropoffCoordinate;

  Trailer(
      {required this.hookupTypeNavigation,
      required this.notes,
      required this.images,
      required this.id,
      required this.hookupType,
      required this.jobId,
      required this.hookupLocation,
      required this.dropOffLocation,
      required this.rego,
      required this.type,
      this.hookupCoordinate,
      this.dropoffCoordinate});

  factory Trailer.fromJson(Map<String, dynamic> json) => Trailer(
        hookupTypeNavigation:
            HookupTypeNavigation.fromJson(json["hookupTypeNavigation"]),
        notes: (json["notes"] as List<dynamic>)
            .map((x) => (x["noteText"]))
            .toList()
            .whereType<String>()
            .toList(),
        images: List<dynamic>.from(json["images"].map((x) => x)),
        id: json["id"],
        hookupType: json["hookupType"],
        jobId: json["jobId"],
        hookupLocation: json["hookupLocation"],
        dropOffLocation: json["dropOffLocation"],
        rego: json["rego"] ?? " -",
        type: json["type"] ?? " -",
        hookupCoordinate: json["hookupCoordinate"],
        dropoffCoordinate: json["dropoffCoordinate"],
      );

  Map<String, dynamic> toJson() => {
        "hookupTypeNavigation": hookupTypeNavigation.toJson(),
        "notes": notes,
        "images": List<dynamic>.from(images.map((x) => x)),
        "id": id,
        "hookupType": hookupType,
        "jobId": jobId,
        "hookupLocation": hookupLocation,
        "dropOffLocation": dropOffLocation,
        "rego": rego,
        "type": type,
        "hookupCoordinate": hookupCoordinate,
        "dropoffCoordinate": dropoffCoordinate
      };
}

class HookupTypeNavigation {
  int id;
  String type;
  String description;
  List<dynamic> trailers;

  HookupTypeNavigation({
    required this.id,
    required this.type,
    required this.description,
    required this.trailers,
  });

  factory HookupTypeNavigation.fromJson(Map<String, dynamic> json) =>
      HookupTypeNavigation(
        id: json["id"],
        type: json["type"],
        description: json["description"],
        trailers: List<dynamic>.from(json["trailers"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "description": description,
        "trailers": List<dynamic>.from(trailers.map((x) => x)),
      };
}

class WayPoint {
  int? id;
  int? jobId;
  String location;
  String coordinates;

  WayPoint({
    this.id,
    this.jobId,
    required this.location,
    required this.coordinates,
  });

  factory WayPoint.fromJson(Map<String, dynamic> json) => WayPoint(
        id: json["id"],
        jobId: json["jobId"],
        location: json["location"],
        coordinates: json["coordinates"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobId": jobId,
        "location": location,
        "coordinates": coordinates,
      };
}

class PreDepartureChecklist {
  int id;
  int jobId;
  String water;
  String spareRim;
  String allLightsAndIndicators;
  String jackAndTools;
  String ownersManual;
  String airAndElectrics;
  String tyresCondition;
  String visuallyDipAndCheckTaps;
  String windscreenDamageWipers;
  String vehicleCleanFreeOfRubbish;
  String keysFobTotalKeys;
  String checkInsideTruckTrailer;
  String oil;
  String checkTruckHeight;
  String leftHandDamage;
  String rightHandDamage;
  String frontDamage;
  String rearDamage;
  double fuelLevel;
  bool isPre;
  List<Note> notes;

  PreDepartureChecklist({
    required this.id,
    required this.jobId,
    required this.water,
    required this.spareRim,
    required this.allLightsAndIndicators,
    required this.jackAndTools,
    required this.ownersManual,
    required this.airAndElectrics,
    required this.tyresCondition,
    required this.visuallyDipAndCheckTaps,
    required this.windscreenDamageWipers,
    required this.vehicleCleanFreeOfRubbish,
    required this.keysFobTotalKeys,
    required this.checkInsideTruckTrailer,
    required this.oil,
    required this.checkTruckHeight,
    required this.leftHandDamage,
    required this.rightHandDamage,
    required this.frontDamage,
    required this.rearDamage,
    required this.fuelLevel,
    required this.isPre,
    required this.notes,
  });

  factory PreDepartureChecklist.fromJson(Map<String, dynamic> json) =>
      PreDepartureChecklist(
        id: json["id"],
        jobId: json["jobId"],
        water: json["water"] ?? "NA",
        spareRim: json["spareRim"] ?? "NA",
        allLightsAndIndicators: json["allLightsAndIndicators"] ?? "NA",
        jackAndTools: json["jackAndTools"] ?? "NA",
        ownersManual: json["ownersManual"] ?? "NA",
        airAndElectrics: json["airAndElectrics"] ?? "NA",
        tyresCondition: json["tyresCondition"] ?? "NA",
        visuallyDipAndCheckTaps: json["visuallyDipAndCheckTaps"] ?? "NA",
        windscreenDamageWipers: json["windscreenDamageWipers"] ?? "NA",
        vehicleCleanFreeOfRubbish: json["vehicleCleanFreeOfRubbish"] ?? "NA",
        keysFobTotalKeys: json["keysFobTotalKeys"] ?? "NA",
        checkInsideTruckTrailer: json["checkInsideTruckTrailer"] ?? "NA",
        oil: json["oil"] ?? "NA",
        checkTruckHeight: json["checkTruckHeight"] ?? "NA",
        leftHandDamage: json["leftHandDamage"] ?? "NA",
        rightHandDamage: json["rightHandDamage"] ?? "NA",
        frontDamage: json["frontDamage"] ?? "NA",
        rearDamage: json["rearDamage"] ?? "NA",
        fuelLevel: json["fuelLevel"] ?? 0,
        isPre: json["isPre"],
        notes: List<Note>.from(json["notes"].map((x) => Note.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobId": jobId,
        "water": water,
        "spareRim": spareRim,
        "allLightsAndIndicators": allLightsAndIndicators,
        "jackAndTools": jackAndTools,
        "ownersManual": ownersManual,
        "airAndElectrics": airAndElectrics,
        "tyresCondition": tyresCondition,
        "visuallyDipAndCheckTaps": visuallyDipAndCheckTaps,
        "windscreenDamageWipers": windscreenDamageWipers,
        "vehicleCleanFreeOfRubbish": vehicleCleanFreeOfRubbish,
        "keysFobTotalKeys": keysFobTotalKeys,
        "checkInsideTruckTrailer": checkInsideTruckTrailer,
        "oil": oil,
        "checkTruckHeight": checkTruckHeight,
        "leftHandDamage": leftHandDamage,
        "rightHandDamage": rightHandDamage,
        "frontDamage": frontDamage,
        "rearDamage": rearDamage,
        "fuelLevel": fuelLevel,
        "isPre": isPre,
        "notes": List<dynamic>.from(notes.map((x) => x.toJson())),
      };
}

class Note {
  int id;
  int jobId;
  int? vehicleId;
  int? trailerId;
  int? permitAndPlatesId;
  int? preDeparturechecklistId;
  bool? visibletoDriver;
  String noteText;

  Note({
    required this.id,
    required this.jobId,
    this.vehicleId,
    this.trailerId,
    this.permitAndPlatesId,
    this.preDeparturechecklistId,
    this.visibletoDriver,
    required this.noteText,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        jobId: json["jobId"],
        vehicleId: json["vehicleId"],
        trailerId: json["trailerId"],
        permitAndPlatesId: json["permitAndPlatesId"],
        preDeparturechecklistId: json["preDeparturechecklistId"],
        visibletoDriver: json["visibletoDriver"],
        noteText: json["noteText"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobId": jobId,
        "vehicleId": vehicleId,
        "trailerId": trailerId,
        "permitAndPlatesId": permitAndPlatesId,
        "preDeparturechecklistId": preDeparturechecklistId,
        "visibletoDriver": visibletoDriver,
        "noteText": noteText,
      };
}
