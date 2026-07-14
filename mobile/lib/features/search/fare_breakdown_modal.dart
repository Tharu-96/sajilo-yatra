import 'package:flutter/material.dart';

class FareBreakdownModal extends StatelessWidget {
  final Map<String, dynamic> route;
  const FareBreakdownModal({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final legs = route['legs'] as List;
    final busLegs = legs.where((leg) => leg['mode'] == 'bus').toList();
    final totalFare = route['total_fare_npr'] ?? 0;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Fare Breakdown', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 24),
          ...busLegs.map((leg) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildRow('${leg['from_stop']} to ${leg['to_stop']}', 'Rs. ${leg['fare_npr']}'),
            );
          }),
          if (busLegs.isEmpty) _buildRow('No bus fare needed', 'Rs. 0'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: Theme.of(context).colorScheme.outline),
          ),
          _buildRow('Total', 'Rs. $totalFare', isBold: true),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String amount, {bool isBold = false}) {
    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      );
    });
  }
}
