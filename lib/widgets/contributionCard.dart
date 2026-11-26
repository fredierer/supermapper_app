import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supermapper/widgets/confirmAlertDialog.dart';
import 'package:supermapper/widgets/spot.dart';
import 'package:supermapper/services/spots_service.dart';

final _spotService = SpotService();

class ContributionCard extends StatelessWidget {
  const ContributionCard({
    super.key, 
    required this.spot,
    required this.onDeleted,
  });
  
  final VoidCallback onDeleted;
  final Spot spot;

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  
  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete spot ?',
      message: 'This action cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) return;

    try {
      await _spotService.deleteSpot(spotId: spot.id);
      onDeleted();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete spot: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child : Column(
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
                  Text(
                    _dateFormat.format(spot.creationDate),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            SizedBox(width: 15,),

            IconButton(
              icon: const Icon(
                Icons.delete_forever_outlined,
                size: 20,
                color: Color.fromARGB(125, 176, 0, 32),
              ),
              onPressed: () => _confirmAndDelete(context),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                fixedSize: const Size(32, 32),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: const BorderSide(
                  color: Color.fromARGB(125, 176, 0, 32),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}