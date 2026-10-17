import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  final List<Spot> spots;
  final double? targetLat; //Parameter used to move the map to a desired position
  final double? targetLng; //Parameter used to move the map to a desired position
  final double? targetZoom; //Parameter to set a target zoom when place selected from search
  final ValueChanged<int>? onSpotSelected; //Callback function used to display a menu when a spot is selected from the map
  final double? initialLat; //Parameter used to set an initial value of Latitude, so the map can center on something
  final double? initialLng; //Parameter used to set an initial value of Longitude, so the map can center on something
  final void Function(double lat, double lng)? onCenterChanged; //Callback function to give the position of the center of the map when it moved

  const MapWidget({
    super.key,
    this.spots = const [],
    this.targetLat,
    this.targetLng,
    this.targetZoom,
    this.onSpotSelected,
    this.initialLat,
    this.initialLng,
    this.onCenterChanged,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();

}


class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  final MapController _mapController = MapController(); 

  bool _locationGranted = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
  if (!await Geolocator.isLocationServiceEnabled()) return;

  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  final granted = permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;

  if (!mounted) return;
  setState(() => _locationGranted = granted);
}

  void _reportCenter() {
    final center = _mapController.camera.center;
    widget.onCenterChanged?.call(center.latitude, center.longitude);
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.targetLat != null && widget.targetLng != null) {
      if (widget.targetLat != oldWidget.targetLat || widget.targetLng != oldWidget.targetLng) {
        
        final destination = LatLng(widget.targetLat!, widget.targetLng!); 
        final zoom = widget.targetZoom ?? 8.0; 
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _animatedMapMove(destination, zoom, 0.0);
        });
      }
    }
  }

  void _animatedMapMove(LatLng destLocation, double destZoom, double destRotation) {
    final camera = _mapController.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);
    final rotationTween = Tween<double>(begin: camera.rotation, end: destRotation);

    final controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    final animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      _mapController.moveAndRotate(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        rotationTween.evaluate(animation),
      );
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap( 
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(widget.initialLat ?? 0, widget.initialLng ?? 0),
        initialZoom: widget.initialLat != null ? 14 : 3,
        onMapReady: _reportCenter,
        onPositionChanged: (camera, hasGesture) => _reportCenter(),
        maxZoom: 100,
        minZoom: 3,
        interactionOptions: const InteractionOptions(
          enableMultiFingerGestureRace: true,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}.png?key=cb1_301t_1_f5198b589013a43fe135d463',
          userAgentPackageName: 'app.supermapper.app',
        ),

        if (_locationGranted) const CurrentLocationLayer(),
        
        MarkerLayer(
          markers: widget.spots.map((spot) {
            return spot.toMarker(
              onTap: () {
                widget.onSpotSelected?.call(spot.id);
              },
            );
          }).toList(),
        ),

        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 110),
            child: GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse('https://carto.com/attributions');
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Impossible d\'ouvrir $url');
                }
              },
              child: const Text(
                '© OpenStreetMap, © CARTO',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
