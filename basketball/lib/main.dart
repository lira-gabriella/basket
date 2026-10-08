import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_theme.dart';
import 'core/game_state.dart';
import 'screens/screen_01_registration.dart';
import 'screens/screen_02_main_menu.dart';
import 'screens/screen_03_tournament_bracket.dart';
import 'screens/screen_04_roster_tactics.dart';
import 'screens/screen_05_pre_match_tipoff.dart';
import 'screens/screen_06_live_match_arena.dart';
import 'screens/screen_07_timeout_tactics.dart';
import 'screens/screen_08_substitution_foul.dart';
import 'screens/screen_09_post_match_summary.dart';
import 'screens/screen_10_settings_signout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const CourtKingApp());
}

class CourtKingApp extends StatelessWidget {
  const CourtKingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: GameSessionController.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'CourtKing',
          debugShowCheckedModeBanner: false,
          theme: CourtKingTheme.themeData,
          initialRoute: CourtKingRoutes.registration,
          routes: {
            CourtKingRoutes.registration: (context) =>
                const Screen01Registration(),
            CourtKingRoutes.mainMenu: (context) => const Screen02MainMenu(),
            CourtKingRoutes.tournamentBracket: (context) =>
                const Screen03TournamentBracket(),
            CourtKingRoutes.rosterTactics: (context) =>
                const Screen04RosterTactics(),
            CourtKingRoutes.preMatchTipoff: (context) =>
                const Screen05PreMatchTipoff(),
            CourtKingRoutes.liveMatchArena: (context) =>
                const Screen06LiveMatchArena(),
            CourtKingRoutes.timeoutTactics: (context) =>
                const Screen07TimeoutTactics(),
            CourtKingRoutes.substitutionFoul: (context) =>
                const Screen08SubstitutionFoul(),
            CourtKingRoutes.postMatchSummary: (context) =>
                const Screen09PostMatchSummary(),
            CourtKingRoutes.settingsSignOut: (context) =>
                const Screen10SettingsSignOut(),
          },
        );
      },
    );
  }
}

class CourtKingRoutes {
  static const String registration = '/';
  static const String mainMenu = '/main_menu';
  static const String tournamentBracket = '/tournament_bracket';
  static const String rosterTactics = '/roster_tactics';
  static const String preMatchTipoff = '/pre_match_tipoff';
  static const String liveMatchArena = '/live_match_arena';
  static const String timeoutTactics = '/timeout_tactics';
  static const String substitutionFoul = '/substitution_foul';
  static const String postMatchSummary = '/post_match_summary';
  static const String settingsSignOut = '/settings_signout';
}
