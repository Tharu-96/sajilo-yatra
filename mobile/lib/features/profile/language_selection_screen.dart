import 'package:flutter/material.dart';

/// Language Selection screen.
/// Route: '/profile/language'
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selected = 'en_US';

  final List<_LanguageOption> _options = const [
    _LanguageOption(code: 'en_US', label: 'English (US)', isDefault: true),
    _LanguageOption(code: 'ne', label: 'Nepali (नेपाली)  (coming soon)'),
    _LanguageOption(code: 'hi', label: 'Hindi (हिंदी)  (coming soon)'),
  ];

  void _saveChanges() {
    // TODO: persist selection (shared_preferences) and apply locale app-wide.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language preference saved')),
    );
    Navigator.of(context).pop();
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
          'Language',
          style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your preferred language for the app interface.',
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _options.length; i++) ...[
                    _LanguageTile(
                      option: _options[i],
                      selected: _selected == _options[i].code,
                      onTap: () => setState(() => _selected = _options[i].code),
                    ),
                    if (i != _options.length - 1)
                      Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: scheme.outlineVariant,
                      ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saveChanges,
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({
    required this.code,
    required this.label,
    this.isDefault = false,
  });
  final String code;
  final String label;
  final bool isDefault;
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _LanguageOption option;
  final bool selected;
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface),
                  ),
                  if (option.isDefault)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Default',
                        style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                      ),
                    ),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: selected ? true : null,
              onChanged: (_) => onTap(),
              activeColor: scheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}