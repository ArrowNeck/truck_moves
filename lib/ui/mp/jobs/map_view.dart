import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as ml;
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job.dart';
import 'package:truck_moves/shared_widgets/page_loaders.dart';

class MapView extends StatefulWidget {
  final String pickupCords;
  final String deliveryCords;
  final String pickupLocation;
  final String deliveryLocation;
  final List<WayPoint> wayPoints;
  const MapView(
      {super.key,
      required this.pickupCords,
      required this.deliveryCords,
      required this.wayPoints,
      required this.pickupLocation,
      required this.deliveryLocation});

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  MapType _mapType = MapType.normal;
  final Set<Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};

  late LatLng start;
  late LatLng end;
  List<LatLng> waypoints = [];

  @override
  void initState() {
    initMap();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initMap() async {
    start = LatLng(double.parse(widget.pickupCords.split(", ").first),
        double.parse(widget.pickupCords.split(", ").last));
    end = LatLng(double.parse(widget.deliveryCords.split(", ").first),
        double.parse(widget.deliveryCords.split(", ").last));

    generateMarkers();
    final coordinates = await getPolylinePoints();
    generatePolylineFromPoints(coordinates);
  }

  void generateMarkers() {
    _markers.add(Marker(
        markerId: const MarkerId("Start"),
        position: start,
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          luanchMap(
              latitude: start.latitude,
              longitude: start.longitude,
              name: widget.pickupLocation);
        }));
    for (int i = 0; i < widget.wayPoints.length; i++) {
      LatLng point = LatLng(
          double.parse(widget.wayPoints[i].coordinates.split(", ").first),
          double.parse(widget.wayPoints[i].coordinates.split(", ").last));
      waypoints.add(point);
      _markers.add(Marker(
          markerId: MarkerId("$i"),
          position: point,
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            luanchMap(
                latitude: point.latitude,
                longitude: point.longitude,
                name: widget.wayPoints[i].location);
          }));
    }
    _markers.add(Marker(
        markerId: const MarkerId("End"),
        position: end,
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          luanchMap(
              latitude: end.latitude,
              longitude: end.longitude,
              name: widget.deliveryLocation);
        }));

    setState(() {});
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleMapApiKey,
      request: PolylineRequest(
          origin: PointLatLng(start.latitude, start.longitude),
          destination: PointLatLng(end.latitude, end.longitude),
          mode: TravelMode.driving,
          wayPoints: waypoints
              .map((e) =>
                  PolylineWayPoint(location: "${e.latitude},${e.longitude}"))
              .toList(),
          optimizeWaypoints: true),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      debugPrint(result.errorMessage);
    }

    return polylineCoordinates;
  }

  generatePolylineFromPoints(List<LatLng> coordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue[400]!,
        points: coordinates,
        width: 8);

    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: ((GoogleMapController contoller) =>
                  _mapController.complete(contoller)),
              initialCameraPosition: CameraPosition(
                target: start,
                zoom: 8.0,
              ),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapType: _mapType,
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
            ),
            Positioned(
                left: 5.w,
                top: 5.h,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _mapType = MapType.normal;
                        });
                      },
                      child: Container(
                        height: 20.h,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        color: Colors.white,
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Map",
                            style: TextStyle(
                                color: const Color(0xFF010101),
                                fontSize: 10.sp,
                                fontWeight: _mapType == MapType.normal
                                    ? FontWeight.w600
                                    : FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      endIndent: 0,
                      indent: 0,
                      width: 2.w,
                      thickness: 2.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _mapType = MapType.satellite;
                        });
                      },
                      child: Container(
                        height: 20.h,
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        color: Colors.white,
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Satellite",
                            style: TextStyle(
                                color: const Color(0xFF010101),
                                fontSize: 10.sp,
                                fontWeight: _mapType == MapType.satellite
                                    ? FontWeight.w600
                                    : FontWeight.w400),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void luanchMap(
      {required double latitude,
      required double longitude,
      required String name}) async {
    try {
      PageLoader.showLoader(context);
      final maps = await ml.MapLauncher.installedMaps;
      if (!mounted) return;
      Navigator.pop(context);
      if (maps.length == 1) {
        // availableMaps.first
        //      .showDirections(destination: ml.Coords(latitude, longitude));
        maps.first
            .showMarker(coords: ml.Coords(latitude, longitude), title: name);
      } else {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (int i = 0; i < maps.length; i++) ...[
                      GestureDetector(
                        onTap: () => {
                          maps[i].showMarker(
                              coords: ml.Coords(latitude, longitude),
                              title: name),
                          Navigator.pop(context),
                        },
                        child: Container(
                          height: 50.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(i == 0 ? 10.h : 0),
                                topRight: Radius.circular(i == 0 ? 10.h : 0),
                                bottomLeft: Radius.circular(
                                    i == maps.length - 1 ? 10.h : 0),
                                bottomRight: Radius.circular(
                                    i == maps.length - 1 ? 10.h : 0),
                              )),
                          child: Text(
                            maps[i].mapName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      if (i < maps.length - 1)
                        const Divider(
                          color: Colors.white70,
                          height: 0,
                          thickness: .25,
                        )
                    ],
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 55.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10.h)),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
