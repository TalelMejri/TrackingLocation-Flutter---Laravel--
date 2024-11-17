import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:track_test/global/pusher_config.dart';
import 'dart:convert';
import 'package:track_test/model/BusModel.dart';

class TrackBus extends StatefulWidget {
  const TrackBus({super.key, required this.bus});
  final BusModel bus;

  @override
  _TrackBusState createState() => _TrackBusState();
}

class _TrackBusState extends State<TrackBus> {
  double? totalDistance;
  double? totalDuration;
  final MapController mapController = MapController();
  LocationData? currentLocation;
  List<LatLng> routePoints = [];
  List<Marker> markers = [];
  double _currentZoom = 13.0;
  Timer? _markerUpdateTimer;
  double lat = 0.0;
  double long = 0.0;

  final String orsApiKey =
      '5b3ce3597851110001cf6248ed49d5d5d50b47c886fa2a8261919d5d';

  void _startMarkerUpdateTimer() {
    _markerUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateRedMarkerPosition();
    });
  }

  late PusherConfig _pusherConfig = PusherConfig();

  void _updateRedMarkerPosition() {
    if (currentLocation != null) {
      setState(() {
        final LatLng lastPosition = markers.last.point;
        final newLatLng = LatLng(
            lastPosition.latitude - 0.001, lastPosition.longitude - 0.001);
        markers.removeLast();
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: newLatLng,
            child: const Icon(Icons.bus_alert_rounded,
                color: Colors.red, size: 40.0),
          ),
        );
        _getRoute(newLatLng);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pusherConfig.initPusher(
      (p0) {
        print("test");
      },
    );
    setState(() {
      long = widget.bus.longitude;
      lat = widget.bus.latitude;
    });
    _getCurrentLocation();
    _startMarkerUpdateTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    var location = Location();
    try {
      var userLocation = await location.getLocation();
      setState(() {
        currentLocation = userLocation;
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(userLocation.latitude!, userLocation.longitude!),
            child: const Icon(Icons.accessibility_new_outlined,
                color: Colors.blue, size: 40.0),
          ),
        );
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(lat, long),
            child: const Icon(Icons.bus_alert_rounded,
                color: Colors.red, size: 40.0),
          ),
        );
        _getRoute(LatLng(lat, long));
      });
    } on Exception {
      currentLocation = null;
    }

    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  Future<void> _getRoute(LatLng destination) async {
    if (currentLocation == null) return;
    final start =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    final response = await http.get(
      Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coords =
          data['features'][0]['geometry']['coordinates'];
      setState(() {
        routePoints =
            coords.map((coord) => LatLng(coord[1], coord[0])).toList();
        final props = data['features'][0]['properties']['segments'][0];
        totalDistance = props['distance'] / 1000;
        totalDuration = props['duration'] / 60;
        markers.removeLast();
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: destination,
            child: const Icon(Icons.bus_alert_rounded,
                color: Colors.red, size: 40.0),
          ),
        );
      });
    } else {
      print('Failed to fetch route');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chochen Tracking'),
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    initialZoom: _currentZoom,
                    // onTap: (tapPosition, point) => _addDestinationMarker(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: markers,
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routePoints,
                          strokeWidth: 4.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
                if (totalDistance != null && totalDuration != null)
                  Positioned(
                    bottom: 20,
                    left: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Distance: ${totalDistance!.toStringAsFixed(2)} km',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            'Temps estimé: ${totalDuration!.toStringAsFixed(2)} minutes',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                    right: 20,
                    bottom: 80,
                    child: Column(
                      children: [
                        FloatingActionButton(
                          mini: true,
                          onPressed: () {
                            setState(() {
                              _currentZoom += 1;
                              mapController.move(
                                mapController.center,
                                _currentZoom,
                              );
                            });
                          },
                          child: const Icon(Icons.zoom_in),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        FloatingActionButton(
                          mini: true,
                          onPressed: () {
                            setState(() {
                              _currentZoom -= 1;
                              mapController.move(
                                mapController.center,
                                _currentZoom,
                              );
                            });
                          },
                          child: const Icon(Icons.zoom_out),
                        ),
                      ],
                    ))
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentLocation != null) {
            mapController.move(
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
              _currentZoom,
            );
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
