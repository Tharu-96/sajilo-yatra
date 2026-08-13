import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/widgets/input_field.dart';
import '../../core/auth/auth_change_notifier.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<_ExplorePlace> _places = [
    _ExplorePlace(
      title: 'Basantapur',
      image: 'images/basantapur_durbar_square.jpg',
    ),
    _ExplorePlace(
      title: 'Patan',
      image: 'images/patan_krishna_mandir.jpg',
    ),
    _ExplorePlace(
      title: 'Swayambhu',
      image: 'images/swayambhunath.jpg',
    ),
    _ExplorePlace(
      title: 'Bhaktapur',
      image: 'images/bhaktapur_durbar_square.jpg',
    ),
    _ExplorePlace(
      title: 'Boudhanath',
      image: 'images/boudhanath.jpg',
    ),
    _ExplorePlace(
      title: 'Garden of Dreams',
      image: 'images/Garden of Dreams.jpg',
    ),
    _ExplorePlace(
      title: 'Pashupatinath',
      image: 'images/Pashupatinath.jpg',
    ),
    _ExplorePlace(
      title: 'Thamel',
      image: 'images/Thamel.jpg',
    ),
  ];

  String _firstName(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return 'there';
    return fullName.trim().split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AuthChangeNotifier.instance,
      builder: (context, _) {
        final firstName = _firstName(AuthChangeNotifier.instance.user?.name);
        return Scaffold(
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _Greeting(name: firstName),
                const SizedBox(height: 20),
                Text(
                  'Where to go?',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 16),
                InputField(
                  hintText: 'Search destination...',
                  prefixIcon: Icons.search,
                  readOnly: true,
                  onTap: () => context.push('/picker'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _QuickCard(
                        icon: Icons.directions_bus,
                        iconColor: AppColors.sapphireBlue,
                        iconBackground: AppColors.primaryBright,
                        title: 'City Bus',
                        subtitle: 'Find routes & timings',
                        onTap: () => context.push('/picker'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickCard(
                        icon: Icons.emergency_share,
                        iconColor: AppColors.error,
                        iconBackground: const Color(0xFFFFE1E1),
                        title: 'Emergency',
                        subtitle: 'Quick help & contacts',
                        onTap: () => context.push('/profile/emergency'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'FEATURED',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 12),
                _FeaturedBanner(onFindRoutes: () => context.push('/picker')),
                const SizedBox(height: 28),
                const Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _places.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) =>
                        _ExploreCard(place: _places[index]),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
        children: [
          const TextSpan(text: 'Hello '),
          TextSpan(
            text: name,
            style: const TextStyle(color: AppColors.sapphireBlue),
          ),
          const TextSpan(text: ' !'),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner({required this.onFindRoutes});

  final VoidCallback onFindRoutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B3C6E),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.star, color: Color(0xFFFFC629), size: 18),
              SizedBox(width: 8),
              Text(
                "Today's Pick",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Explore Kathmandu Valley',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Discover the best routes in the valley',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onFindRoutes,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.sapphireBlue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.input),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Find Routes',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({required this.place});

  final _ExplorePlace place;

  Future<void> _openMap() async {
    final query = Uri.encodeComponent(place.title);
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$query');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch map for ${place.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: InkWell(
              onTap: _openMap,
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: Image.asset(
                  place.image,
                  width: 150,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 150,
                    height: 120,
                    color: AppColors.surfaceContainer,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.outline,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            place.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplorePlace {
  const _ExplorePlace({
    required this.title,
    required this.image,
  });

  final String title;
  final String image;
}
