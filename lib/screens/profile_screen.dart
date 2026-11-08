import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/theme.dart';
import 'package:supermapper_app/widgets/contributionCard.dart';
import 'package:supermapper_app/widgets/spot.dart';
import 'package:supermapper_app/widgets/statCard.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceLight,
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const _ProfileHeader(),
              
              FutureBuilder<List<Spot>>(
                future: _spotsFuture,
                builder: _buildSpotsSection,
              ),
              
              const SizedBox(height: 15),
              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: () => Supabase.instance.client.auth.signOut(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Disconnect'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 183, 178),
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
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
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (snapshot.hasError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              const Text('Impossible de charger tes contributions.'),
              TextButton(onPressed: reload, child: const Text('Réessayer')),
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
                value: '${spots.length}', // vraie valeur
                label: 'Contributions',
              ),
            ),
            
          ],
        ),
        
        const SizedBox(height: 10),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            const _SectionTitle('YOUR CONTRIBUTIONS'),
            
            //TextButton(
            //  onPressed: () {
            //    // Navigator.push(...) vers l'écran avec toutes les contributions
            //  },
            //  style: TextButton.styleFrom(foregroundColor: Colors.black45),
            //  child: const Text('See All'),
            //),
          ],
        ),
        
        const SizedBox(height: 5),
        
        if (recentSpots.isEmpty)
          const Center(child:Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('No contribution for now 😢'),
          ))
        
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 200,
          width: double.infinity,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 60,
              child: Icon(Icons.person, size: 50, color: Colors.black54),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Rémy',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
          color: Colors.grey,
          fontSize: 26,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}