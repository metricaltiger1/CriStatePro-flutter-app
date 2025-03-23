import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong2;

class InteractiveMap extends StatelessWidget {
  final latlong2.LatLng location;

  const InteractiveMap({required this.location, super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: location,
        initialZoom: 11,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: location,
              width: 80,
              height: 80,
              child: const Icon(Icons.location_pin, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}
