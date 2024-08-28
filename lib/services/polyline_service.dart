import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineService {
  final PolylinePoints _polylinePoints = PolylinePoints();

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
        apiKey: apiKey,
        startPoint: PointLatLng(startLocation.latitude, startLocation.longitude),
        endPoint: PointLatLng(endLocation.latitude, endLocation.longitude),
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
