import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();


}


class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController(); 
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
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              '© OpenStreetMap contributors, © CARTO',
              onTap: () async {
                final Uri url = Uri.parse('https://carto.com/attributions');
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw Exception('Impossible top open $url');
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
