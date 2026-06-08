import 'package:flutter/material.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';
import 'package:restock/shared/presentation/widgets/settings_section_tabs.dart';

class SettingsScaffold extends StatelessWidget {
  const SettingsScaffold({
    required this.selectedSection,
    required this.child,
    super.key,
  });

  final SettingsSection selectedSection;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: const RestockAppBar(),
      body: Column(
        children: [
          SettingsSectionTabs(selectedSection: selectedSection),
          Expanded(child: child),
        ],
      ),
    );
  }
}
