import 'package:flutter/material.dart';
import '../../../shared/widgets/elevated_card.dart';

class SavedPlacesScreen extends StatelessWidget {
  const SavedPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Places'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ElevatedCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
                    title: const Text('Home'),
                    subtitle: const Text('Baneshwor, Kathmandu'),
                    trailing: const Icon(Icons.more_vert),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.work, color: Theme.of(context).colorScheme.primary),
                    title: const Text('Office'),
                    subtitle: const Text('Putalisadak, Kathmandu'),
                    trailing: const Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
    );
  }
}
