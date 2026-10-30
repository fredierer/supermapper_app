import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supermapper_app/services/places_service.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/clusterBubble.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'dart:async';
import 'package:supermapper_app/services/pois_service.dart';

class MapWidget extends StatefulWidget {
  final List<Spot> spots;
  final double? targetLat; //Parameter used to move the map to a desired position
  final double? targetLng; //Parameter used to move the map to a desired position
  final double? targetZoom; //Parameter to set a target zoom when place selected from search
  final ValueChanged<int>? onSpotSelected; //Callback function used to display a menu when a spot is selected from the map
  final double? initialLat; //Parameter used to set an initial value of Latitude, so the map can center on something
  final double? initialLng; //Parameter used to set an initial value of Longitude, so the map can center on something
  final double? initialZoom;
  final void Function(double lat, double lng, double zoom,)? onCenterChanged; //Callback function to give the position of the center of the map when it moved
  final List<BoundaryResult> boundary; //List of set of points used to display th eboundaries of a place
  final double? bottomAttributionPadding; //Value of padding from the bottom of the map

  const MapWidget({
    super.key,
    this.spots = const [],
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
  final MapController _mapController = MapController(); //Map Controller
  bool _locationGranted = false; //User location authorization
  List<Marker> _spotMarkers = []; //List of spot to fetch from Supabase

  static const _minZoom = 15.0; //Minimum zoom value needed to fetch data from Overpass
  static const _minInterval = Duration(seconds: 2); //Minimum time value before sending a new request to Overpass
  List<Poi> _pois = []; //List of POI to be fetch from Overpass
  Timer? _poiTimer; //Timer to control frequency of request to Overpass
  DateTime _lastPoiFetch = DateTime.fromMillisecondsSinceEpoch(0); //Timestamp of the last POI fetch from Overpass
  bool _isFetchingPois = false; //Boolean to store current fetching state

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  void _reportCenter() {
    final camera = _mapController.camera;
    widget.onCenterChanged?.call(camera.center.latitude, camera.center.longitude, camera.zoom,);
    _schedulePoiFetch();
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

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.spots != oldWidget.spots) {
      _buildSpotMarkers();
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

  void _schedulePoiFetch() {
    final camera = _mapController.camera;

    if (camera.zoom < _minZoom) {
      if (_pois.isNotEmpty) setState(() => _pois = []);
      return;
    }

    if (_isFetchingPois) return;

    if (DateTime.now().difference(_lastPoiFetch) < _minInterval) return;

    _loadPois();
  }

  Future<void> _loadPois() async {

    print("______________ LOADING POIS ______________");

    final camera = _mapController.camera;
    if (camera.zoom < _minZoom) return;

    _isFetchingPois = true;
    _lastPoiFetch = DateTime.now();
    final bounds = camera.visibleBounds;

    try {
      final pois = await fetchPois(
        south: bounds.south,
        west: bounds.west,
        north: bounds.north,
        east: bounds.east,
      );

      print("______________ POIS ______________");
      print(pois);

      if (!mounted || _mapController.camera.zoom < _minZoom) return;
      setState(() => _pois = pois);
    } catch (e) {
      debugPrint('POI fetch failed: $e');
    } finally {
      _isFetchingPois = false;
    }
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
          _reportCenter();
          _schedulePoiFetch();
        },
        onPositionChanged: (camera, hasGesture) {
          _reportCenter();
          _schedulePoiFetch();
          print('Zoom: ${camera.zoom.toStringAsFixed(2)}');
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
        
        MarkerLayer(
          markers: _pois.map((poi) {
            final style = filters[poi.category]; // null si 'unknown'
            return Marker(
              point: LatLng(poi.lat, poi.lng),
              width: 32,
              height: 32,
              child: Container(
                decoration: BoxDecoration(
                  color: style?.color ?? Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  style?.icon ?? Icons.place,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            );
          }).toList(),
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

  @override
  void dispose() {
    _poiTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }
}
