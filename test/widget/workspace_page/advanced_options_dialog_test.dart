import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:paintroid/app.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    sut = ProviderScope(
      child: App(showOnboardingPage: false),
    );
  });

  group('[ADVANCED_OPTIONS]: dialog', () {
    testWidgets(
        'Opens Advanced Options dialog from overflow menu with both toggles OFF by default',
        (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      // Open overflow menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      // Tap Advanced Options
      await tester.tap(find.text('Advanced Options'));
      await tester.pumpAndSettle();

      // Dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);

      // Both labels are present
      expect(find.text('Antialiasing'), findsOneWidget);
      expect(find.text('Smoothing'), findsOneWidget);

      // Both switches are OFF by default
      final antialiasingSwitch = tester.widget<Switch>(
        find.descendant(
          of: find.byKey(const ValueKey(
              WidgetIdentifier.advancedOptionsAntialiasingSwitch)),
          matching: find.byType(Switch),
        ),
      );
      final smoothingSwitch = tester.widget<Switch>(
        find.descendant(
          of: find.byKey(
              const ValueKey(WidgetIdentifier.advancedOptionsSmoothingSwitch)),
          matching: find.byType(Switch),
        ),
      );
      expect(antialiasingSwitch.value, isFalse);
      expect(smoothingSwitch.value, isFalse);

      // Toggle Antialiasing on
      await tester.tap(find.byKey(
          const ValueKey(WidgetIdentifier.advancedOptionsAntialiasingSwitch)));
      await tester.pumpAndSettle();

      // Tap OK — dialog dismisses
      await tester.tap(find.byKey(const ValueKey(
          WidgetIdentifier.genericDialogActionAdvancedOptionsOk)));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
