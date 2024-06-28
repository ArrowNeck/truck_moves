import 'dart:convert';

Driver driverFromJson(String str) => Driver.fromJson(json.decode(str));

String driverToJson(Driver data) => json.encode(data.toJson());

class Driver {
  List<Role> roles;
  String jwtToken;
  int id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;

  Driver({
    required this.roles,
    required this.jwtToken,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        jwtToken: json["jwtToken"],
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
        "jwtToken": jwtToken,
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phoneNumber": phoneNumber,
      };
}

class Role {
  int id;
  String roleName;

  Role({
    required this.id,
    required this.roleName,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        roleName: json["roleName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "roleName": roleName,
      };
}
