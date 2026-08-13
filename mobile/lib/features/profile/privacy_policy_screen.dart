import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004F77)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sajilo Yatra',
          style: TextStyle(color: Color(0xFF004F77), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF5F8FC),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36)),
              ),
              const SizedBox(height: 6),
              Row(
                children: const [
                  Icon(Icons.history, size: 16, color: Color(0xFF5A6B82)),
                  SizedBox(width: 4),
                  Text(
                    'Last updated: July 10, 2026',
                    style: TextStyle(fontSize: 12, color: Color(0xFF5A6B82)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'At Sajilo Yatra, we are committed to engineering a secure and transparent precision transit experience. This policy outlines how we collect, utilize, and protect your data within our smart-city mobility platform.',
                style: TextStyle(fontSize: 14, color: Color(0xFF5A6B82), height: 1.4),
              ),
              const SizedBox(height: 24),

              // Card 1: Data Collection
              _buildPrivacyCard(
                title: 'Data Collection',
                content: [
                  const Text(
                    'To provide accurate routing and transit updates, we collect specific telemetry and usage metrics. This collection is strictly limited to functional requirements.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF5A6B82), height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  _buildListIconRow(Icons.location_on_outlined, 'Geolocation Data', 'Collected only when the app is active to determine optimal route proximity and estimate arrival times.'),
                  const SizedBox(height: 12),
                  _buildListIconRow(Icons.ad_units_outlined, 'Device Telemetry', 'Anonymous OS version, device model, and crash reports to ensure platform stability.'),
                  const SizedBox(height: 12),
                  _buildListIconRow(Icons.person_outline, 'Account Information', 'Optional profile data (name, email) if you choose to synchronize saved routes across devices.'),
                ],
              ),
              const SizedBox(height: 16),

              // Card 2: How We Use Your Info
              _buildPrivacyCard(
                title: 'How We Use Your Info',
                content: [
                  const Text(
                    'The data collected is engineered directly into improving your transit experience. We do not engage in arbitrary data mining. Your information powers the core logic of the Sajilo Yatra system.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF5A6B82), height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  _buildSubBanner('CORE OPERATIONS', 'Calculating ETA, rendering bus positions on the canvas, and processing localized transit alerts.'),
                  const SizedBox(height: 12),
                  _buildSubBanner('SYSTEM ANALYTICS', 'Aggregating anonymous travel patterns to optimize our routing algorithms and server load balancing.'),
                ],
              ),
              const SizedBox(height: 16),

              // Card 3: Third Party Sharing
              _buildPrivacyCard(
                title: 'Third Party Sharing',
                content: [
                  const Text(
                    'Sajilo Yatra operates on a strict principle of data minimization. We do not sell your personal telemetry to advertising networks.\n\nData is only shared with verified infrastructure partners essential for service delivery, such as:',
                    style: TextStyle(fontSize: 13, color: Color(0xFF5A6B82), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  _buildBulletPoint('Cloud hosting providers (for secure data storage and computation).'),
                  _buildBulletPoint('Mapping service APIs (strictly for rendering the geographic canvas; coordinates are processed anonymously where possible).'),
                  _buildBulletPoint('Municipal transit authorities (aggregated, non-identifiable statistics to improve city infrastructure).'),
                ],
              ),
              const SizedBox(height: 30),

              // Footer Contact area
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Have questions regarding our security protocols or data handling?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF5A6B82)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.push('/contact-support'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004F77),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text('Contact Privacy Team', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyCard({required String title, required List<Widget> content}) {
    return Container(
      width: double.infinity,
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
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(color: Color(0xFFEEF4FC), shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...content,
        ],
      ),
    );
  }

  Widget _buildListIconRow(IconData icon, String boldText, String normText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF004F77)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Color(0xFF5A6B82), height: 1.4),
              children: [
                TextSpan(text: '$boldText — ', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F1E36))),
                TextSpan(text: normText),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSubBanner(String label, String body) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4FC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF004F77), letterSpacing: 1.1),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(fontSize: 12, color: Color(0xFF5A6B82), height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004F77))),
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
