import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineService {
  final PolylinePoints _polylinePoints = PolylinePoints();

  // Define the origin and destination coordinates
  final double _originLatitude = 37.7749;
  final double _originLongitude = -122.4194;
  final double _destLatitude = 34.0522;
  final double _destLongitude = -118.2437;

  Future<List<LatLng>> getPolyline(
    String apiKey,
    LatLng startLocation,
    LatLng endLocation,
  ) async {
    List<LatLng> polylineCoordinates = [];

    // Validate API key
    if (apiKey.isEmpty) {
      throw ArgumentError('API key must not be empty');
    }

    try {
      // Request route between coordinates
      PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: apiKey,
        request: PolylineRequest(
          origin: PointLatLng(_originLatitude, _originLongitude),  // Start Point
          destination: PointLatLng(_destLatitude, _destLongitude),  // End Point
          mode: TravelMode.driving,
          wayPoints: [
            PolylineWayPoint(location: "") // Example waypoint
          ],
        ),
      );

      // Check if the request was successful
      if (result.status == 'OK' && result.points.isNotEmpty) {
        polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      } else {
        // Provide detailed error message
        throw Exception('Failed to get route: ${result.errorMessage}');
      }
    } catch (e) {
      // Handle unexpected errors
      print('Error getting polyline: $e');
      throw Exception('An error occurred while fetching the polyline');
    }

    return polylineCoordinates;
  }
}
