import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerProfile {
  String username;
  String tag;
  String region;
  String avatarUrl;
  int level;
  String rankTitle;

  PlayerProfile({
    this.username = 'Marcus Vance',
    this.tag = '#KING99',
    this.region = 'North America',
    this.avatarUrl =
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    this.level = 1,
    this.rankTitle = 'Rookie',
  });
}

class AthletePlayer {
  final String name;
  final String position;
  final int jerseyNumber;
  final String avatarUrl;
  double stamina; // 0.0 - 1.0
  int personalFouls;
  final double speed;
  final double threePoint;
  final double defense;
  bool isStarter;

  AthletePlayer({
    required this.name,
    required this.position,
    required this.jerseyNumber,
    required this.avatarUrl,
    required this.stamina,
    required this.personalFouls,
    required this.speed,
    required this.threePoint,
    required this.defense,
    this.isStarter = true,
  });
}

class CourtPosition {
  final double x; // 0.0 to 1.0 (relative to court width)
  final double y; // 0.0 to 1.0 (relative to court height)

  CourtPosition(this.x, this.y);

  CourtPosition lerp(CourtPosition other, double t) {
    return CourtPosition(
      x + (other.x - x) * t,
      y + (other.y - y) * t,
    );
  }
}

class GameSessionController extends ChangeNotifier {
  static final GameSessionController instance =
      GameSessionController._internal();
  factory GameSessionController() => instance;
  GameSessionController._internal() {
    initRosters();
  }

  // User Profile
  PlayerProfile userProfile = PlayerProfile();

  // Settings State (Screen 10)
  bool soundEffectsEnabled = true;
  bool crowdAudioEnabled = true;
  bool hapticFeedbackEnabled = true;
  bool cloudSyncEnabled = true;

  // Active Game State
  int gameLevel = 1;
  double aiDifficulty = 1.0; // Multiplier: 1.0 -> 1.35 on Level 2
  double teamMomentum = 0.65; // 0.0 - 1.0
  bool isOnFire = false;

  // Live Scoreboard & Arcade Simulation
  int homeScore = 82;
  int awayScore = 80;
  int quarterSecondsRemaining = 24;
  int shotClock = 24;
  int teamFouls = 4;
  String possession = 'AWAY';
  String selectedOffensivePlay = 'Pick & Roll';

  // Roster Management
  List<AthletePlayer> activeStarters = [];
  List<AthletePlayer> benchReserves = [];
  List<AthletePlayer> awayStarters = [];

  // Court position tracking (index: 0-4 = home starters, 5-9 = away starters)
  final Map<int, CourtPosition> playerPositions = {};
  final Map<int, CourtPosition> playerTargetPositions = {};

  // Player reaction animations (for shooting feedback)
  final Map<int, double> playerReactionScales = {};

  // Match simulation
  Timer? _movementTimer;

  void initRosters() {
    activeStarters = [
      AthletePlayer(
        name: 'LeBron James',
        position: 'SF',
        jerseyNumber: 23,
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        stamina: 0.88,
        personalFouls: 2,
        speed: 0.89,
        threePoint: 0.82,
        defense: 0.91,
        isStarter: true,
      ),
      AthletePlayer(
        name: 'Anthony Davis',
        position: 'PF',
        jerseyNumber: 3,
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
        stamina: 0.91,
        personalFouls: 3,
        speed: 0.82,
        threePoint: 0.70,
        defense: 0.96,
        isStarter: true,
      ),
      AthletePlayer(
        name: 'Russell Westbrook',
        position: 'PG',
        jerseyNumber: 0,
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
        stamina: 0.84,
        personalFouls: 2,
        speed: 0.94,
        threePoint: 0.75,
        defense: 0.80,
        isStarter: true,
      ),
      AthletePlayer(
        name: 'Austin Reaves',
        position: 'SG',
        jerseyNumber: 15,
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
        stamina: 0.89,
        personalFouls: 1,
        speed: 0.85,
        threePoint: 0.88,
        defense: 0.79,
        isStarter: true,
      ),
      AthletePlayer(
        name: 'Stephen Curry',
        position: 'PG',
        jerseyNumber: 30,
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
        stamina: 0.79,
        personalFouls: 4, // In danger zone!
        speed: 0.91,
        threePoint: 0.99,
        defense: 0.72,
        isStarter: true,
      ),
    ];

    benchReserves = [
      AthletePlayer(
        name: 'Jordan Poole',
        position: 'PG',
        jerseyNumber: 3,
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        stamina: 0.94,
        personalFouls: 0,
        speed: 0.92,
        threePoint: 0.86,
        defense: 0.70,
        isStarter: false,
      ),
      AthletePlayer(
        name: 'Klay Thompson',
        position: 'SG',
        jerseyNumber: 11,
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
        stamina: 0.93,
        personalFouls: 0,
        speed: 0.83,
        threePoint: 0.95,
        defense: 0.85,
        isStarter: false,
      ),
      AthletePlayer(
        name: 'Kevon Looney',
        position: 'C',
        jerseyNumber: 5,
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
        stamina: 0.88,
        personalFouls: 1,
        speed: 0.74,
        threePoint: 0.50,
        defense: 0.90,
        isStarter: false,
      ),
      AthletePlayer(
        name: 'Draymond Green',
        position: 'PF',
        jerseyNumber: 23,
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        stamina: 0.85,
        personalFouls: 3,
        speed: 0.79,
        threePoint: 0.68,
        defense: 0.94,
        isStarter: false,
      ),
      AthletePlayer(
        name: 'Andrew Wiggins',
        position: 'SF',
        jerseyNumber: 22,
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
        stamina: 0.92,
        personalFouls: 1,
        speed: 0.88,
        threePoint: 0.83,
        defense: 0.84,
        isStarter: false,
      ),
     ];

    awayStarters = [
      AthletePlayer(
        name: 'Jayson Tatum',
        position: 'SF',
        jerseyNumber: 0,
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        stamina: 0.86,
        personalFouls: 2,
        speed: 0.88,
        threePoint: 0.91,
        defense: 0.85,
        isStarter: true,
      ),
      AthletePlayer(
        name: 'Joel Embiid',
        position: 'C',
        jerseyNumber: 21,
        avatarUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
        stamina: 0.90,
        personalFouls: 3,
        speed: 0.72,
        threePoint: 0.55,
        defense: 0.98,
        isStarter: true,
      ),
      AthletePlayer(
        name: 'Luka Doncic',
        position: 'PG',
        jerseyNumber: 77,
        avatarUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
        stamina: 0.83,
        personalFouls: 2,
        speed: 0.84,
        threePoint: 0.85,
        defense: 0.78,
        isStarter: true,
      ),
      AthletePlayer(
        name: 'Donovan Mitchell',
        position: 'SG',
        jerseyNumber: 45,
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
        stamina: 0.81,
        personalFouls: 1,
        speed: 0.89,
        threePoint: 0.84,
        defense: 0.76,
        isStarter: true,
      ),
      AthletePlayer(
        name: 'Giannis Antetokounmpo',
        position: 'PF',
        jerseyNumber: 34,
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
        stamina: 0.92,
        personalFouls: 1,
        speed: 0.96,
        threePoint: 0.72,
        defense: 0.92,
        isStarter: true,
      ),
    ];

     // Initialize court positions: 0-4 home, 5-9 away
    _initPlayerPositions();
  }

