import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper/services/profile_service.dart';
import 'package:supermapper/services/spots_service.dart';
import 'package:supermapper/theme.dart';
import 'package:supermapper/widgets/confirmAlertDialog.dart';
import 'package:supermapper/widgets/contributionCard.dart';
import 'package:supermapper/widgets/savedSpotCard.dart';
import 'package:supermapper/widgets/spot.dart';
import 'package:supermapper/widgets/statCard.dart';

const double _borderWidth = 3.0;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.onSpotDeleted,
  });

  final VoidCallback onSpotDeleted;

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  static const _recentCount = 4;

  final _spotService = SpotService();
  final _profileService = ProfileService();

  late Future<List<Spot>> _contributionSpotFuture;
  late Future<List<Spot>> _savedSpotsFuture;
  late Future<String> _username;
  final _client = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _contributionSpotFuture = _spotService.getUserSpots();
    _savedSpotsFuture = _profileService.getCurrentUserSavedSpot();
    _username = _profileService.getCurrentUsername();
    
  }

  void reload() {
    setState(() {
      _contributionSpotFuture = _spotService.getUserSpots();
      _savedSpotsFuture = _profileService.getCurrentUserSavedSpot();
    });
  }

  Future<void> _disconnect() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Disconnect ?',
      message: 'Are you sure to disconnect ?',
      confirmLabel: 'Disconnect',
    );
    if (!confirmed) return;
    await _client.auth.signOut();
  }

  Future<void> _usernameChanged(String newUsername) async {
    if (newUsername.trim().isEmpty) return;

    try {
      // Appel de votre service pour sauvegarder en base (ajustez le nom de la méthode selon votre ProfileService)
      await _profileService.updateUsername(newUsername.trim());

      // On met à jour le Future du username pour rafraîchir l'affichage
      setState(() {
        _username = Future.value(newUsername.trim());
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update username: $e')),
        );
      }
    }
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
              FutureBuilder<String>(
                future: _username,
                builder: (context, snapshot) => _ProfileHeader(
                  onDisconnect: _disconnect,
                  username: snapshot.data ?? '',
                  onUsernameChanged: _usernameChanged,
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Spot>>(
                future: _contributionSpotFuture,
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
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.amber,
                  foregroundColor: Colors.black,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.black, width: 3.0),
                  ),
                ),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    final spots = snapshot.requireData;
    final recentSpots = spots.take(_recentCount).toList();
    
    final savedSpots = _profileService.getCurrentUserSavedSpot();

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
        const _SectionTitle('SAVED SPOTS'),
        const SizedBox(height: 5),

        FutureBuilder<List<Spot>>(
          future: _savedSpotsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final savedSpots = snapshot.data ?? [];
            if (savedSpots.isEmpty) {
              return const Center(child: Text('No saved spots for now 😢'));
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 160,
              ),
              itemCount: savedSpots.length,
              itemBuilder: (context, index) => SavedSpotCard(spot: savedSpots[index]),
            );
          },
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
              crossAxisCount: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 120,
            ),
            itemBuilder: (context, index) =>
                ContributionCard(
                  spot: recentSpots[index],
                  onDeleted: () {
                    reload();
                    widget.onSpotDeleted();
                  }
                ),
          ),
      ],
    );
  }
}

class _ProfileHeader extends StatefulWidget {
  const _ProfileHeader({
    required this.onDisconnect,
    required this.username,
    required this.onUsernameChanged,
  });

  final VoidCallback onDisconnect;
  final String username;
  final ValueChanged<String> onUsernameChanged;

  @override
  State<_ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<_ProfileHeader> {
  // 1. État local pour gérer le mode édition
  bool _isEditing = false;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.username);
  }

  @override
  void didUpdateWidget(covariant _ProfileHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Met à jour le texte si le username change depuis l'extérieur
    if (oldWidget.username != widget.username && !_isEditing) {
      _textController.text = widget.username;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // Sauvegarde : on notifie le parent du nouveau pseudo
        widget.onUsernameChanged(_textController.text);
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
  const double _borderWidth = 2.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _isEditing? null : widget.onDisconnect,
              tooltip: 'Disconnect',
              icon: Icon(Icons.logout, size: 22, color: _isEditing? Colors.grey : AppColors.errorRed),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                disabledBackgroundColor: Colors.white,
                fixedSize: const Size(48, 48),
                padding: EdgeInsets.zero,
                side: BorderSide(color: _isEditing? Colors.grey : AppColors.errorRed, width: _borderWidth),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            IconButton(
              onPressed: _toggleEdit,
              tooltip: _isEditing ? 'Save' : 'Edit username',
              icon: Icon(
                _isEditing ? Icons.save : Icons.edit,
                size: 24,
                color: Colors.black,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                fixedSize: const Size(48, 48),
                padding: EdgeInsets.zero,
                side: const BorderSide(color: Colors.black, width: _borderWidth),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        


          ],
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
        
        // Conteneur centré pour la ligne pseudo + bouton
        Center(
          child: _isEditing
            ? ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250),
                child: TextField(
                  controller: _textController,
                  autofocus: true,
                  maxLength: 36,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceMono(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(5.0),
                    border: UnderlineInputBorder(),
                  ),
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.username,
                  maxLines: 1,
                  style: GoogleFonts.spaceMono(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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