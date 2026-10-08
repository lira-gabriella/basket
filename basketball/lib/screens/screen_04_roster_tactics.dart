import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';
import '../main.dart';

class Screen04RosterTactics extends StatefulWidget {
  const Screen04RosterTactics({Key? key}) : super(key: key);

  @override
  State<Screen04RosterTactics> createState() => _Screen04RosterTacticsState();
}

class _Screen04RosterTacticsState extends State<Screen04RosterTactics> {
  int _selectedPositionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final game = GameSessionController.instance;
    final currentAthlete = game.activeStarters[_selectedPositionIndex];

    return Scaffold(
      backgroundColor: CourtKingTheme.pureWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('TACTICAL SETUP'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Half-Court Interactive Tactical Grid
            Container(
              height: 240,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8D4B0), // Hardwood stylized tint
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: CourtKingTheme.borderLight, width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Painted Key and 3pt Line SVG Mockup
                  Container(
                    width: 140,
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(70),
                      ),
                    ),
                  ),
                  // Position Buttons (PG, SG, SF, PF, C)
                  Positioned(
                    top: 20,
                    left: 60,
                    child: _buildPlayerPin(0, 'PG', game),
                  ),
                  Positioned(
                    top: 20,
                    right: 60,
                    child: _buildPlayerPin(1, 'SG', game),
                  ),
                  Positioned(top: 90, child: _buildPlayerPin(2, 'C', game)),
                  Positioned(
                    bottom: 20,
                    left: 40,
                    child: _buildPlayerPin(3, 'SF', game),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 40,
                    child: _buildPlayerPin(4, 'PF', game),
                  ),
                ],
              ),
            ),

            // Player Inspector Card (Dark Slate Container)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CourtKingTheme.slateNavy,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'PLAYER INSPECTOR',
                          style: TextStyle(
                            color: CourtKingTheme.neonAmber,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'OVR 92',
                            style: const TextStyle(
                              color: CourtKingTheme.crispCyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Athlete Portrait & Details
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            currentAthlete.avatarUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentAthlete.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              '${currentAthlete.position} • #${currentAthlete.jerseyNumber}',
                              style: const TextStyle(
                                color: CourtKingTheme.textSubtle,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Attribute Progress Meters
                    _buildStatBar(
                      'Speed Rating',
                      currentAthlete.speed,
                      CourtKingTheme.neonAmber,
                    ),
                    const SizedBox(height: 10),
                    _buildStatBar(
                      '3PT Shooting Acc.',
                      currentAthlete.threePoint,
                      CourtKingTheme.crispCyan,
                    ),
                    const SizedBox(height: 10),
                    _buildStatBar(
                      'Perimeter Defense',
                      currentAthlete.defense,
                      CourtKingTheme.crispCyan,
                    ),
                    const Spacer(),

                    // Action CTA: Lock Lineup & Walk Out (Routes to Screen 5)
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          game.triggerHaptic();
                          Navigator.pushNamed(
                            context,
                            CourtKingRoutes.preMatchTipoff,
                          );
                        },
                        child: const Text(
                          'LOCK LINEUP & WALK OUT',
                          style: TextStyle(
                            color: CourtKingTheme.slateNavy,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
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
    );
  }

  Widget _buildPlayerPin(int index, String pos, GameSessionController game) {
    final isSelected = _selectedPositionIndex == index;
    return GestureDetector(
      onTap: () {
        game.triggerHaptic();
        setState(() => _selectedPositionIndex = index);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isSelected
                ? CourtKingTheme.neonAmber
                : CourtKingTheme.slateNavy,
            child: Text(
              pos,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBar(String label, double val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: CourtKingTheme.textSubtle,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(val * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: val,
            minHeight: 6,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
