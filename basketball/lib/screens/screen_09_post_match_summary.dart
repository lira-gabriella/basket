import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';
import '../main.dart';

class Screen09PostMatchSummary extends StatelessWidget {
  const Screen09PostMatchSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = GameSessionController.instance;

    return Scaffold(
      backgroundColor: CourtKingTheme.pureWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Brand
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'CourtKing',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: CourtKingTheme.slateNavy,
                    ),
                  ),
                  Text(
                    'OFFICIAL FINAL',
                    style: TextStyle(
                      color: CourtKingTheme.textSubtle,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Victory Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VICTORY ${game.homeScore} - ${game.awayScore}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: CourtKingTheme.slateNavy,
                    ),
                  ),
                  const Icon(
                    Icons.emoji_events,
                    color: CourtKingTheme.neonAmber,
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Detailed Stats Grid
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CourtKingTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: CourtKingTheme.borderLight),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PLAYER',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: CourtKingTheme.textSubtle,
                          ),
                        ),
                        Text(
                          'PTS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: CourtKingTheme.textSubtle,
                          ),
                        ),
                        Text(
                          'AST',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: CourtKingTheme.textSubtle,
                          ),
                        ),
                        Text(
                          'REB',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: CourtKingTheme.textSubtle,
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 16),
                    _StatRow(
                      name: 'Marcus Vance',
                      pts: '38',
                      ast: '8',
                      reb: '7',
                    ),
                    _StatRow(
                      name: 'LeBron James',
                      pts: '24',
                      ast: '5',
                      reb: '14',
                    ),
                    _StatRow(
                      name: 'Stephen Curry',
                      pts: '18',
                      ast: '3',
                      reb: '11',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // High-Contrast Progression Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CourtKingTheme.slateNavy,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PROGRESSION UPDATE',
                      style: TextStyle(
                        color: CourtKingTheme.neonAmber,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Level 1 Cleared ➔ Level 2 (All-Star) Unlocked',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 1.0,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CourtKingTheme.neonAmber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Threat Warning Alert Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Color(0xFFB45309)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Level 2 Threat: Opponent AI defensive speed increased by 35%!',
                        style: TextStyle(
                          color: Color(0xFFB45309),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Action CTA: Continue Campaign (Routes to Screen 10 Settings & Summary)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CourtKingTheme.neonAmber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    game.triggerHaptic();
                    game.advanceToLevel2();
                    Navigator.pushNamed(
                      context,
                      CourtKingRoutes.settingsSignOut,
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue Campaign',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.sports_basketball, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String name;
  final String pts;
  final String ast;
  final String reb;
  const _StatRow({
    required this.name,
    required this.pts,
    required this.ast,
    required this.reb,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            pts,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: CourtKingTheme.neonAmber,
            ),
          ),
          Text(ast, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(reb, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
