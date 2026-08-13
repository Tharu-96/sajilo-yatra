import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/primary_button.dart';
import '../../core/theme/app_theme.dart';

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 360),
              padding: const EdgeInsets.fromLTRB(26, 54, 26, 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x160F1C2C),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFF8F8),
                      border: Border.all(color: const Color(0xFFF6D4D4)),
                    ),
                    child: const Icon(
                      Icons.location_off_rounded,
                      size: 52,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.outline,
                          height: 1.45,
                        ),
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(text: actionLabel, onPressed: onAction),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Back to home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
