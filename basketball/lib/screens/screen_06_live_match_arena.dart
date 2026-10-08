import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';
import '../main.dart';

class Screen06LiveMatchArena extends StatefulWidget {
  const Screen06LiveMatchArena({Key? key}) : super(key: key);

  @override
  State<Screen06LiveMatchArena> createState() => _Screen06LiveMatchArenaState();
}

class _Screen06LiveMatchArenaState extends State<Screen06LiveMatchArena>
    with SingleTickerProviderStateMixin {
  Timer? _countdownTimer;
  Timer? _movementTimer;
  bool _isShooting = false;
  double _ballOffsetY = 0.0;
  final Map<int, double> _playerReactionScales = {};

  @override
  void initState() {
    super.initState();
    _startClock();
    GameSessionController.instance.startMatchSimulation();

    _movementTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final game = GameSessionController.instance;
      final now = DateTime.now();
      for (final entry
          in game.playerPositions.entries) {
        final target = game.playerTargetPositions[entry.key];
        if (target != null &&
            (entry.value.x - target.x).abs() > 0.005 &&
            (entry.value.y - target.y).abs() > 0.005) {
          final t = 0.12;
          game.playerPositions[entry.key] = entry.value.lerp(target, t);
          if ((game.playerPositions[entry.key]!.x - target.x).abs() < 0.005 &&
              (game.playerPositions[entry.key]!.y - target.y).abs() < 0.005) {
            game.playerPositions[entry.key] = target;
          }
        }
      }
    });
  }

  void _startClock() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final game = GameSessionController.instance;
      if (!mounted) return;
      setState(() {
        if (game.quarterSecondsRemaining > 0) {
          game.quarterSecondsRemaining--;
          game.shotClock = game.shotClock > 1 ? game.shotClock - 1 : 24;
        } else {
          _countdownTimer?.cancel();
          // Quarter ends: Route immediately to Screen 9 (Post-Match Summary)
          Navigator.pushReplacementNamed(
            context,
            CourtKingRoutes.postMatchSummary,
          );
        }
      });
    });
  }

  void _flickShoot() {
    if (_isShooting) return;
    final game = GameSessionController.instance;

    setState(() {
      _isShooting = true;
      _ballOffsetY = -240.0;
    });

    game.getAllPlayers().asMap().forEach((idx, player) {
      _playerReactionScales[idx] = 0.0;
    });

    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        for (final entry in _playerReactionScales.entries) {
          _playerReactionScales[entry.key] = 1.15;
        }
      });
    });

    Timer(const Duration(milliseconds: 250), () {
      setState(() {
        for (final entry in _playerReactionScales.entries) {
          _playerReactionScales[entry.key] = 1.0;
        }
      });
    });

    Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      game.scoreBasket(3);
      setState(() {
        _ballOffsetY = 0.0;
        _isShooting = false;
        _playerReactionScales.clear();
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _movementTimer?.cancel();
    GameSessionController.instance.stopMatchSimulation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = GameSessionController.instance;

    return Scaffold(
      backgroundColor: CourtKingTheme.slateNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Top Digital Scoreboard Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: CourtKingTheme.slateNavy,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScoreNode('HOME', game.homeScore),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CourtKingTheme.neonAmber,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '00:${game.quarterSecondsRemaining.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SHOT CLOCK: ${game.shotClock}s',
                        style: const TextStyle(
                          color: CourtKingTheme.textSubtle,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildScoreNode('AWAY', game.awayScore),
                ],
              ),
            ),

            // In-Game Rules Status Indicators
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: Colors.white.withOpacity(0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TEAM FOULS: ${game.teamFouls} (BONUS)',
                    style: const TextStyle(
                      color: CourtKingTheme.crispCyan,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'POSSESSION: ${game.possession}',
                    style: const TextStyle(
                      color: CourtKingTheme.neonAmber,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Center Arcade Arena Canvas with 3D Hoop & Net
            Expanded(
              child: GestureDetector(
                onVerticalDragEnd: (details) => _flickShoot(),
                child: Container(
                  width: double.infinity,
                  color: Colors.black26,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rim / Backboard Target Visualizer
                      Positioned(
                        top: 40,
                        child: Container(
                          width: 140,
                          height: 90,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Container(
                              width: 60,
                              height: 18,
                              decoration: BoxDecoration(
                                color: CourtKingTheme.neonAmber,
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Floating Momentum Coach Card ("ON FIRE")
                      Positioned(
                        left: 16,
                        top: 30,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CourtKingTheme.slateNavy.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: game.isOnFire
                                  ? CourtKingTheme.neonAmber
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(
                                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    game.isOnFire ? 'ON FIRE! 🔥' : 'MOMENTUM',
                                    style: TextStyle(
                                      color: game.isOnFire
                                          ? CourtKingTheme.neonAmber
                                          : Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    '${(game.teamMomentum * 100).toInt()}% Boost Active',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Flick Basketball
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutQuad,
                        bottom: 80 - _ballOffsetY,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: CourtKingTheme.neonAmber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.sports_basketball,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),

                      const Positioned(
                        bottom: 24,
                        child: Text(
                          '↑ SWIPE UP TO SHOOT',
                          style: TextStyle(
                            color: CourtKingTheme.textSubtle,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
),
                    ],
                  ),
                ),
              ),

              // Court Players - Home Team (top half)
              ...List.generate(5, (idx) {
                final pos = game.playerPositions[idx];
                final player = game.activeStarters[idx];
                if (pos == null) return const SizedBox.shrink();
                return Positioned(
                  left: MediaQuery.of(context).size.width * pos.x - 20,
                  top: MediaQuery.of(context).size.height * 0.45 * pos.y + 100,
                  child: Transform.scale(
                    scale: game.playerReactionScales[idx] ?? 1.0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: CourtKingTheme.neonAmber, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: CourtKingTheme.neonAmber.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              player.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: CourtKingTheme.slateNavy,
                                child: Center(
                                  child: Text(
                                    '#${player.jerseyNumber}',
                                    style: const TextStyle(
                                      color: CourtKingTheme.neonAmber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Court Players - Away Team (bottom half)
              ...List.generate(5, (idx) {
                final pos = game.playerPositions[idx + 5];
                final player = game.awayStarters[idx];
                if (pos == null) return const SizedBox.shrink();
                return Positioned(
                  left: MediaQuery.of(context).size.width * pos.x - 20,
                  top: MediaQuery.of(context).size.height * 0.45 * pos.y + 100,
                  child: Transform.scale(
                    scale: game.playerReactionScales[idx + 5] ?? 1.0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: CourtKingTheme.crispCyan, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: CourtKingTheme.crispCyan.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              player.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: CourtKingTheme.slateNavy,
                                child: Center(
                                  child: Text(
                                    '#${player.jerseyNumber}',
                                    style: const TextStyle(
                                      color: CourtKingTheme.crispCyan,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // In-Game Tactical Action Route Buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  // Call Timeout (Routes to Screen 7)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.white70,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        game.triggerHaptic();
                        Navigator.pushNamed(
                          context,
                          CourtKingRoutes.timeoutTactics,
                        );
                      },
                      child: const Text(
                        'CALL TIMEOUT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Substitutions (Routes to Screen 8)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CourtKingTheme.crispCyan,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        game.triggerHaptic();
                        Navigator.pushNamed(
                          context,
                          CourtKingRoutes.substitutionFoul,
                        );
                      },
                      child: const Text(
                        'SUBSTITUTIONS',
                        style: TextStyle(
                          color: CourtKingTheme.slateNavy,
                          fontWeight: FontWeight.w900,
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

  Widget _buildScoreNode(String label, int score) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CourtKingTheme.textSubtle,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          score.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
