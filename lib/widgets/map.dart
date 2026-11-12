import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:supermapper_app/services/places_service.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/clusterBubble.dart';
import 'package:supermapper_app/widgets/poi.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class MapWidget extends StatefulWidget {
  final List<Spot> spots;
  final List<Poi> pois;
  final double? targetLat; //Parameter used to move the map to a desired position
  final double? targetLng; //Parameter used to move the map to a desired position
  final double? targetZoom; //Parameter to set a target zoom when place selected from search
  final ValueChanged<int>? onSpotSelected; //Callback function used to display a menu when a spot is selected from the map
  final double? initialLat; //Parameter used to set an initial value of Latitude, so the map can center on something
  final double? initialLng; //Parameter used to set an initial value of Longitude, so the map can center on something
  final double? initialZoom;
  final void Function(double lat, double lng, double zoom, LatLngBounds bounds)? onCenterChanged; //Callback function to give the position of the center of the map when it moved
  final List<BoundaryResult> boundary; //List of set of points used to display th eboundaries of a place
  final double? bottomAttributionPadding; //Padding given to the attribution from the bottom of the screen

  const MapWidget({
    super.key,
    this.spots = const [],
    this.pois = const [],
    this.targetLat,
    this.targetLng,
    this.targetZoom,
    this.onSpotSelected,
    this.initialLat,
    this.initialLng,
    this.initialZoom,
    this.onCenterChanged,
    this.boundary = const [],
    this.bottomAttributionPadding,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();

}


class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  final MapController _mapController = MapController(); 
  bool _locationGranted = false;
  List<Marker> _spotMarkers = [];
  List<Marker> _poiMarkers = [];
  bool _mapReady = false;
  int _lastZoomBucket = -1;

  @override
  void initState() {
    super.initState();
    _initLocation();
    _buildSpotMarkers();
    _buildPoiMarkers();
  }

  void _reportCenter() {
    final camera = _mapController.camera;

    widget.onCenterChanged?.call(camera.center.latitude, camera.center.longitude, camera.zoom, camera.visibleBounds);
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

  void _buildSpotMarkers() {
    _spotMarkers = widget.spots.map((spot) {
      return spot.toMarker(
        onTap: () => widget.onSpotSelected?.call(spot.id),
      );
    }).toList();
  }

  void _buildPoiMarkers() {
    if (!_mapReady) return;

    final zoom = _mapController.camera.zoom;
    final visiblePois = _declutter(widget.pois, zoom);

    _poiMarkers = visiblePois.map((poi) {
      
      return Marker(
        point: LatLng(poi.lat, poi.lng),
        width: 24,
        height: 24,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => debugPrint('POI click : ${poi.name}'),
          child: Icon(
            poi.icon,
            color: poi.color.withAlpha(100),
            size: 18,
          ),
        ),
        );
    }).toList();
  }

  List<Poi> _declutter(List<Poi> pois, double zoom, {double minDistPx = 28}) {
    // Take a list of POI and filters it to avoid POI collision on a map.
    // Project POI position on screen and delete the least important based on priority (poi.priority)
     
    final camera = _mapController.camera;
    final z = zoom.floorToDouble();

    final candidates = pois.where((p) => zoom >= p.minZoom).toList()
      ..sort((a, b) {
        final byPrio = b.priority.compareTo(a.priority);
        return byPrio != 0 ? byPrio : a.id.compareTo(b.id);
      });

    final grid = <(int, int), List<Offset>>{};
    final kept = <Poi>[];

    for (final poi in candidates) {
      final p = camera.projectAtZoom(LatLng(poi.lat, poi.lng), z);
      final cx = (p.dx / minDistPx).floor();
      final cy = (p.dy / minDistPx).floor();

      var collides = false;

      for (var dx = -1; dx <= 1 && !collides; dx++) {
        for (var dy = -1; dy <= 1 && !collides; dy++) {
          for (final q in grid[(cx + dx, cy + dy)] ?? const <Offset>[]) {
            if ((p - q).distance < minDistPx) { // getter : pas de parenthèses
              collides = true;
              break;
            }
          }
        }
      }
      if (collides) continue;

      grid.putIfAbsent((cx, cy), () => []).add(p);
      kept.add(poi);
    }
    return kept;
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.spots != oldWidget.spots) {
      _buildSpotMarkers();
    }

    if (widget.pois != oldWidget.pois) {
      _buildPoiMarkers();
    }

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

    final boundaryColor = AppColors.orange;
    

    return FlutterMap( 
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(widget.initialLat ?? 0, widget.initialLng ?? 0),
        initialZoom: widget.initialZoom ?? 4.0,
        onMapReady: () {
          _mapReady = true;
          _reportCenter();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(_buildPoiMarkers);
          });
        },
        onPositionChanged: (camera, hasGesture) {
          _reportCenter();

          final bucket = (camera.zoom * 2).floor(); // un pas tous les 0.5 de zoom
          if (bucket != _lastZoomBucket) {
            _lastZoomBucket = bucket;
            setState(_buildPoiMarkers);
          }

          //print('Zoom: ${camera.zoom.toStringAsFixed(2)}');
          //print('Lat: ${camera.center.latitude}');
          //print('Lng: ${camera.center.longitude}');

        },
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

        if (widget.boundary.isNotEmpty) ...[
          PolygonLayer(
            polygons: widget.boundary
                .map((shape) => Polygon(
                      points: shape.outer,
                      holePointsList: shape.holes,
                      color: boundaryColor.withAlpha(40), 
                      borderColor: boundaryColor,
                      borderStrokeWidth: 2,
                    ))
                .toList(),
          ),

          if(widget.targetLat != null && widget.targetLng != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(widget.targetLat!, widget.targetLng!),
                  width: 40.0,
                  height: 40.0,
                  child: const Icon(
                    Icons.location_pin,
                    color: AppColors.amber,
                    size: 40.0,
                  ),
                ),
              ],
            ),
        ],
        
        if (_poiMarkers.isNotEmpty)
          MarkerLayer(
            markers: _poiMarkers,
          ),

        if (_locationGranted) const CurrentLocationLayer(),
        
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 40,          // rayon (px) dans lequel les points fusionnent
            size: const Size(40, 40),      // taille du widget de cluster
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50), 
            maxZoom: 12,                   
            zoomToBoundsOnClick: true,     
            markers: _spotMarkers,         
            builder: (context, markers) => ClusterBubble(count: markers.length),
          ),
        ),

        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, widget.bottomAttributionPadding ?? 50),
            child: GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse('https://carto.com/attributions');
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Impossible to open $url');
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
