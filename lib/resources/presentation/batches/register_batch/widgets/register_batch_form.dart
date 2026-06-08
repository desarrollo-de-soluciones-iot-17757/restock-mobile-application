import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/batches/register_batch/bloc/register_batch_bloc.dart';
import 'package:restock/resources/presentation/batches/register_batch/bloc/register_batch_event.dart';
import 'package:restock/resources/presentation/batches/register_batch/bloc/register_batch_state.dart';
import 'package:restock/resources/presentation/batches/register_batch/widgets/register_batch_date_field.dart';
import 'package:restock/resources/presentation/batches/register_batch/widgets/register_batch_supply_field.dart';
import 'package:restock/resources/presentation/batches/register_batch/widgets/register_batch_text_field.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';

import '../../../../../shared/presentation/widgets/restock_outlined_button.dart';

class RegisterBatchForm extends StatefulWidget {
  const RegisterBatchForm({super.key});

  @override
  State<RegisterBatchForm> createState() => _RegisterBatchFormState();
}

class _RegisterBatchFormState extends State<RegisterBatchForm> {
  final _stockController = TextEditingController(text: '0');
  final _expirationDateController = TextEditingController();

  void _dispatch(RegisterBatchEvent event) =>
      context.read<RegisterBatchBloc>().add(event);

  @override
  void initState() {
    super.initState();
    _dispatch(const RegisterBatchCurrentStockChanged('0'));
  }

  @override
  void dispose() {
    _stockController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBatchBloc, RegisterBatchState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == Status.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to register batch'),
            ),
          );
        }
      },
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.68,
        minChildSize: 0.55,
        maxChildSize: 0.92,
        builder: (context, scrollController) => SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFC6C7CC),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add New Batch',
                    style: TextStyle(
                      color: Color(0xFF171A22),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: BlocBuilder<RegisterBatchBloc, RegisterBatchState>(
                  builder: (context, state) {
                    final isLoading = state.isLoading;
                    final isLoadingSupplies =
                        state.suppliesStatus == Status.loading;

                    return SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          RegisterBatchSupplyField(
                            supplies: state.customSupplies,
                            value: state.selectedCustomSupply,
                            enabled: !isLoading && !isLoadingSupplies,
                            errorText: state.supplyError,
                            onChanged: (supply) =>
                                _dispatch(RegisterBatchSupplyChanged(supply)),
                          ),
                          if (state.suppliesStatus == Status.failure) ...[
                            const SizedBox(height: 8),
                            Text(
                              state.errorMessage ?? 'Failed to load supplies',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ],
                          const SizedBox(height: 12),
                          RegisterBatchTextField(
                            controller: _stockController,
                            label: 'INITIAL STOCK (UNITS)',
                            keyboardType: TextInputType.number,
                            enabled: !isLoading,
                            errorText: state.currentStockError,
                            onChanged: (value) => _dispatch(
                              RegisterBatchCurrentStockChanged(value),
                            ),
                          ),
                          const SizedBox(height: 12),
                          RegisterBatchDateField(
                            controller: _expirationDateController,
                            enabled: !isLoading,
                            errorText: state.expirationDateError,
                            onChanged: (value) => _dispatch(
                              RegisterBatchExpirationDateChanged(value),
                            ),
                          ),
                          const SizedBox(height: 34),
                          RestockButton(
                            text: isLoading ? 'Adding...' : 'Add Batch',
                            isLoading: isLoading,
                            enabled: !isLoading,
                            onPressed: () =>
                                _dispatch(const RegisterBatchSubmitted()),
                          ),
                          const SizedBox(height: 16),
                          RestockOutlinedButton(
                            text: 'Cancel',
                            onPressed: () => Navigator.of(context).pop(false),
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
