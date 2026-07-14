import 'package:flutter/material.dart';
import '../../../shared/widgets/primary_button.dart';

class ErrorEmptyScreen extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onAction;
  final String actionLabel;

  const ErrorEmptyScreen({
    super.key,
    required this.title,
    required this.message,
    required this.onAction,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 24),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              PrimaryButton(text: actionLabel, onPressed: onAction),
            ],
          ),
        ),
      ),
    );
  }
}
