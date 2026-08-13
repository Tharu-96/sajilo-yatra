import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// About & Help screen.
/// Route: '/profile/about'
class AboutHelpScreen extends StatelessWidget {
  const AboutHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        leading: BackButton(color: scheme.primary),
        title: Text(
          'Sajilo Yatra',
          style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Text(
            'About & Help',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Find answers, contact support, and learn more about Sajilo Yatra's "
            'policies and services.',
            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 24),
          _HelpCard(
            icon: Icons.help_outline,
            title: 'FAQs',
            subtitle: 'Frequently asked questions',
            onTap: () => context.push('/faqs'),
          ),
          const SizedBox(height: 12),
          _HelpCard(
            icon: Icons.headset_mic_outlined,
            title: 'Contact Support',
            subtitle: 'Get help from our team',
            onTap: () => context.push('/contact-support'),
          ),
          const SizedBox(height: 24),
          Text(
            'Legal & Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              children: [
                _LegalTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacy Policy',
                  onTap: () => context.push('/profile/privacy'),
                ),
                Divider(height: 1, indent: 16, endIndent: 16, color: scheme.outlineVariant),
                _LegalTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => context.push('/terms-of-service'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '© 2026 Sajilo Yatra',
              style: TextStyle(fontSize: 12, color: scheme.outline),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  const _HelpCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: scheme.onSurface.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
              child: Icon(icon, color: scheme.onPrimary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: scheme.onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.outline),
          ],
        ),
      ),
    );
  }
}

class _LegalTile extends StatelessWidget {
  const _LegalTile({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: scheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface)),
            ),
            Icon(Icons.chevron_right, size: 18, color: scheme.outline),
          ],
        ),
      ),
    );
  }
}
