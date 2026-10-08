import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';
import '../main.dart';

class Screen03TournamentBracket extends StatelessWidget {
  const Screen03TournamentBracket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = GameSessionController.instance;

    return Scaffold(
      backgroundColor: CourtKingTheme.pureWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('PLAYOFF CAMPAIGN'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: CourtKingTheme.surfaceGray,
              child: Icon(
                Icons.person,
                color: CourtKingTheme.slateNavy,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Round Selector Tabs
              Row(
                children: [
                  _buildTab('Round 1', true),
                  const SizedBox(width: 8),
                  _buildTab('Semifinals', false),
                  const SizedBox(width: 8),
                  _buildTab('Finals', false),
                ],
              ),
              const SizedBox(height: 20),

              // Matchup 1: Primary Live Ready Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CourtKingTheme.pureWhite,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: CourtKingTheme.borderLight,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'MATCH 1 • LIVE READY',
                      style: TextStyle(
                        color: CourtKingTheme.textSubtle,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTeamBadge(
                          'NYC Hawks',
                          'Seed #3',
                          Icons.sports_basketball,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: CourtKingTheme.surfaceGray,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'VS',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              color: CourtKingTheme.slateNavy,
                            ),
                          ),
                        ),
                        _buildTeamBadge('LA Vipers', 'Seed #6', Icons.flash_on),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tip-off: 7:00 PM EST',
                      style: TextStyle(
                        color: CourtKingTheme.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Additional Upcoming Bracket Pairings
              _buildUpcomingMatch(
                'Chicago Bulls',
                'Boston Celts',
                '7:00 PM EST',
              ),
              const SizedBox(height: 10),
              _buildUpcomingMatch('Miami Waves', 'Golden Surge', '7:00 PM EST'),

              const Spacer(),

              // Action CTA: Advance to Locker Room (Routes to Screen 4)
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
                    Navigator.pushNamed(context, CourtKingRoutes.rosterTactics);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Advance to Locker Room',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.sports_basketball,
                        color: Colors.white,
                        size: 20,
                      ),
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

  Widget _buildTab(String title, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: active ? CourtKingTheme.slateNavy : CourtKingTheme.surfaceGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: active ? Colors.white : CourtKingTheme.slateNavy,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTeamBadge(String name, String seed, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: CourtKingTheme.surfaceGray,
          child: Icon(icon, color: CourtKingTheme.slateNavy, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          seed,
          style: const TextStyle(
            fontSize: 10,
            color: CourtKingTheme.textSubtle,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: CourtKingTheme.slateNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingMatch(String t1, String t2, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: CourtKingTheme.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CourtKingTheme.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            t1,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: CourtKingTheme.slateNavy,
            ),
          ),
          const Text(
            'VS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: CourtKingTheme.textSubtle,
            ),
          ),
          Text(
            t2,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: CourtKingTheme.slateNavy,
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 11,
              color: CourtKingTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
