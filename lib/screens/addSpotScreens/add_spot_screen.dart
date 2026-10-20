import 'package:flutter/material.dart';
import 'package:supermapper_app/configuration/feedback_category.dart';
import 'package:supermapper_app/screens/addSpotScreens/add_spot_stepDetails.dart';
import 'package:supermapper_app/screens/addSpotScreens/add_spot_stepLocation.dart';
import 'package:supermapper_app/screens/addSpotScreens/add_spot_stepMap.dart';
import 'package:supermapper_app/services/spots_service.dart';
import 'package:supermapper_app/theme.dart';

class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({
    super.key,
    this.initialLat,
    this.initialLng,
    this.initialZoom,
  });

  final double? initialLat;
  final double? initialLng;
  final double? initialZoom;

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {

  int _step = 0;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  FeedbackCategory? _categorySelected;
  double? _latitude;
  double? _longitude;
  double? _zoom;

  final _spotService = SpotService();

  bool _isSaving = false;

  static const _titles = ['Choose location', 'Spot details', 'Spot Location'];
  static const _subtitles = ['Pan and zoom to place the pin', 'Specify details about your spot', 'Subtitle'];

  bool get _isDetailsValid =>
      _titleController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty &&
      _categorySelected != null;

  void _next() {
    if (_isSaving) return;
    switch (_step) {
      case 0:
        if(_latitude == null || _longitude == null) return;
        setState(() => _step = 1);
      case 1:
        //Verif title and description filled
        if(!_isDetailsValid || _latitude == null || _longitude == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all the mandatory information.'),
              behavior: SnackBarBehavior.floating,
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

  void _onLocationChanged(double lat, double lng, double zoom,) {
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
        const SnackBar(
          content: Text('Could not save the spot. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      
      );
    }
  }
  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLat;
    _longitude = widget.initialLng;
    _zoom = widget.initialZoom;
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
        appBar: AppBar(
          backgroundColor: AppColors.surfaceLight,
          surfaceTintColor: Colors.transparent,
          elevation: 4,
          scrolledUnderElevation: 4,
          shadowColor: Colors.black54,
          toolbarHeight: 76,
          automaticallyImplyLeading: false,
          leadingWidth: 68,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
            child: IconButton(
              onPressed: _back,
              style: IconButton.styleFrom(
                shape: CircleBorder(),
              ),
              icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 24),
            ),
          ),
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _titles[_step],
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              Text(
                _subtitles[_step],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(minimumSize: const Size(90, 40)),
                child: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_step == _titles.length - 1 ? 'Save' : 'Next'),
              ),
            ),
          ],
        ),
        body: switch (_step) {
          0 => AddSpotStepMap(
                onLocationChanged: _onLocationChanged,
                initialLatitude: _latitude,
                initialLongitude: _longitude,
                initialZoom: _zoom,
              ),
          1 => AddSpotStepDetails(
                titleController: _titleController,
                descriptionController: _descriptionController,
                category: _categorySelected,
                onCategoryChanged: (value) {
                  setState(() => _categorySelected = value);
                },
              ),
          2 => AddSpotStepLocation(),
          _ => const SizedBox.shrink(),
        },
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