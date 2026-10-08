import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';
import '../main.dart';

class Screen01Registration extends StatefulWidget {
  const Screen01Registration({Key? key}) : super(key: key);

  @override
  State<Screen01Registration> createState() => _Screen01RegistrationState();
}

class _Screen01RegistrationState extends State<Screen01Registration> {
  final TextEditingController _tagController = TextEditingController(
    text: '#KING99',
  );
  String _selectedRegion = 'North America';

  void _onRegister() {
    final game = GameSessionController.instance;
    game.triggerHaptic();
    game.userProfile.tag = _tagController.text.trim();
    game.userProfile.region = _selectedRegion;

    Navigator.pushReplacementNamed(context, CourtKingRoutes.mainMenu);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CourtKingTheme.pureWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Brand Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    backgroundColor: CourtKingTheme.surfaceGray,
                    child: Icon(
                      Icons.person_outline,
                      color: CourtKingTheme.slateNavy,
                    ),
                  ),
                  const Text(
                    'CourtKing',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: CourtKingTheme.slateNavy,
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: CourtKingTheme.slateNavy,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Hero Mid-Dunk Showcase Card
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CourtKingTheme.slateNavy,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: CourtKingTheme.neonAmber.withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&w=800&q=80',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              CourtKingTheme.slateNavy.withOpacity(0.85),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: CourtKingTheme.neonAmber,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.sports_basketball,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SEASON 01 LAUNCH',
                                  style: TextStyle(
                                    color: CourtKingTheme.neonAmber,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  'Dominate the Hardwood',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Form Header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'REGISTER TO PLAY',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: CourtKingTheme.slateNavy.withOpacity(0.8),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Input: Player Tag
              _buildFieldWrapper(
                label: 'PLAYER TAG',
                child: TextField(
                  controller: _tagController,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: CourtKingTheme.slateNavy,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      Icons.person,
                      color: CourtKingTheme.textSubtle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Dropdown: Region
              _buildFieldWrapper(
                label: 'REGION',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRegion,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.public,
                      color: CourtKingTheme.textSubtle,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'North America',
                        child: Text('North America'),
                      ),
                      DropdownMenuItem(
                        value: 'Europe Central',
                        child: Text('Europe Central'),
                      ),
                      DropdownMenuItem(
                        value: 'Asia Pacific',
                        child: Text('Asia Pacific'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedRegion = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Action CTA: Create Player & Enter Arena
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CourtKingTheme.neonAmber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _onRegister,
                  child: const Text(
                    'Create Player & Enter Arena',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Already have an account? Sign In',
                style: TextStyle(
                  color: CourtKingTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldWrapper({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CourtKingTheme.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CourtKingTheme.borderLight, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: CourtKingTheme.textSubtle,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
