import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class InputField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  const InputField({
    super.key,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(AppRadius.input),
          border: Border.all(
            color: _isFocused ? AppColors.sapphireBlue : AppColors.outline.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppColors.sapphireBlue.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: AppColors.onSurface.withOpacity(0.5)),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _isFocused ? AppColors.sapphireBlue : AppColors.outline,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}
