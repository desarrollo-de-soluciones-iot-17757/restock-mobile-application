import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_state.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';

class ProfileGeneralPage extends StatefulWidget {
  const ProfileGeneralPage({super.key});

  @override
  State<ProfileGeneralPage> createState() => _ProfileGeneralPageState();
}

class _ProfileGeneralPageState extends State<ProfileGeneralPage> {
  String? _storedBranchId;
  String? _selectedBranchId;
  bool _storedEmailNotifications = true;
  bool _storedPushNotifications = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _hasLoadedSelectedBranch = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasLoadedSelectedBranch) return;

    _hasLoadedSelectedBranch = true;
    _loadSelectedBranch();
  }

  Future<void> _loadSelectedBranch() async {
    final selectedBranchId = await context
        .read<BranchFacadeService>()
        .getActiveBranchId();

    if (!mounted) return;
    setState(() {
      _storedBranchId = selectedBranchId;
      _selectedBranchId = selectedBranchId;
    });
  }

  Future<void> _showBranchPicker(List<Branch> branches) async {
    final selectedBranch = await showModalBottomSheet<Branch>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ACTIVE BRANCH',
                style: TextStyle(
                  color: Color(0xFF5D616A),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: branches.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final branch = branches[index];
                    final isSelected = branch.branchId == _selectedBranchId;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        branch.name,
                        style: const TextStyle(
                          color: ink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        branch.fullAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded, color: green)
                          : null,
                      onTap: () => Navigator.of(context).pop(branch),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selectedBranch == null) return;
    setState(() => _selectedBranchId = selectedBranch.branchId);
  }

  Future<void> _savePreferences(String? branchId) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      if (branchId != null) {
        await context.read<BranchFacadeService>().setActiveBranchId(branchId);
      }

      if (!mounted) return;
      setState(() {
        _storedBranchId = branchId;
        _storedEmailNotifications = _emailNotifications;
        _storedPushNotifications = _pushNotifications;
        _isSaving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preferences saved')));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save preferences')),
      );
    }
  }

  void _discardChanges() {
    setState(() {
      _selectedBranchId = _storedBranchId;
      _emailNotifications = _storedEmailNotifications;
      _pushNotifications = _storedPushNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchListBloc, BranchListState>(
      builder: (context, state) {
        final branches = _selectableBranches(state.branches);
        final selectedBranch = _selectedBranch(branches);
        final hasChanges =
            _selectedBranchId != _storedBranchId ||
            _emailNotifications != _storedEmailNotifications ||
            _pushNotifications != _storedPushNotifications;

        return Column(
          children: [
            Expanded(
              child: ColoredBox(
                color: const Color(0xFFF3F6F5),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(8, 18, 8, 20),
                  children: [
                    const _RegionalConfigurationCard(),
                    const SizedBox(height: 18),
                    _ActiveBranchCard(
                      branch: selectedBranch,
                      onTap: branches.isEmpty
                          ? null
                          : () => _showBranchPicker(branches),
                    ),
                    const SizedBox(height: 18),
                    _CommunicationCard(
                      emailEnabled: _emailNotifications,
                      pushEnabled: _pushNotifications,
                      onEmailChanged: (value) =>
                          setState(() => _emailNotifications = value),
                      onPushChanged: (value) =>
                          setState(() => _pushNotifications = value),
                    ),
                  ],
                ),
              ),
            ),
            _PreferencesActions(
              hasChanges: hasChanges,
              isSaving: _isSaving,
              onDiscard: hasChanges && !_isSaving ? _discardChanges : null,
              onSave: !_isSaving
                  ? () => _savePreferences(_selectedBranchId)
                  : null,
            ),
          ],
        );
      },
    );
  }

  List<Branch> _selectableBranches(List<Branch> branches) {
    final activeBranches = branches
        .where((branch) => branch.status.toLowerCase() == 'active')
        .toList();

    return activeBranches.isEmpty ? branches : activeBranches;
  }

  Branch? _selectedBranch(List<Branch> branches) {
    if (branches.isEmpty) return null;

    return branches.cast<Branch?>().firstWhere(
      (branch) => branch?.branchId == _selectedBranchId,
      orElse: () => branches.first,
    );
  }
}

class _PreferencesButton extends StatelessWidget {
  const _PreferencesButton({
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isOutlined ? Colors.white : const Color(0xFF007A4D);
    final isDisabled = onPressed == null;
    final foregroundColor = isOutlined
        ? (isDisabled ? muted : ink)
        : Colors.white;

    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isOutlined
                  ? (isDisabled
                        ? const Color(0xFFD1D5DB)
                        : const Color(0xFF74777F))
                  : const Color(0xFF007A4D),
              width: isOutlined ? 2 : 1,
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _PreferencesActions extends StatelessWidget {
  const _PreferencesActions({
    required this.hasChanges,
    required this.isSaving,
    required this.onDiscard,
    required this.onSave,
  });

  final bool hasChanges;
  final bool isSaving;
  final VoidCallback? onDiscard;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PreferencesButton(
            label: 'Discard Changes',
            isOutlined: true,
            onPressed: onDiscard,
          ),
          const SizedBox(height: 12),
          _PreferencesButton(
            label: isSaving ? 'Saving...' : 'Save Preferences',
            onPressed: hasChanges ? onSave : null,
          ),
        ],
      ),
    );
  }
}

class _RegionalConfigurationCard extends StatelessWidget {
  const _RegionalConfigurationCard();

  @override
  Widget build(BuildContext context) {
    return const _SettingsCard(
      child: Column(
        children: [
          _CardHeader(label: 'REGIONAL CONFIGURATION'),
          _SettingsDivider(),
          _SelectionRow(label: 'Timezone', value: 'UTC -05:00 Eastern Time'),
          _SettingsDivider(),
          _SelectionRow(label: 'Currency', value: 'USD (\$)'),
        ],
      ),
    );
  }
}

class _ActiveBranchCard extends StatelessWidget {
  const _ActiveBranchCard({required this.branch, required this.onTap});

  final Branch? branch;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title = branch?.name ?? 'No branches available';

    return _SettingsCard(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 16, 19),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionLabel('ACTIVE BRANCH'),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: muted, size: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CommunicationCard extends StatelessWidget {
  const _CommunicationCard({
    required this.emailEnabled,
    required this.pushEnabled,
    required this.onEmailChanged,
    required this.onPushChanged,
  });

  final bool emailEnabled;
  final bool pushEnabled;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onPushChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      child: Column(
        children: [
          const _CardHeader(label: 'COMMUNICATION'),
          const _SettingsDivider(),
          _CommunicationRow(
            label: 'Email Notifications',
            enabled: emailEnabled,
            onChanged: onEmailChanged,
          ),
          _CommunicationRow(
            label: 'Push Notifications',
            enabled: pushEnabled,
            onChanged: onPushChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: _SectionLabel(label),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Color(0xFF5D616A),
        fontSize: 14,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _SelectionRow extends StatelessWidget {
  const _SelectionRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 15, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: ink,
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF777B85),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right_rounded, color: muted, size: 30),
        ],
      ),
    );
  }
}

class _CommunicationRow extends StatelessWidget {
  const _CommunicationRow({
    required this.label,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!enabled),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 15, 22, 15),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: ink,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _StaticSwitch(enabled: enabled),
          ],
        ),
      ),
    );
  }
}

class _StaticSwitch extends StatelessWidget {
  const _StaticSwitch({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 62,
      height: 32,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFF007A4D) : const Color(0xFFE1E5EB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 160),
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: Color(0xFFE2E4E8), height: 1, thickness: 1);
  }
}
