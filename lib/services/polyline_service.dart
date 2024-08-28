// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class PolylineService {
//   final PolylinePoints _polylinePoints = PolylinePoints();

//   Future<List<LatLng>> getPolyline(
//     String apiKey,
//     LatLng startLocation,
//     LatLng endLocation,
//   ) async {
//     List<LatLng> polylineCoordinates = [];

//     // Validate API key
//     if (apiKey.isEmpty) {
//       throw ArgumentError('API key must not be empty');
//     }

//     // Define variables for origin and destination coordinates
//     final double _originLatitude = startLocation.latitude;
//     final double _originLongitude = startLocation.longitude;
//     final double _destLatitude = endLocation.latitude;
//     final double _destLongitude = endLocation.longitude;
//     final String googleApiKey = apiKey;

//     // try {
//     //   // Request route between coordinates
//     //   PolylinePoints polylinePoints = PolylinePoints();
//     //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//     //     // googleApiKey: apiKey,
//     //     // request: PolylineRequest(
//     //       origin: PointLatLng(_originLatitude, _originLongitude),
//     //       destination: PointLatLng(_destLatitude, _destLongitude),
//     //       mode: TravelMode.driving,
//     //       wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
//     //     ),
//     //   );

//       // Check if the request was successful
//       if (result.status == 'OK' && result.points.isNotEmpty) {
//         polylineCoordinates = result.points
//             .map((point) => LatLng(point.latitude, point.longitude))
//             .toList();
//       } else {
//         // Provide detailed error message
//         throw Exception('Failed to get route: ${result.errorMessage}');
//       }
//     } catch (e) {
//       // Handle unexpected errors
//       print('Error getting polyline: $e');
//       throw Exception('An error occurred while fetching the polyline');
//     }

//     return polylineCoordinates;
//   }
// }
