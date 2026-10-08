import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';

class Screen08SubstitutionFoul extends StatefulWidget {
  const Screen08SubstitutionFoul({Key? key}) : super(key: key);

  @override
  State<Screen08SubstitutionFoul> createState() =>
      _Screen08SubstitutionFoulState();
}

class _Screen08SubstitutionFoulState extends State<Screen08SubstitutionFoul> {
  int? _selectedStarterIndex;
  int? _selectedBenchIndex;

  @override
  Widget build(BuildContext context) {
    final game = GameSessionController.instance;

    return Scaffold(
      backgroundColor: CourtKingTheme.pureWhite,
      appBar: AppBar(
        title: const Text('SUBSTITUTIONS & FOULS'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Side-by-side header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'ACTIVE STARTERS',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Icon(Icons.swap_horiz, color: CourtKingTheme.textSubtle),
                  Expanded(
                    child: Text(
                      'BENCH RESERVES',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Substitution Grid List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: game.activeStarters.length,
                itemBuilder: (context, index) {
                  final starter = game.activeStarters[index];
                  final bench = game.benchReserves[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        // Starter Card (Highlights danger foul zone)
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedStarterIndex = index),
                            child: _buildRosterCard(
                              starter,
                              _selectedStarterIndex == index,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Bench Card
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedBenchIndex = index),
                            child: _buildRosterCard(
                              bench,
                              _selectedBenchIndex == index,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Action: Confirm Subs & Return (Routes back to Screen 6 Arena)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
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
                    if (_selectedStarterIndex != null &&
                        _selectedBenchIndex != null) {
                      game.swapPlayers(
                        _selectedStarterIndex!,
                        _selectedBenchIndex!,
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'CONFIRM SUBS & RETURN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRosterCard(AthletePlayer athlete, bool selected) {
    final isDanger = athlete.personalFouls >= 4;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDanger ? const Color(0xFFFEF2F2) : CourtKingTheme.surfaceGray,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected
              ? CourtKingTheme.neonAmber
              : (isDanger
                    ? CourtKingTheme.dangerRed
                    : CourtKingTheme.borderLight),
          width: selected ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  athlete.avatarUrl,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  athlete.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                athlete.position,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  color: CourtKingTheme.textSubtle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fouls: ${athlete.personalFouls}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: isDanger
                      ? CourtKingTheme.dangerRed
                      : CourtKingTheme.slateNavy,
                ),
              ),
              Text(
                '${(athlete.stamina * 100).toInt()}% Stm',
                style: const TextStyle(
                  fontSize: 10,
                  color: CourtKingTheme.textSubtle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
