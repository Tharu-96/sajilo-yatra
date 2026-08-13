import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  static const _police = [
    _Contact('Police Control Room', '100'),
    _Contact('Traffic Police', '103'),
    _Contact('Tourist Police', '01-4247041'),
  ];

  static const _medical = [
    _Contact('Ambulance', '102'),
    _Contact('Red Cross Ambulance', '01-4228094'),
    _Contact('Bir Hospital', '01-4221119'),
    _Contact('Patan Hospital', '01-5522268'),
  ];

  Future<void> _dial(BuildContext context, String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the dialer.')),
        );
      }
    }
  }

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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Emergency Contacts',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          // Hint bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          const _SectionLabel('Police'),
          const SizedBox(height: 8),
          _ContactCard(contacts: _police, onDial: (n) => _dial(context, n)),
          const SizedBox(height: 24),
          const _SectionLabel('Medical'),
          const SizedBox(height: 8),
          _ContactCard(contacts: _medical, onDial: (n) => _dial(context, n)),
        ],
      ),
    );
  }
}

class _Contact {
  const _Contact(this.name, this.number);
  final String name;
  final String number;
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contacts, required this.onDial});

  final List<_Contact> contacts;
  final void Function(String number) onDial;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
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
      child: Column(
        children: [
          for (int i = 0; i < contacts.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: 16,
                endIndent: 16,
                color: scheme.outlineVariant,
              ),
            _ContactTile(contact: contacts[i], onDial: onDial),
          ],
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact, required this.onDial});

  final _Contact contact;
  final void Function(String number) onDial;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.number,
                  style: TextStyle(fontSize: 13, color: scheme.primary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onDial(contact.number),
            icon: Icon(Icons.phone, color: scheme.primary),
            tooltip: 'Call ${contact.number}',
          ),
        ],
      ),
    );
  }
}
