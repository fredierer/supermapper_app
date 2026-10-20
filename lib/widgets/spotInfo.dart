import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class SpotInfo extends StatefulWidget {
  final int spotId;
  final VoidCallback? onClose;

  const SpotInfo({
    super.key,
    required this.spotId,
    required this.onClose,
  });

  @override
  State<SpotInfo> createState() => _SpotInfoState();
}

class _SpotInfoState extends State<SpotInfo> {
  late final Future<Map<String, dynamic>?> _spotFuture;

  @override
  void initState() {
    super.initState();
    _spotFuture = _fetchSpotData(widget.spotId);
  }

  Future<Map<String, dynamic>?> _fetchSpotData(int id) async {
    final response = await Supabase.instance.client
        .from('spots')
        .select()
        .eq('id', id)
        .maybeSingle();

    return response;
  }

  String formatDate(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return '';

  try {
    final dateTime = DateTime.parse(rawDate).toLocal(); // Convertit en heure locale
    // Ex: "dd MMM yyyy HH:mm" produira "20 Oct. 2026 07:33" (avec la locale 'fr_FR' ou 'en_US')
    return DateFormat('dd MMM. yyyy HH:mm', 'en_US').format(dateTime);
  } catch (e) {
    return rawDate; // Fallback en cas d'erreur
  }
}

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.fromLTRB(20, 100, 20, 170),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _spotFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 150,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text('Error : ${snapshot.error}'),
                  ],
                ),
              );
            }

            final spotData = snapshot.data;

            if (spotData == null) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Aucun spot trouvé pour cet ID.'),
              );
            }

            final String rawDate = spotData['created_at']?.toString() ?? '';
            final String date = formatDate(rawDate);
            final String title = spotData['title']?.toString() ?? 'Spot #${widget.spotId}';
            final String description = spotData['description']?.toString() ?? 'No description';

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            date,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ),
                    IconButton(
                      iconSize: 20,
                      icon: const Icon(Icons.close),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
                    ),
                  ],
                ),

                const Divider(),
                const SizedBox(height: 8),

                Flexible(
                  child: SizedBox(
                    width: double.infinity, 
                    child: SingleChildScrollView(
                      child: Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}