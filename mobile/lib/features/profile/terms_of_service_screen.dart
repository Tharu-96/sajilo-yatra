import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Terms of Service',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF003D5C)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Last Updated: July 10, 2026',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A9BB2)),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF4FC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Please read these terms carefully before using the Sajilo Yatra application.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF0F1E36), fontWeight: FontWeight.w500, height: 1.4),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 16),

                _buildSectionHeader(Icons.edit_road_outlined, '1. Acceptance of Terms'),
                const SizedBox(height: 8),
                const Text(
                  'By accessing or using the Sajilo Yatra mobile application or associated services (collectively, the "Service"), you agree to be bound by these Terms of Service.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF5A6B82), height: 1.4),
                ),
                const SizedBox(height: 20),

                _buildSectionHeader(Icons.person_search_outlined, '2. User Conduct'),
                const SizedBox(height: 8),
                const Text(
                  'You agree not to use the Service to:',
                  style: TextStyle(fontSize: 13, color: Color(0xFF5A6B82), height: 1.4),
                ),
                const SizedBox(height: 8),
                _buildNumberedPoint('1.', 'Violate any local, national, or international law or regulation.'),
                _buildNumberedPoint('2.', 'Interfere with or disrupt the integrity or performance of the Service.'),
                const SizedBox(height: 20),

                _buildSectionHeader(Icons.lock_outline, '3. Account Disclaimer'),
                const SizedBox(height: 8),
                const Text(
                  'If you create an account, you are responsible for maintaining the security of your account and password. The Service requires accurate information for route planning.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF5A6B82), height: 1.4),
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFE2E8F0)),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pops back to the primary About & Help screen
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF004F77),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 0,
                    ),
                    child: const Text('Accept & Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF004F77)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF003D5C)),
        ),
      ],
    );
  }

  Widget _buildNumberedPoint(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, left: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number ', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36))),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF5A6B82), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}