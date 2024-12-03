import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  static const String backendProxyUrl =
      'https://us-central1-campusconnect-0.cloudfunctions.net/api/maps/api';

  Future<dynamic> fetchMapData(
      String service, Map<String, String> queryParams) async {
    final response = await http.get(Uri.parse('$backendProxyUrl/$service')
        .replace(queryParameters: queryParams));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data from Google Maps API');
    }
  }

  // Method to initialize the map
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Method to handle taps on the map and add markers
  void _onTap(LatLng position) async {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: const InfoWindow(title: 'New Marker'),
        ),
      );
    });

    // Animate camera to the new marker
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(position, 14),
    );
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(
                  context, '/signin'); // Log out and return to sign-in screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onTap,
              markers: _markers,
              mapType: _currentMapType,
              initialCameraPosition: const CameraPosition(
                target: LatLng(44.565732,
                    -123.278934), // Default position (Oregon State University MU Quad)
                zoom: 10,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleMapType,
        child: const Icon(Icons.layers),
      ),
    );
  }
}
