import 'package:flutter/material.dart';
import '../../../shared/widgets/primary_button.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 24),
              Text('No Internet Connection', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              const Text('Please check your network settings and try again.', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              PrimaryButton(text: 'Retry', onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
