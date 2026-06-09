import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restock/injections.dart';
import 'package:restock/resources/application/branch_facade_service.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_bloc.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_state.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_action_bar.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_filter_row.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_list_view.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_overview_metrics.dart';
import 'package:restock/resources/presentation/batches/batch_list/widgets/batch_search_field.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_bloc.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/bloc/create_and_edit_batch_event.dart';
import 'package:restock/resources/presentation/batches/create_and_edit_batch/widgets/create_and_edit_batch_form.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/app_bar.dart';

class BatchesPage extends StatefulWidget {
  const BatchesPage({super.key});

  @override
  State<BatchesPage> createState() => _BatchesPageState();
}

class _BatchesPageState extends State<BatchesPage> {
  late final BranchFacadeService _branchFacadeService;

  @override
  void initState() {
    super.initState();
    _branchFacadeService = serviceLocator<BranchFacadeService>();
    _branchFacadeService.activeBranchIdListenable.addListener(
      _refreshForActiveBranch,
    );
  }

  @override
  void dispose() {
    _branchFacadeService.activeBranchIdListenable.removeListener(
      _refreshForActiveBranch,
    );
    super.dispose();
  }

  void _refreshForActiveBranch() {
    if (!mounted) return;
    context.read<BatchListBloc>().add(const BatchListStarted());
  }

  Future<void> _openCreateAndEditBatchSheet(BuildContext context) async {
    final batchListBloc = context.read<BatchListBloc>();

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider<CreateAndEditBatchBloc>(
        create: (_) =>
            serviceLocator<CreateAndEditBatchBloc>()
              ..add(const CreateAndEditBatchStarted()),
        child: Padding(
          padding: MediaQuery.viewInsetsOf(context),
          child: const CreateAndEditBatchForm(),
        ),
      ),
    );

    if (created == true) {
      batchListBloc.add(const BatchListStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const RestockAppBar(),
      body: BlocBuilder<BatchListBloc, BatchListState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: const Color(0xFF007A4D),
            onRefresh: () async {
              context.read<BatchListBloc>().add(const BatchListStarted());
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  sliver: SliverList.list(
                    children: [
                      const Text(
                        'Batches',
                        style: TextStyle(
                          color: Color(0xFF0F1B2A),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 18),
                      BatchSearchField(
                        onChanged: (query) => context.read<BatchListBloc>().add(
                          BatchSearchChanged(query),
                        ),
                      ),
                      const SizedBox(height: 18),
                      BatchActionBar(
                        onAddBatch: () => _openCreateAndEditBatchSheet(context),
                        onCustomSupplies: () => context.go('/supplies'),
                      ),
                      const SizedBox(height: 18),
                      BatchOverviewMetrics(
                        totalActiveBatches: state.batches.length,
                        nearExpiryCount: state.nearExpiryCount,
                      ),
                      const SizedBox(height: 16),
                      BatchFilterRow(
                        stockFilter: state.stockFilter,
                        onStockFilterChanged: (filter) => context
                            .read<BatchListBloc>()
                            .add(BatchStockFilterChanged(filter)),
                      ),
                      const SizedBox(height: 20),
                      _BatchListBody(state: state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BatchListBody extends StatelessWidget {
  const _BatchListBody({required this.state});

  final BatchListState state;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      Status.initial || Status.loading => const Padding(
        padding: EdgeInsets.symmetric(vertical: 56),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007A4D)),
          ),
        ),
      ),
      Status.failure => Padding(
        padding: const EdgeInsets.symmetric(vertical: 42),
        child: Center(
          child: Text(
            state.message ?? 'Error loading batches',
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      Status.success => BatchListView(
        batches: state.filteredBatches,
        isSearching: state.isSearching,
      ),
    };
  }
}
