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
    // Card fournit le fond blanc/sombre, l'ombre portée et la structure visuelle de la fenêtre
    return Card(
      elevation: 8, // Hauteur de l'ombre portée sous la fenêtre
      margin: const EdgeInsets.all(16), // Marge externe autour de la carte
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Coins arrondis
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Marge interne entre la carte et son contenu
        // FutureBuilder écoute l'état de _spotFuture et reconstruit l'UI automatiquement
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _spotFuture,
          builder: (context, snapshot) {
            // --- CAS 1 : En attente de la réponse de Supabase ---
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(), // Affiche un indicateur de chargement
                ),
              );
            }

            // --- CAS 2 : La requête Supabase a renvoyé une erreur ---
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

            // --- CAS 3 : La requête est terminée mais aucun enregistrement correspondant n'a été trouvé ---
            final spotData = snapshot.data;
            if (spotData == null) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Aucun spot trouvé pour cet ID.'),
              );
            }

            // --- CAS 4 : Succès ! Les données sont récupérées et prêtes à être affichées ---
            return Column(
              mainAxisSize: MainAxisSize.min, // La hauteur de la fenêtre s'ajuste dynamiquement selon son contenu
              crossAxisAlignment: CrossAxisAlignment.start, // Aligne le texte à gauche
              children: [
                // 1. En-tête : Titre du spot + Bouton de fermeture
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        // Lit le champ 'name' de la BDD ou met un nom par défaut
                        spotData['title'] ?? 'Spot #${widget.spotId}',
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis, // Tronque avec '...' si le nom est trop long
                      ),
                    ),
                    IconButton(
                      iconSize: 20, 
                      icon: const Icon(Icons.close),
                      constraints: const BoxConstraints(
                        minWidth: 36,   // Diamètre / largeur minimale
                        minHeight: 36,  // Diamètre / hauteur minimale
                      ),
                      padding: EdgeInsets.zero,                       
                      onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
                    )
                  ],
                ),

                const Divider(), // Ligne horizontale de séparation
                const SizedBox(height: 8),

                // 2. Champ Description (affiché seulement s'il existe dans les données)
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