import 'package:flutter/material.dart';

/// ===============================================================
/// Search Field
/// ---------------------------------------------------------------
/// Reusable search field used in:
///
/// • Saved Places Screen
/// • Add New Location Screen
///
/// Features:
/// • Search icon
/// • Clear button
/// • Rounded Material 3 design
/// • Text controller support
/// • Auto focus support
/// • Read-only support
/// ===============================================================

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String hintText;
  final bool autofocus;
  final bool readOnly;
  final bool enabled;

  const SearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTap,
    this.hintText = 'Search location',
    this.autofocus = false,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      readOnly: readOnly,
      enabled: enabled,
      onChanged: onChanged,
      onTap: onTap,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              ),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}