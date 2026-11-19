import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermapper_app/screens/profile_screen.dart';
import 'package:supermapper_app/services/profile_service.dart';
import 'package:supermapper_app/widgets/spot.dart';

class SavedSpotCard extends StatefulWidget {
  const SavedSpotCard({super.key, required this.spot});

  final Spot spot;

  @override
  State<SavedSpotCard> createState() => _SavedSpotCardState();
}

class _SavedSpotCardState extends State<SavedSpotCard> {
  final _profileService = ProfileService();
  late final Future<String> _username;

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _username = _profileService.getUsernameFromId(widget.spot.creatorId);
  }

  @override
  Widget build(BuildContext context) {
    final spot = widget.spot;

    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spot.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              spot.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.person, size: 14, color: Colors.black),
                const SizedBox(width: 5),
                Flexible(
                  child: FutureBuilder<String>(
                    future: _username,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data ?? '...',
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _dateFormat.format(spot.creationDate),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}