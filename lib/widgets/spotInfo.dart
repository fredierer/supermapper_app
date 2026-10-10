import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Widget StatefulWidget représentant la fenêtre d'information sur un Spot.
class SpotInfo extends StatefulWidget {
  // Déclaration des propriétés transmises depuis le widget parent
  final int spotId; // L'identifiant unique du spot à charger
  final VoidCallback? onClose; // Fonction optionnelle exécutée lors du clic sur la croix de fermeture
  
  const SpotInfo({
    super.key,
    required this.spotId,
    required this.onClose,  
  });

  @override
  State<SpotInfo> createState() => _SpotInfoState();
}

class _SpotInfoState extends State<SpotInfo> {
  // Le Future contiendra la réponse de la requête Supabase (une Map de paires clé/valeur)
  late final Future<Map<String, dynamic>?> _spotFuture;

  @override
  void initState() {
    super.initState();
    // On lance la requête une seule fois au chargement du widget pour éviter de ré-interroger la BDD à chaque 'rebuild'
    _spotFuture = _fetchSpotData(widget.spotId);
  }

  /// Méthode asynchrone pour faire la requête à la base de données Supabase
  Future<Map<String, dynamic>?> _fetchSpotData(int id) async {
    final response = await Supabase.instance.client
        .from('spots') // Nom de la table dans Supabase
        .select() // Sélectionne tous les champs de la ligne
        .eq('id', id) // Condition : champ 'id' égal à l'ID passé en paramètre
        .maybeSingle(); // Renvoie 1 seul objet JSON ou null si non trouvé

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _spotFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(), // Affiche un indicateur de chargement
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

            return Column(
              mainAxisSize: MainAxisSize.min, 
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        spotData['title'] ?? 'Spot #${widget.spotId}',
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis, 
                      ),
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
                    )
                  ],
                ),

                const Divider(), 
                const SizedBox(height: 8),

                if (spotData['description'] != null) ...[
                  Text(
                    spotData['description'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}