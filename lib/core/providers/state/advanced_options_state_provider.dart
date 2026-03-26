import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvancedOptionsState {
  final bool antialiasing;
  final bool smoothing;

  const AdvancedOptionsState({
    this.antialiasing = false,
    this.smoothing = false,
  });

  AdvancedOptionsState copyWith({bool? antialiasing, bool? smoothing}) {
    return AdvancedOptionsState(
      antialiasing: antialiasing ?? this.antialiasing,
      smoothing: smoothing ?? this.smoothing,
    );
  }
}

class AdvancedOptionsNotifier extends StateNotifier<AdvancedOptionsState> {
  static const _antialiasingKey = 'advanced_options_antialiasing';
  static const _smoothingKey = 'advanced_options_smoothing';

  AdvancedOptionsNotifier() : super(const AdvancedOptionsState());

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AdvancedOptionsState(
      antialiasing: prefs.getBool(_antialiasingKey) ?? false,
      smoothing: prefs.getBool(_smoothingKey) ?? false,
    );
  }

  Future<void> save({required bool antialiasing, required bool smoothing}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_antialiasingKey, antialiasing);
    await prefs.setBool(_smoothingKey, smoothing);
    state = AdvancedOptionsState(antialiasing: antialiasing, smoothing: smoothing);
  }
}

final advancedOptionsProvider =
StateNotifierProvider<AdvancedOptionsNotifier, AdvancedOptionsState>(
      (ref) => AdvancedOptionsNotifier(),
);