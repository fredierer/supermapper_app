import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/contributionCard.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:supermapper_app/widgets/statCard.dart';

const double _borderWidth = 2.0;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  static const _recentCount = 4;

  final _spotService = SpotService();
  late Future<List<Spot>> _spotsFuture;

  @override
  void initState() {
    super.initState();
    _spotsFuture = _spotService.getUserSpots();
  }

  void reload() {
    setState(() {
      _spotsFuture = _spotService.getUserSpots();
    });
  }

  Future<void> _disconnect() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: _borderWidth),
        ),
        title: const Text(
          'Disconnect ?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure to disconnect ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: _amberButtonStyle(),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await Supabase.instance.client.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileHeader(onDisconnect: _disconnect),
              const SizedBox(height: 10),
              FutureBuilder<List<Spot>>(
                future: _spotsFuture,
                builder: _buildSpotsSection,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpotsSection(
    BuildContext context,
    AsyncSnapshot<List<Spot>> snapshot,
  ) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: SizedBox(
            height: 32,
            width: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    if (snapshot.hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              const Text('Impossible to load spots.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: reload,
                style: _amberButtonStyle(),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    final spots = snapshot.requireData;
    final recentSpots = spots.take(_recentCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('STATISTICS'),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.edit_location_alt_outlined,
                value: '${spots.length}',
                label: 'Contributions',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _SectionTitle('YOUR CONTRIBUTIONS'),
        const SizedBox(height: 5),
        if (recentSpots.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No contribution for now 😢'),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: recentSpots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 160,
            ),
            itemBuilder: (context, index) =>
                ContributionCard(spot: recentSpots[index]),
          ),
      ],
    );
  }
}

ButtonStyle _amberButtonStyle() {
  return FilledButton.styleFrom(
    backgroundColor: AppColors.amber,
    foregroundColor: Colors.black,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: Colors.black, width: _borderWidth),
    ),
  );
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onDisconnect});

  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Disconnect : petit bouton carré en haut à droite
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: onDisconnect,
            tooltip: 'Disconnect',
            icon: const Icon(Icons.logout, size: 22, color: AppColors.errorRed),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: const Size(48, 48),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: const BorderSide(color: AppColors.errorRed, width: _borderWidth),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: AppColors.amber,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: _borderWidth),
            ),
            child: const Icon(Icons.person, size: 56, color: Colors.black),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Rémy',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceMono(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}