import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../core/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final TextEditingController _fromController;
  final TextEditingController _toController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    final loc = LocationService().currentLocation.value;
    _fromController = TextEditingController(text: loc != null ? 'Current Location' : '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            InputField(
              hintText: 'From',
              prefixIcon: Icons.my_location,
              controller: _fromController,
            ),
            const SizedBox(height: 16),
            InputField(
              hintText: 'To',
              prefixIcon: Icons.location_on,
              controller: _toController,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Find Routes',
              onPressed: () {
                final loc = LocationService().currentLocation.value;
                final isCurrent = _fromController.text == 'Current Location' && loc != null;
                
                context.push('/preferences', extra: {
                  'from': _fromController.text,
                  'to': _toController.text,
                  'originLat': isCurrent ? loc.latitude : 27.7058,
                  'originLng': isCurrent ? loc.longitude : 85.3148,
                  'destLat': 27.6931,
                  'destLng': 85.2811,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
