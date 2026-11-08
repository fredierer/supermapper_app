import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supermapper_app/services/profile_service.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/spot.dart';

const double _borderWidth = 3.0;

class HomeScreen extends StatefulWidget {
  final VoidCallback onProfileButtonPressed;
  final VoidCallback onMapCardPressed;

  const HomeScreen({
    super.key,
    required this.onProfileButtonPressed,
    required this.onMapCardPressed,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _spotService = SpotService();
  final _profileService = ProfileService();
  late Future<List<Spot>> _recentSpots;
  late Future<String> _username;

  static final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    _recentSpots = _spotService.getSpots(max: 5);
    _username = _profileService.getCurrentUsername();
    reload();
  }

  void reload() {
    setState(() {
      _username = _profileService.getCurrentUsername();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(_username),
              const SizedBox(height: 30),
              const _SectionTitle('NEW SPOTS'),
              const SizedBox(height: 4),
              _buildRecentSpots(),
              const SizedBox(height: 30),
              _buildNavButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Future<String> title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FutureBuilder<String>(
          future: title,
          builder: (context, snapshot) {
            String title = 'Hi';
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              title = 'Hi ${snapshot.data!}';
            }
            
            return Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.spaceMono(
                  fontSize: 50,
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          },
        ),
        IconButton(
          onPressed: widget.onProfileButtonPressed,
          icon: const Icon(Icons.person, size: 26, color: Colors.black),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            fixedSize: const Size(52, 52),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: const BorderSide(color: Colors.black, width: _borderWidth),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSpots() {
    return FutureBuilder<List<Spot>>(
      future: _recentSpots,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 150,
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
          return SizedBox(
            height: 150,
            child: Center(child: Text('Error : ${snapshot.error}')),
          );
        }

        final spots = snapshot.data ?? [];

        if (spots.isEmpty) {
          return const SizedBox(
            height: 150,
            child: Center(child: Text('No contribution for now 😢')),
          );
        }

        return SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: spots.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _SpotCard(
              spot: spots[index],
              dateFormat: _dateFormat,
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavButtons() {
    return Row(
      spacing: 12,
      children: [
        _NavButton(
          icon: Icons.map_outlined,
          label: 'Map',
          onPressed: widget.onMapCardPressed,
        ),
         _NavButton(
          icon: Icons.person,
          label: 'Profile',
          onPressed: widget.onProfileButtonPressed,
        ),
      ],
    );
  }
}

class _SpotCard extends StatelessWidget {
  const _SpotCard({required this.spot, required this.dateFormat});

  final Spot spot;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: _borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spot.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            spot.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const Spacer(),
          Text(
            dateFormat.format(spot.creationDate),
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.amber,
          foregroundColor: Colors.black,
          fixedSize: const Size.fromWidth(150),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Colors.black, width: _borderWidth),
          ),
        ),
      ),
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