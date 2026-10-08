import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';
import '../main.dart';

class Screen02MainMenu extends StatelessWidget {
  const Screen02MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = GameSessionController.instance;

    return Scaffold(
      backgroundColor: CourtKingTheme.pureWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: CourtKingTheme.slateNavy,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shield,
                          color: CourtKingTheme.neonAmber,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'CourtKing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: CourtKingTheme.slateNavy,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: CourtKingTheme.slateNavy,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Avatar Showcase Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CourtKingTheme.slateNavy,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: CourtKingTheme.neonAmber.withOpacity(0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 20,
                        child: Row(
                          children: [
                            Text(
                              game.userProfile.username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified,
                              color: CourtKingTheme.crispCyan,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      // 3D Avatar Center Graphic
                      Positioned(
                        top: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
                            width: 170,
                            height: 190,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Tier Status Box
                      Positioned(
                        bottom: 24,
                        left: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CURRENT TIER: LEVEL ${game.gameLevel} (${game.userProfile.rankTitle.toUpperCase()})',
                                style: const TextStyle(
                                  color: CourtKingTheme.neonAmber,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: game.gameLevel == 1 ? 0.35 : 0.85,
                                  minHeight: 8,
                                  backgroundColor: Colors.white24,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        CourtKingTheme.neonAmber,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Career Path Nodes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCareerNode('Rookie', true),
                  _buildCareerNode('Pro', game.gameLevel >= 2),
                  _buildCareerNode('Elite', false),
                  _buildCareerNode('Legend', false),
                ],
              ),
              const SizedBox(height: 24),

              // Primary Action: Start Tournament Campaign (Routes to Screen 3)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CourtKingTheme.slateNavy,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    game.triggerHaptic();
                    Navigator.pushNamed(
                      context,
                      CourtKingRoutes.tournamentBracket,
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'START TOURNAMENT CAMPAIGN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.sports_basketball,
                        color: CourtKingTheme.neonAmber,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Bottom Navigation Dock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavIcon(Icons.home, 'Home', true),
                  _buildNavIcon(Icons.play_circle_outline, 'Play', false),
                  _buildNavIcon(Icons.bar_chart, 'Leaderboard', false),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      CourtKingRoutes.settingsSignOut,
                    ),
                    child: _buildNavIcon(Icons.settings, 'Settings', false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCareerNode(String title, bool active) {
    return Column(
      children: [
        Icon(
          Icons.shield,
          color: active ? CourtKingTheme.slateNavy : CourtKingTheme.borderLight,
          size: 26,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: active
                ? CourtKingTheme.slateNavy
                : CourtKingTheme.textSubtle,
          ),
        ),
      ],
    );
  }

  Widget _buildNavIcon(IconData icon, String label, bool selected) {
    return Column(
      children: [
        Icon(
          icon,
          color: selected
              ? CourtKingTheme.neonAmber
              : CourtKingTheme.textSubtle,
          size: 22,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: selected
                ? CourtKingTheme.neonAmber
                : CourtKingTheme.textSubtle,
          ),
        ),
      ],
    );
  }
}
