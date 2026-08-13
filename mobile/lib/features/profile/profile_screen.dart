import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/auth/auth_change_notifier.dart';
import '../../core/auth/auth_service.dart';

/// Profile & Settings screen.
/// Route: '/profile' (already registered in your bottom-nav shell).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _avatarBytes;

  static const _prefKeyName = 'profile_name';
  static const _prefKeyEmail = 'profile_email';

  String _name = ' Name';
  String _email = 'Email';

  /// When authenticated the name/email come from the account and are read-only.
  bool get _isAuthenticated => AuthChangeNotifier.instance.isLoggedIn;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authUser = AuthChangeNotifier.instance.user;
    if (authUser != null) {
      setState(() {
        _name = authUser.name;
        _email = authUser.email;
      });
      try {
        final avatarBytes = await AuthService.instance.getProfileImage();
        if (mounted) setState(() => _avatarBytes = avatarBytes);
      } on AuthException {
        // A missing image or temporary network issue should not block the profile.
      }
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString(_prefKeyName);
    final savedEmail = prefs.getString(_prefKeyEmail);
    if (mounted) {
      setState(() {
        if (savedName != null) _name = savedName;
        if (savedEmail != null) _email = savedEmail;
      });
    }
  }

  Future<void> _confirmSignOut() async {
    final scheme = Theme.of(context).colorScheme;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Sign Out', style: TextStyle(color: scheme.onSurface)),
        content: Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel', style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;
    await AuthService.instance.logout();
    if (mounted) context.go('/login');
  }

  Future<void> _editName() async {
    final controller = TextEditingController(text: _name);
    final scheme = Theme.of(context).colorScheme;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Name', style: TextStyle(color: scheme.onSurface)),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            filled: true,
            fillColor: scheme.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: scheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: scheme.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () {
              final trimmed = controller.text.trim();
              Navigator.pop(dialogContext, trimmed.isEmpty ? null : trimmed);
            },
            style: FilledButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result != _name) {
      setState(() => _name = result);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyName, result);
    }
  }

  Future<void> _editEmail() async {
    final controller = TextEditingController(text: _email);
    final scheme = Theme.of(context).colorScheme;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Email', style: TextStyle(color: scheme.onSurface)),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'name@example.com',
            filled: true,
            fillColor: scheme.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: scheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: scheme.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () {
              final email = controller.text.trim();
              Navigator.pop(dialogContext, email);
            },
            style: FilledButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result == null) return;
    if (!_isValidEmail(result)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a valid email address.')),
        );
      }
      return;
    }
    if (result != _email) {
      setState(() => _email = result);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyEmail, result);
    }
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);

  String get _initials {
    final parts = _name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return _name.isNotEmpty ? _name[0].toUpperCase() : '?';
  }

  Future<void> _pickAvatar() async {
    if (!_isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to save a profile image.')),
      );
      return;
    }

    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 512,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      await AuthService.instance.saveProfileImage(
        bytes,
        file.mimeType ?? 'image/jpeg',
      );
      if (mounted) setState(() => _avatarBytes = bytes);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to select a profile image. Please try again.')),
        );
      }
    }
  }

  Future<void> _removeAvatar() async {
    try {
      await AuthService.instance.deleteProfileImage();
      if (mounted) setState(() => _avatarBytes = null);
    } on AuthException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to remove profile image. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 120;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        title: Text(
          'SAJILO YATRA',
          style: TextStyle(
            color: scheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _AvatarBadge(
              initials: _initials,
              bytes: _avatarBytes,
              radius: 16,
              onTap: _pickAvatar,
              showEditIcon: false,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 24, 20, bottomPadding),
        children: [
          Center(
            child: _AvatarBadge(
              initials: _initials,
              bytes: _avatarBytes,
              radius: 44,
              onTap: _pickAvatar,
              showEditIcon: true,
            ),
          ),
          if (_isAuthenticated && _avatarBytes != null) ...[
            const SizedBox(height: 4),
            Center(
              child: TextButton.icon(
                onPressed: _removeAvatar,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Remove profile photo'),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Center(
            child: InkWell(
              onTap: _isAuthenticated ? null : _editName,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    if (!_isAuthenticated) ...[
                      const SizedBox(width: 6),
                      Icon(Icons.edit, size: 16, color: scheme.outline),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: InkWell(
              onTap: _isAuthenticated ? null : _editEmail,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _email,
                      style: TextStyle(fontSize: 14, color: scheme.primary),
                    ),
                    if (!_isAuthenticated) ...[
                      const SizedBox(width: 6),
                      Icon(Icons.edit, size: 14, color: scheme.outline),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          _SectionLabel('ACCOUNT SETTINGS'),
          const SizedBox(height: 8),
          _MenuCard(
            children: [
              _MenuTile(
                icon: Icons.language,
                iconColor: scheme.primary,
                title: 'Language',
                subtitle: 'English (US)',
                onTap: () => context.push('/profile/language'),
              ),
              _MenuDivider(),
              _MenuTile(
                icon: Icons.bookmark_outline,
                iconColor: scheme.primary,
                title: 'Saved Places',
                subtitle: 'Save your favourite locations',
                onTap: () => context.push('/saved'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionLabel('SUPPORT'),
          const SizedBox(height: 8),
          _MenuCard(
            children: [
              _MenuTile(
                icon: Icons.help_outline,
                iconColor: scheme.primary,
                title: 'About & Help',
                subtitle: 'FAQs, Contact Support',
                onTap: () => context.push('/profile/about'),
              ),
              _MenuDivider(),
              _MenuTile(
                icon: Icons.emergency_outlined,
                iconColor: scheme.error,
                title: 'Emergency Contacts',
                subtitle: 'Police, Medical & Emergency numbers',
                onTap: () => context.push('/profile/emergency'),
              ),
            ],
          ),
          if (_isAuthenticated) ...[
            const SizedBox(height: 24),
            _MenuCard(
              children: [
                _MenuTile(
                  icon: Icons.logout,
                  iconColor: scheme.error,
                  title: 'Sign Out',
                  subtitle: 'Log out of your account',
                  onTap: _confirmSignOut,
                  destructive: true,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({
    required this.initials,
    required this.bytes,
    required this.radius,
    required this.onTap,
    required this.showEditIcon,
  });

  final String initials;
  final Uint8List? bytes;
  final double radius;
  final VoidCallback onTap;
  final bool showEditIcon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer.withValues(alpha: 0.25),
      backgroundImage: bytes != null ? MemoryImage(bytes!) : null,
      child: bytes == null
          ? Text(
              initials,
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: radius * 0.65,
              ),
            )
          : null,
    );

    if (!showEditIcon) {
      return GestureDetector(onTap: onTap, child: avatar);
    }

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: scheme.primary, width: 2),
            ),
            child: avatar,
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.surface, width: 2),
              ),
              child: const Icon(Icons.edit, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
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

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});
  final List<Widget> children;

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
      child: Column(children: children),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 60,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: destructive ? scheme.error : scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (!destructive)
              Icon(Icons.chevron_right, color: scheme.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
