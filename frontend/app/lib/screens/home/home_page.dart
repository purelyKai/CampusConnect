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
  static const String backendUrl =
      'https://us-central1-campusconnect-0.cloudfunctions.net/api/maps/api';

  // Initialize map
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Handle taps on the map and add markers
  void _onTap(LatLng position) async {
    // Add marker to local map view
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          infoWindow: InfoWindow(
            title: 'New Marker',
            snippet: 'Tap to add pin',
          ),
        ),
      );
    });

    // Animate camera to the new marker
    mapController.animateCamera(CameraUpdate.newLatLngZoom(position, 14));

    // Add pin to Firestore via backend
    await _addPin(position);
  }

  // Toggle between normal and satellite map view
  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  // Add pin to backend (Firestore)
  Future<void> _addPin(LatLng position) async {
    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userEmail': widget.userEmail,
        'title': 'New Pin',
        'description': 'Description of new pin',
        'lat': position.latitude,
        'lng': position.longitude,
      }),
    );

    if (response.statusCode == 201) {
      print('Pin added successfully');
    } else {
      print('Failed to add pin');
    }
  }

  // Fetch pins from backend and update markers
  Future<void> _fetchPins() async {
    final response = await http.get(Uri.parse(backendUrl));

    if (response.statusCode == 200) {
      List<dynamic> pins = jsonDecode(response.body);
      setState(() {
        _markers.clear(); // Clear existing markers
        for (var pin in pins) {
          _markers.add(
            Marker(
              markerId: MarkerId(pin['id']),
              position: LatLng(pin['location']['lat'], pin['location']['lng']),
              infoWindow: InfoWindow(
                title: pin['title'],
                snippet: pin['description'],
              ),
              onTap: () =>
                  _onMarkerTap(pin['id'], pin['title'], pin['description']),
            ),
          );
        }
      });
    } else {
      print('Failed to fetch pins');
    }
  }

  // Handle marker tap to edit or delete pin
  void _onMarkerTap(String pinId, String title, String description) {
    _showEditDeleteDialog(pinId, title, description);
  }

  // Show dialog to edit or delete pin
  void _showEditDeleteDialog(String pinId, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit or Delete Pin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Title: $title'),
              Text('Description: $description'),
              Row(
                children: [
                  TextButton(
                    child: const Text('Edit'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showEditPinDialog(pinId, title, description);
                    },
                  ),
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showDeleteConfirmation(pinId);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Show edit pin dialog
  void _showEditPinDialog(String pinId, String title, String description) {
    final titleController = TextEditingController(text: title);
    final descriptionController = TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Pin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _editPin(
                    pinId, titleController.text, descriptionController.text);
              },
            ),
          ],
        );
      },
    );
  }

  // Edit pin on backend (Firestore)
  Future<void> _editPin(String pinId, String title, String description) async {
    final response = await http.put(
      Uri.parse('$backendUrl/edit/$pinId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'pinId': pinId,
        'userEmail': widget.userEmail,
        'title': title,
        'description': description,
        'lat': 44.565732, // Lat/Lng can be updated as needed
        'lng': -123.278934,
      }),
    );

    if (response.statusCode == 200) {
      print('Pin edited successfully');
      _fetchPins(); // Refresh pins
    } else {
      print('Failed to edit pin');
    }
  }

  // Show confirmation dialog before deleting pin
  void _showDeleteConfirmation(String pinId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Pin'),
          content: const Text('Are you sure you want to delete this pin?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deletePin(pinId);
              },
            ),
          ],
        );
      },
    );
  }

  // Delete pin from backend (Firestore)
  Future<void> _deletePin(String pinId) async {
    final response = await http.delete(
      Uri.parse('$backendUrl/delete/$pinId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userEmail': widget.userEmail}),
    );

    if (response.statusCode == 200) {
      print('Pin deleted successfully');
      _fetchPins(); // Refresh pins
    } else {
      print('Failed to delete pin');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPins(); // Load pins when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusConnect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _toggleMapType,
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(44.565732, -123.278934),
          zoom: 14.0,
        ),
        mapType: _currentMapType,
        markers: _markers,
        onTap: _onTap,
      ),
    );
  }
}
