import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatefulWidget {
  final List<Spot> spots;
  final double? targetLat;
  final double? targetLng;
  final ValueChanged<int>? onSpotSelected;
  
  const MapWidget({
    super.key,
    this.spots = const [],
    this.targetLat,
    this.targetLng,
    this.onSpotSelected,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();

}


class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  final MapController _mapController = MapController(); 
  
  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.targetLat != null && widget.targetLng != null) {
      if (widget.targetLat != oldWidget.targetLat || widget.targetLng != oldWidget.targetLng) {
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _animatedMapMove(
            LatLng(widget.targetLat!, widget.targetLng!), 
            14.0,
            0.0,
          );
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
        initialCenter: LatLng(0, 0),
        initialZoom: 3,
        maxZoom: 100,
        minZoom: 3,

      ),
      children: [
        TileLayer(
          urlTemplate: 'https://basemaps.cartocdn.com/rastertiles/light_all/{z}/{x}/{y}.png?key=cb1_301t_1_f5198b589013a43fe135d463',
          userAgentPackageName: 'app.supermapper.app',
        ),

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