  void _initPlayerPositions() {
    playerPositions.clear();
    playerTargetPositions.clear();

    // Home team starters (top half of court, y = 0.35 to 0.45)
    playerPositions[0] = CourtPosition(0.20, 0.38); // PG - LeBron
    playerPositions[1] = CourtPosition(0.40, 0.40); // SG - Reaves
    playerPositions[2] = CourtPosition(0.50, 0.42); // SF - LeBron (forward)
    playerPositions[3] = CourtPosition(0.60, 0.40); // PF - AD
    playerPositions[4] = CourtPosition(0.80, 0.38); // C - AD (center)

    // Away team starters (bottom half of court, y = 0.55 to 0.70)
    playerPositions[5] = CourtPosition(0.20, 0.62); // SG - Mitchell
    playerPositions[6] = CourtPosition(0.40, 0.60); // SF - Tatum
    playerPositions[7] = CourtPosition(0.50, 0.65); // C - Embiid
    playerPositions[8] = CourtPosition(0.60, 0.60); // PF - Giannis
    playerPositions[9] = CourtPosition(0.80, 0.62); // PG - Luka

    // Set initial target positions to current positions
    for (final entry in playerPositions.entries) {
      playerTargetPositions[entry.key] = entry.value;
    }
  }

  void startMatchSimulation() {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final rng = math.Random();
      final playerIdx = rng.nextInt(10);

      final courtX = rng.nextDouble() * 0.7 + 0.15; // 0.15 to 0.85
      final courtY = playerPositions[playerIdx]!.y < 0.5
          ? rng.nextDouble() * 0.4 + 0.20 // top half: 0.20 to 0.60
          : rng.nextDouble() * 0.4 + 0.40; // bottom half: 0.40 to 0.80

      playerTargetPositions[playerIdx] = CourtPosition(courtX, courtY);

      final athlete = playerIdx < 5
          ? activeStarters[playerIdx]
          : awayStarters[playerIdx - 5];

      // Recover stamina slowly over time
      athlete.stamina = math.min(1.0, athlete.stamina + 0.02);

      notifyListeners();
    });
  }

  void stopMatchSimulation() {
    _movementTimer?.cancel();
    _movementTimer = null;
  }

  List<AthletePlayer> getAllPlayers() {
    return [...activeStarters, ...awayStarters];
  }

  void triggerHaptic() {
    if (hapticFeedbackEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  void triggerSuccessHaptic() {
    if (hapticFeedbackEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void scoreBasket(int points) {
    homeScore += points;
    teamMomentum = math.min(1.0, teamMomentum + 0.15);
    isOnFire = teamMomentum >= 0.85;
    triggerSuccessHaptic();
    notifyListeners();
  }

  void swapPlayers(int starterIndex, int benchIndex) {
    final starter = activeStarters[starterIndex];
    final sub = benchReserves[benchIndex];

    starter.isStarter = false;
    sub.isStarter = true;

    activeStarters[starterIndex] = sub;
    benchReserves[benchIndex] = starter;
    triggerHaptic();
    notifyListeners();
  }

  void advanceToLevel2() {
    gameLevel = 2;
    aiDifficulty += 0.35; // 35% harder defense
    userProfile.level = 2;
    userProfile.rankTitle = 'All-Star';
    homeScore = 82;
    awayScore = 80;
    quarterSecondsRemaining = 24;
    notifyListeners();
  }

  void resetSession() {
    _movementTimer?.cancel();
    userProfile = PlayerProfile();
    gameLevel = 1;
    aiDifficulty = 1.0;
    teamMomentum = 0.65;
    isOnFire = false;
    homeScore = 82;
    awayScore = 80;
    quarterSecondsRemaining = 24;
    shotClock = 24;
    initRosters();
    notifyListeners();
  }
}
