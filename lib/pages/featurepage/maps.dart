// // map_page.dart
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;
// import 'package:deafspace_prod/services/polyline_service.dart'; // Import the polyline service
// import 'package:deafspace_prod/services/config.dart'; // Import your config file

// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   GoogleMapController? _mapController;
//   final loc.Location _location = loc.Location();
//   LatLng? _startLocation;
//   LatLng? _endLocation;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};
//   final PolylineService _polylineService = PolylineService();

//   @override
//   void initState() {
//     super.initState();
//     _checkLocationPermission();
//   }

//   Future<void> _checkLocationPermission() async {
//     bool serviceEnabled;
//     loc.PermissionStatus permissionGranted;

//     serviceEnabled = await _location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _location.requestService();
//       if (!serviceEnabled) {
//         _showError('Location services are disabled.');
//         return;
//       }
//     }

//     permissionGranted = await _location.hasPermission();
//     if (permissionGranted == loc.PermissionStatus.denied) {
//       permissionGranted = await _location.requestPermission();
//       if (permissionGranted != loc.PermissionStatus.granted) {
//         _showError('Location permissions are denied.');
//         return;
//       }
//     }

//     _location.onLocationChanged.listen((locationData) {
//       if (_mapController != null) {
//         _mapController?.animateCamera(
//           CameraUpdate.newLatLng(
//             LatLng(locationData.latitude!, locationData.longitude!),
//           ),
//         );
//       }
//     });
//   }

//   void _addMarker(LatLng position) {
//     setState(() {
//       if (_startLocation == null) {
//         _startLocation = position;
//         _markers.add(Marker(
//           markerId: MarkerId('start'),
//           position: _startLocation!,
//           infoWindow: InfoWindow(title: 'Start Location'),
//         ));
//       } else {
//         _endLocation = position;
//         _markers.add(Marker(
//           markerId: MarkerId('end'),
//           position: _endLocation!,
//           infoWindow: InfoWindow(title: 'End Location'),
//         ));
//         _addPolyline();
//       }
//     });
//   }

//   Future<void> _addPolyline() async {
//     if (_startLocation != null && _endLocation != null) {
//       List<LatLng> polylineCoordinates = await _polylineService.getPolyline(
//         API_KEY,
//         _startLocation!,
//         _endLocation!,
//       );

//       setState(() {
//         _polylines.clear();
//         _polylines.add(Polyline(
//           polylineId: PolylineId('route'),
//           points: polylineCoordinates,
//           color: Colors.blue,
//           width: 5,
//         ));
//       });
//     }
//   }

//   void _showError(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Route'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(37.7749, -122.4194), // Default to San Francisco
//           zoom: 12,
//         ),
//         markers: _markers,
//         polylines: _polylines,
//         onMapCreated: (controller) {
//           _mapController = controller;
//         },
//         onTap: _addMarker,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//       ),
//     );
//   }
// }
