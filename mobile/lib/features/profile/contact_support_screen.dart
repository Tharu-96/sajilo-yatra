import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/api_service.dart';
import '../../core/auth/auth_change_notifier.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedSubject;
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  // Profile validation state
  bool _profileLoaded = false;
  bool _profileValid = false;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    String name = '';
    String email = '';

    final authUser = AuthChangeNotifier.instance.user;
    if (authUser != null) {
      name = authUser.name;
      email = authUser.email;
    } else {
      final prefs = await SharedPreferences.getInstance();
      name = prefs.getString('profile_name') ?? '';
      email = prefs.getString('profile_email') ?? '';
    }

    final valid = name.trim().isNotEmpty &&
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
    if (mounted) {
      setState(() {
        _profileLoaded = true;
        _profileValid = valid;
      });
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'bibektharu412@gmail.com',
      queryParameters: {
        'subject': 'Sajilo Yatra App Support Request',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email client.')),
        );
      }
    }
  }

  Future<void> _sendEmailFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String subject = _selectedSubject ?? 'Support Request';
    final String message = _messageController.text.trim();

    setState(() {
      _isSending = true;
    });

    try {
      await ApiService.sendFeedback(subject: subject, message: message);

      if (mounted) {
        setState(() {
          _selectedSubject = null;
          _messageController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback sent successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget _buildProfileGate() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFEEF4FC),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_off_outlined,
                  size: 48, color: Color(0xFF004F77)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Profile Setup Required',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F1E36)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'You need a valid name and email address on your profile before you can send feedback.',
              style: TextStyle(fontSize: 15, color: Color(0xFF5A6B82)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to profile tab
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go to Profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004F77),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004F77)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sajilo Yatra',
          style: TextStyle(color: Color(0xFF004F77), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: !_profileLoaded
          ? const Center(child: CircularProgressIndicator())
          : !_profileValid
              ? _buildProfileGate()
              : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // Bind the form key here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How can we help?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36)),
              ),
              const SizedBox(height: 8),
              const Text(
                'We’re here to assist you with your transit journey.',
                style: TextStyle(fontSize: 15, color: Color(0xFF5A6B82)),
              ),
              const SizedBox(height: 24),

              // Email Support Box
              GestureDetector(
                onTap: _launchEmail,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEF4FC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mail_outline, size: 28, color: Color(0xFF004F77)),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Email Support',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Feedback Form Area
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.chat_bubble_outline, color: Color(0xFF004F77)),
                        SizedBox(width: 8),
                        Text(
                          'Send Feedback',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text('Subject', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36))),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedSubject,
                      dropdownColor: Colors.white,
                      // Validation: Checks if subject selection is missing
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a subject';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEEF4FC),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFD2DFEE)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFD2DFEE)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      hint: const Text('Select a Subject', style: TextStyle(color: Color(0xFF5A6B82))),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF5A6B82)),
                      items: <String>['App Issue', 'Route Suggestion', 'Fare Dispute', 'General Inquiry']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Color(0xFF0F1E36))),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSubject = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    const Text('Message', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36))),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 5,
                      // Validation: Checks if message body is empty
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please write your message';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFEEF4FC),
                        errorStyle: const TextStyle(color: Colors.redAccent),
                        hintText: 'Describe your issue or feedback in detail...',
                        hintStyle: const TextStyle(color: Color(0xFF8A9BB2), fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFD2DFEE)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFD2DFEE)),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isSending ? null : _sendEmailFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004F77),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: _isSending
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Send Feedback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
