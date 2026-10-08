import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';

class Screen07TimeoutTactics extends StatefulWidget {
  const Screen07TimeoutTactics({Key? key}) : super(key: key);

  @override
  State<Screen07TimeoutTactics> createState() => _Screen07TimeoutTacticsState();
}

class _Screen07TimeoutTacticsState extends State<Screen07TimeoutTactics> {
  @override
  Widget build(BuildContext context) {
    final game = GameSessionController.instance;

    return Scaffold(
      backgroundColor: CourtKingTheme.pureWhite,
      appBar: AppBar(
        title: const Text('TIMEOUT: 0:42 • Q3'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3D Tactical Board View
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFD2B48C), // Hardwood clipboard finish
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CourtKingTheme.slateNavy, width: 2),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dashboard_customize,
                        color: CourtKingTheme.slateNavy,
                        size: 40,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'COACH TACTICAL BOARD',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: CourtKingTheme.slateNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),

              const Text(
                'REAL-TIME PLAYER STAMINA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: CourtKingTheme.slateNavy,
                ),
              ),
              const SizedBox(height: 10),

              // Real-time Stamina Indicators
              Expanded(
                child: ListView.separated(
                  itemCount: game.activeStarters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final athlete = game.activeStarters[index];
                    return Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            athlete.avatarUrl,
                            width: 34,
                            height: 34,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${athlete.name} (#${athlete.jerseyNumber})',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: athlete.stamina,
                                minHeight: 5,
                                backgroundColor: CourtKingTheme.borderLight,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  CourtKingTheme.slateNavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${(athlete.stamina * 100).toInt()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Quick-Select Play Selector Cards
              const Text(
                'QUICK-SELECT OFFENSIVE PLAY',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPlayCard('Pick & Roll', game),
                  const SizedBox(width: 8),
                  _buildPlayCard('Isolation', game),
                  const SizedBox(width: 8),
                  _buildPlayCard('Corner 3', game),
                ],
              ),
              const SizedBox(height: 20),

              // Action CTA: Resume Game (Routes cleanly back to Screen 6 Arena)
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'RESUME GAME',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayCard(String title, GameSessionController game) {
    final isSelected = game.selectedOffensivePlay == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          game.triggerHaptic();
          setState(() => game.selectedOffensivePlay = title);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? CourtKingTheme.slateNavy
                : CourtKingTheme.surfaceGray,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? CourtKingTheme.neonAmber
                  : CourtKingTheme.borderLight,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : CourtKingTheme.slateNavy,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
