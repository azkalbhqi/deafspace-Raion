import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:deafspace_prod/services/polyline_service.dart'; // Import the polyline service
import 'package:deafspace_prod/services/config.dart'; // Import your config file

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final loc.Location _location = loc.Location();
  LatLng? _startLocation;
  LatLng? _endLocation;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final PolylineService _polylineService = PolylineService();

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        _showError('Location services are disabled.');
        return;
      }
    }

    // Check if location permissions are granted
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        _showError('Location permissions are denied.');
        return;
      }
    }

    // Listen to location changes
    _location.onLocationChanged.listen((locationData) {
      if (_mapController != null) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(locationData.latitude!, locationData.longitude!),
          ),
        );
      }
    });
  }

  void _addMarker(LatLng position) {
    setState(() {
      if (_startLocation == null) {
        _startLocation = position;
        _markers.add(Marker(
          markerId: const MarkerId('start'),
          position: _startLocation!,
          infoWindow: const InfoWindow(title: 'Start Location'),
        ));
      } else {
        _endLocation = position;
        _markers.add(Marker(
          markerId: const MarkerId('end'),
          position: _endLocation!,
          infoWindow: const InfoWindow(title: 'End Location'),
        ));
        _addPolyline(); // Add polyline after setting the end location
      }
    });
  }

  Future<void> _addPolyline() async {
    if (_startLocation != null && _endLocation != null) {
      try {
        List<LatLng> polylineCoordinates = await _polylineService.getPolyline(
          API_KEY,
          _startLocation!,
          _endLocation!,
        );

        setState(() {
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ));
        });

        // Optionally adjust the camera to fit the polyline
        LatLngBounds bounds = _getBounds(_startLocation!, _endLocation!);
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 50),
        );
      } catch (e) {
        _showError('Error fetching route: $e');
      }
    }
  }

  LatLngBounds _getBounds(LatLng start, LatLng end) {
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        min(start.latitude, end.latitude),
        min(start.longitude, end.longitude),
      ),
      northeast: LatLng(
        max(start.latitude, end.latitude),
        max(start.longitude, end.longitude),
      ),
    );
    return bounds;
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Route'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
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
