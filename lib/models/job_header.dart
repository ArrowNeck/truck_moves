import 'dart:convert';

JobHeader jobHeaderFromJson(String str) => JobHeader.fromJson(json.decode(str));

String jobHeaderToJson(JobHeader data) => json.encode(data.toJson());

class JobHeader {
  int id;
  String pickupLocation;
  String dropOfLocation;
  VehicleNavigation? vehicleNavigation;
  DateTime? pickupDate;
  int status;
  PreDepartureChecklist? preDepartureChecklist;

  JobHeader({
    required this.id,
    required this.pickupLocation,
    required this.dropOfLocation,
    required this.vehicleNavigation,
    required this.pickupDate,
    required this.status,
    required this.preDepartureChecklist,
  });

  factory JobHeader.fromJson(Map<String, dynamic> json) => JobHeader(
        id: json["id"],
        pickupLocation: json["pickupLocation"],
        dropOfLocation: json["dropOfLocation"],
        vehicleNavigation: json["vehicleNavigation"] == null
            ? null
            : VehicleNavigation.fromJson(json["vehicleNavigation"]),
        pickupDate: json["pickupDate"] == null
            ? null
            : DateTime.parse(json["pickupDate"]),
        status: json["status"],
        preDepartureChecklist: json["preDepartureChecklist"] == null
            ? null
            : PreDepartureChecklist.fromJson(json["preDepartureChecklist"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pickupLocation": pickupLocation,
        "dropOfLocation": dropOfLocation,
        "vehicleNavigation": vehicleNavigation?.toJson(),
        "pickupDate": pickupDate?.toIso8601String(),
        "status": status,
        "preDepartureChecklist": preDepartureChecklist?.toJson(),
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
        "notes": List<dynamic>.from(notes.map((x) => x.toJson())),
      };
}

class Note {
  int id;
  int jobId;
  int? vehicleId;
  int? trailerId;
  int preDeparturechecklistId;
  bool visibletoDriver;
  String noteText;

  Note({
    required this.id,
    required this.jobId,
    required this.vehicleId,
    required this.trailerId,
    required this.preDeparturechecklistId,
    required this.visibletoDriver,
    required this.noteText,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json["id"],
        jobId: json["jobId"],
        vehicleId: json["vehicleId"],
        trailerId: json["trailerId"],
        preDeparturechecklistId: json["preDeparturechecklistId"],
        visibletoDriver: json["visibletoDriver"],
        noteText: json["noteText"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobId": jobId,
        "vehicleId": vehicleId,
        "trailerId": trailerId,
        "preDeparturechecklistId": preDeparturechecklistId,
        "visibletoDriver": visibletoDriver,
        "noteText": noteText,
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
        id: json["id"],
        jobId: json["jobId"],
        make: json["make"],
        model: json["model"],
        rego: json["rego"],
        vin: json["vin"],
        year: json["year"],
        colour: json["colour"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobId": jobId,
        "make": make,
        "model": model,
        "rego": rego,
        "vin": vin,
        "year": year,
        "colour": colour,
      };
}
