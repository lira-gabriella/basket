import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';
import '../main.dart';

class Screen05PreMatchTipoff extends StatefulWidget {
  const Screen05PreMatchTipoff({Key? key}) : super(key: key);

  @override
  State<Screen05PreMatchTipoff> createState() => _Screen05PreMatchTipoffState();
}

class _Screen05PreMatchTipoffState extends State<Screen05PreMatchTipoff>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _tapped = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTipOffTap() {
    if (_tapped) return;
    _tapped = true;
    final game = GameSessionController.instance;
    game.triggerSuccessHaptic();

    // Reward initial momentum and transition into Arena (Screen 6)
    game.teamMomentum = 0.70;
    Navigator.pushReplacementNamed(context, CourtKingRoutes.liveMatchArena);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CourtKingTheme.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Top HUD Scoreboard Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: CourtKingTheme.slateNavy,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'HOME: 0',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Q1 12:00 • TIP-OFF',
                    style: TextStyle(
                      color: CourtKingTheme.neonAmber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'AWAY: 0',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Center Court Hardwood Circle Graphic
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: CourtKingTheme.borderLight,
                        width: 3,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'COURTKING',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: CourtKingTheme.surfaceGray,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),

                  // Center Player Avatars Jumping
                  Positioned(
                    top: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 40),
                        ClipOval(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pulsing Center Basketball
                  Positioned(
                    top: 70,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: CourtKingTheme.neonAmber.withOpacity(
                                  0.4 + (_pulseController.value * 0.4),
                                ),
                                blurRadius: 18,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.sports_basketball,
                            color: CourtKingTheme.neonAmber,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),

                  // Interactive Tap-to-Win Dial (Routes to Screen 6)
                  Positioned(
                    bottom: 40,
                    child: GestureDetector(
                      onTap: _onTipOffTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: CourtKingTheme.slateNavy,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: CourtKingTheme.neonAmber,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: CourtKingTheme.neonAmber.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'TAP TO WIN TIP-OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Time your tap perfectly for possession!',
                              style: TextStyle(
                                color: CourtKingTheme.neonAmber,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
