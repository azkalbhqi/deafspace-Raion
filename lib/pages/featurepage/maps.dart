import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  Location _location = Location();

  LatLng? _startLocation;
  LatLng? _endLocation;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  static const String APIKEY = "AIzaSyAKOyCwbPj5OTSLCkPpMgj_xCsYEBMDyoM"; // Your API Key

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((locationData) {
      if (_startLocation != null && _endLocation != null) {
        _addPolyline();
      }
    });
  }

  void _addMarker(LatLng position) {
    setState(() {
      if (_startLocation == null) {
        _startLocation = position;
        _markers.add(Marker(
          markerId: MarkerId('start'),
          position: _startLocation!,
          infoWindow: InfoWindow(title: 'Start Location'),
        ));
      } else if (_endLocation == null) {
        _endLocation = position;
        _markers.add(Marker(
          markerId: MarkerId('end'),
          position: _endLocation!,
          infoWindow: InfoWindow(title: 'End Location'),
        ));
        _addPolyline();
      }
    });
  }

  void _addPolyline() async {
  if (_startLocation != null && _endLocation != null) {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: APIKEY, // Your API Key
      point1: PointLatLng(_startLocation!.latitude, _startLocation!.longitude), // Start Point
      point2: PointLatLng(_endLocation!.latitude, _endLocation!.longitude), // End Point
    );

    if (result.status == 'OK') {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        ));
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Route'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Default to San Francisco
          zoom: 12,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: _addMarker,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
