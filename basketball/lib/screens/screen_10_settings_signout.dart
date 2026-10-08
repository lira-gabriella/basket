import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/game_state.dart';
import '../main.dart';

class Screen10SettingsSignOut extends StatelessWidget {
  const Screen10SettingsSignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CourtKingTheme.pureWhite,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: CourtKingTheme.pureWhite,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Settings & Sign Out Screen'),
      ),
    );
  }
}