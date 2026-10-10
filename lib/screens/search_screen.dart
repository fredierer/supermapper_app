import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supermapper_app/configuration/spot_category.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchSpots(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('spots')
          .select()
          .textSearch('fts', query, type: TextSearchType.websearch);

      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      print('Error while searching in database : $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _searchController, // Important pour suivre le texte
                      autofocus: true,
                      onChanged: (value) {
                        if (value.length > 1) {
                          _searchSpots(value);
                        } else {
                          _searchSpots(''); // Réinitialise si l'utilisateur efface tout
                        }
                      },
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelText: 'Search',
                        hintText: 'Seoul restaurant, ...',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _searchController.text.trim().isEmpty
                        ? const SizedBox.shrink() // Rien n'est affiché tant que l'utilisateur n'a rien tapé
                        : _searchResults.isEmpty
                            ? const Center(child: Text("No results ..."))
                            : SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: _searchResults.map((spot) {
                                    final title = spot['title'] ?? 'No title';
                                    final description = spot['description'] ?? '';
                                    final categoryString = spot['category'];
                                    final spotCategory = SpotCategory.fromString(categoryString);
                                    
                                    return Padding(
                                      padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10),
                                      child : Material(
                                        color: Colors.white, 
                                        borderRadius: BorderRadius.circular(12),
                                        elevation: 0, 
                                        child: InkWell(
                                          onTap: () {
                                            final spotId = spot['id'];
                                            final lat = spot['lat'];
                                            final lng = spot['lng'];

                                            Navigator.pop(context, {
                                              'id': spotId,
                                              'lat': lat,
                                              'lng': lng,
                                            });
                                          },
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.shade300),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  spotCategory.emoji, 
                                                  style: const TextStyle(fontSize: 24),
                                                ),
                                                const SizedBox(width: 15),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        title,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        description,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.grey.shade600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}