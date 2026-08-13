import 'package:flutter/material.dart';
import 'contact_support_screen.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help & FAQs',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003D5C),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find answers to common questions about navigating Kathmandu with Sajilo Yatra.',
                style: TextStyle(fontSize: 14, color: Color(0xFF5A6B82), height: 1.4),
              ),
              const SizedBox(height: 24),

              _buildCategoryHeader(Icons.info_outline, 'General'),
              const SizedBox(height: 12),
              _buildFAQTile(
                question: 'What is Sajilo Yatra?',
                answer:
                    'Sajilo Yatra is your smart-city transit companion for Kathmandu. It provides route planning and bus information for public transportation to make your daily commute seamless and predictable.',
              ),
              const SizedBox(height: 24),

              _buildCategoryHeader(Icons.alt_route_outlined, 'Routes & Schedules'),
              const SizedBox(height: 12),
              _buildFAQTile(
                question: 'How do I find the routes?',
                answer:
                    "Enter your destination in the Search bar on the Home screen. Sajilo Yatra's routing engine automatically find outs the possible bus routes based on your preference.",
              ),
              const SizedBox(height: 12),
              _buildFAQTile(
                question: 'Are Bus schedules updated in real-time?',
                answer:
                    'No, We are working on this feature. If this feature is available, you will see a "live" indicator on the active journey screen.',
              ),
              const SizedBox(height: 24),

              _buildCategoryHeader(Icons.credit_card_outlined, 'Fares'),
              const SizedBox(height: 12),
              _buildFAQTile(
                question: 'Can I pay digitally through the app?',
                answer:
                    "Currently, digital payment integration is not available because it is in beta testing on select routes. If available, you will see a 'Pay Now' button on the active journey screen. The bus fare is actually an approximate fare, not exact fare for now.",
              ),
              const SizedBox(height: 30),

              // Help Banner — Redirects to Contact Support
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4FC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFD3E2F4)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Still need help?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Our support team is available 24/7.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF5A6B82)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ContactSupportScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004F77),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text('Contact Support', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFE2EAF4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF004F77)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F1E36)),
        ),
      ],
    );
  }

  Widget _buildFAQTile({required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: const Color(0xFF5A6B82),
          collapsedIconColor: const Color(0xFF5A6B82),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F1E36),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5A6B82),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}