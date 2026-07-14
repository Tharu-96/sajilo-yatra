import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/input_field.dart';
import '../../../shared/widgets/elevated_card.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Where to?',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 24),
                  InputField(
                    hintText: 'Search destination...',
                    prefixIcon: Icons.search,
                    readOnly: true,
                    onTap: () => context.push('/picker'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const Text('Recent', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.outline)),
                  const SizedBox(height: 12),
                  ElevatedCard(
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      leading: const Icon(Icons.history, color: AppColors.sapphireBlue),
                      title: const Text('Ratnapark'),
                      subtitle: const Text('Kathmandu'),
                      onTap: () => context.push('/picker'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedCard(
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      leading: const Icon(Icons.history, color: AppColors.sapphireBlue),
                      title: const Text('Kalanki'),
                      subtitle: const Text('Kathmandu'),
                      onTap: () => context.push('/picker'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
