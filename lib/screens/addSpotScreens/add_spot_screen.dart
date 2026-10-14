import 'package:flutter/material.dart';
import 'package:supermapper_app/configuration/spot_category.dart';
import 'package:supermapper_app/screens/addSpotScreens/add_spot_stepDetails.dart';
import 'package:supermapper_app/screens/addSpotScreens/add_spot_stepMap.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/theme.dart';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {

  int _step = 0;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  SpotCategory? _categorySelected;
  double? _latitude;
  double? _longitude;

  final _spotService = SpotService();

  bool _isSaving = false;

  static const _titles = ['Choose location', 'Spot details'];
  static const _subtitles = ['Pan and zoom to place the pin', 'Specify details about your spot'];

  bool get _isDetailsValid =>
      _titleController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty &&
      _categorySelected != null;

  void _next() {
    switch (_step) {
      case 0:
        if(_latitude == null || _longitude == null) return;
        setState(() => _step = 1);
      case 1:
        //Verif title and description filled
        if(!_isDetailsValid || _latitude == null || _longitude == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please fill all needed informations.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 14),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.grey.shade500.withAlpha(200),
              duration: const Duration(milliseconds: 1200), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.only(bottom: 50, left: 50, right: 50),
            ),
          ); 
          return;
        }
        //Save in database
        _save();
    }
  }

  void _back() {
    if (_isSaving) return;
    if (_step == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _step = 0);
    }
  }

  void _onLocationChanged(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await _spotService.addSpot(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _categorySelected!,
        latitude: _latitude!,
        longitude: _longitude!,
      );
      if (!mounted) return;
      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the spot. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFirstStep = _step == 0;

    return PopScope(
      canPop: isFirstStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        body: Column(
          children: [
            //Header
            Container(
              color: AppColors.surfaceLight,
              child: SafeArea(
                bottom : false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _back,
                        icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 24),
                      ),
                      Column(
                        children : [
                          Text(
                            _titles[_step],
                            style: const TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Text(
                            _subtitles[_step],
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ]
                      ),
                      ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(minimumSize: const Size(90, 40)),
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,),
                              )
                            : Text(_step == _titles.length - 1 ? 'Save' : 'Next'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            //Body
            Expanded(
              child: switch (_step) {
                0 => AddSpotStepMap(
                  onLocationChanged: _onLocationChanged,
                  initialLatitude: _latitude,
                  initialLongitude: _longitude,
                ),
                1 => AddSpotStepDetails(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  category: _categorySelected,
                  onCategoryChanged: (value) {
                    setState(() {
                      _categorySelected = value;
                    });
                  },
                ),
                _ => const SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }
}