import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/domain/entities/branch.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_bloc.dart';
import 'package:restock/resources/presentation/branches/branch_list/bloc/branch_list_state.dart';
import 'package:restock/resources/presentation/branches/widgets/active_branch_card.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/utils/ui/theme.dart';

class ProfileGeneralPage extends StatefulWidget {
  const ProfileGeneralPage({super.key});

  @override
  State<ProfileGeneralPage> createState() => _ProfileGeneralPageState();
}

class _ProfileGeneralPageState extends State<ProfileGeneralPage> {
  String? _selectedBranchId;
  bool _hasLoadedSelectedBranch = false;

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
    setState(() => _selectedBranchId = selectedBranchId);
  }

  Future<void> _selectBranch(Branch branch) async {
    await context.read<BranchFacadeService>().setActiveBranchId(
      branch.branchId,
    );

    if (!mounted) return;
    setState(() => _selectedBranchId = branch.branchId);
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
                  color: textTertiary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
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
                          color: textTertiary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      subtitle: Text(
                        branch.fullAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: green)
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
    await _selectBranch(selectedBranch);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchListBloc, BranchListState>(
      builder: (context, state) {
        final branches = _selectableBranches(state.branches);
        final selectedBranch = _selectedBranch(branches);

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
          children: [
            ActiveBranchCard(
              isLoading: state.status == Status.loading,
              branch: selectedBranch,
              onTap: branches.isEmpty
                  ? null
                  : () => _showBranchPicker(branches),
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