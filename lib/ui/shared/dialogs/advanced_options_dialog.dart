import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:paintroid/core/providers/state/advanced_options_state_provider.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/shared/dialogs/generic_dialog.dart';

Future<void> showAdvancedOptionsDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (_, __, ___) => const AdvancedOptionsDialog(),
    barrierDismissible: true,
    barrierLabel: 'Advanced Options',
  );
}

class AdvancedOptionsDialog extends ConsumerStatefulWidget {
  const AdvancedOptionsDialog({super.key});

  @override
  ConsumerState<AdvancedOptionsDialog> createState() =>
      _AdvancedOptionsDialogState();
}

class _AdvancedOptionsDialogState extends ConsumerState<AdvancedOptionsDialog> {
  late bool _antialiasing;
  late bool _smoothing;

  @override
  void initState() {
    super.initState();
    final current = ref.read(advancedOptionsProvider);
    _antialiasing = current.antialiasing;
    _smoothing = current.smoothing;
  }

  @override
  Widget build(BuildContext context) {
    return GenericDialog(
      title: 'Advanced Options',
      actions: [
        GenericDialogAction(
          title: 'CANCEL',
          identifier: WidgetIdentifier.genericDialogActionAdvancedOptionsCancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
        GenericDialogAction(
          title: 'OK',
          identifier: WidgetIdentifier.genericDialogActionAdvancedOptionsOk,
          onPressed: () {
            ref.read(advancedOptionsProvider.notifier).save(
                  antialiasing: _antialiasing,
                  smoothing: _smoothing,
                );
            Navigator.of(context).pop();
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            key: const ValueKey(
                WidgetIdentifier.advancedOptionsAntialiasingSwitch),
            title: const Text('Antialiasing'),
            value: _antialiasing,
            onChanged: (value) => setState(() => _antialiasing = value),
          ),
          SwitchListTile(
            key:
                const ValueKey(WidgetIdentifier.advancedOptionsSmoothingSwitch),
            title: const Text('Smoothing'),
            value: _smoothing,
            onChanged: (value) => setState(() => _smoothing = value),
          ),
        ],
      ),
    );
  }
}
