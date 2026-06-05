import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/create_custom_supply/bloc/create_custom_supply_bloc.dart';
import 'package:restock/resources/presentation/custom_supplies/create_custom_supply/bloc/create_custom_supply_event.dart';
import 'package:restock/resources/presentation/custom_supplies/create_custom_supply/bloc/create_custom_supply_state.dart';
import 'package:restock/shared/presentation/utils/enums/bloc_status.dart';
import 'package:restock/shared/presentation/widgets/image_picker_field.dart';
import 'package:restock/shared/presentation/widgets/restok_button.dart';
import 'package:restock/shared/presentation/widgets/text_field.dart';

class CreateCustomSupplyForm extends StatefulWidget {
  const CreateCustomSupplyForm({super.key});

  @override
  State<CreateCustomSupplyForm> createState() => _CreateCustomSupplyFormState();
}

class _CreateCustomSupplyFormState extends State<CreateCustomSupplyForm> {
  static const _unitOptions = {
    'kg': 'Kilograms',
    'l': 'Liters',
    'dozen': 'Dozen',
    'g': 'Grams',
    'unit': 'Units',
  };

  final _nameController = TextEditingController();
  final _minimumController = TextEditingController();
  final _maximumController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _dispatch(CreateCustomSupplyEvent event) =>
      context.read<CreateCustomSupplyBloc>().add(event);

  @override
  void dispose() {
    _nameController.dispose();
    _minimumController.dispose();
    _maximumController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCustomSupplyBloc, CreateCustomSupplyState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == Status.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Failed to create custom supply',
              ),
            ),
          );
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Create Custom Supply',
                    style: TextStyle(
                      color: Color(0xFF0D1B2A),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                      BlocBuilder<
                        CreateCustomSupplyBloc,
                        CreateCustomSupplyState
                      >(
                        builder: (context, state) {
                          final isLoading = state.status == Status.loading;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImagePickerField(
                                enabled: !isLoading,
                                onImagePicked: (image) => _dispatch(
                                  CreateCustomSupplyImageChanged(image),
                                ),
                              ),
                              const SizedBox(height: 16),
                              RestockTextField(
                                controller: _nameController,
                                hint: 'SUPPLY NAME',
                                enabled: !isLoading,
                                onChanged: (value) => _dispatch(
                                  CreateCustomSupplyNameChanged(value),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: RestockTextField(
                                      controller: _minimumController,
                                      hint: 'MINIMUM CAPACITY',
                                      keyboardType: TextInputType.number,
                                      enabled: !isLoading,
                                      onChanged: (value) => _dispatch(
                                        CreateCustomSupplyMinimumStockChanged(
                                          value,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: RestockTextField(
                                      controller: _maximumController,
                                      hint: 'MAXIMUM CAPACITY',
                                      keyboardType: TextInputType.number,
                                      enabled: !isLoading,
                                      onChanged: (value) => _dispatch(
                                        CreateCustomSupplyMaximumStockChanged(
                                          value,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: RestockTextField(
                                      controller: _priceController,
                                      hint: 'UNIT PRICE',
                                      keyboardType: TextInputType.number,
                                      enabled: !isLoading,
                                      onChanged: (value) => _dispatch(
                                        CreateCustomSupplyUnitPriceChanged(
                                          value,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _SelectField(
                                      label: 'CURRENCY',
                                      value: state.currency,
                                      enabled: !isLoading,
                                      items: const ['PEN', 'USD'],
                                      onChanged: (value) {
                                        if (value == null) return;
                                        _dispatch(
                                          CreateCustomSupplyCurrencyChanged(
                                            value,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _SelectField(
                                label: 'UNIT OF MEASURE',
                                value: state.unit,
                                enabled: !isLoading,
                                items: _unitOptions.keys.toList(),
                                itemLabel: (value) => _unitOptions[value]!,
                                onChanged: (value) {
                                  if (value == null) return;
                                  _dispatch(
                                    CreateCustomSupplyUnitChanged(value),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              RestockTextField(
                                controller: _descriptionController,
                                hint: 'DESCRIPTION',
                                maxLines: 3,
                                enabled: !isLoading,
                                onChanged: (value) => _dispatch(
                                  CreateCustomSupplyDescriptionChanged(value),
                                ),
                              ),
                              const SizedBox(height: 24),
                              RestockButton(
                                text: 'Create Supply',
                                isLoading: isLoading,
                                enabled: state.isValid,
                                onPressed: () => _dispatch(
                                  const CreateCustomSupplySubmitted(),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        },
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemLabel,
    this.enabled = true,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String Function(String value)? itemLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(
          color: Color(0xFF9AA5B4),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFF0F0F0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDE1E7), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2D6A4F), width: 1.5),
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(itemLabel?.call(item) ?? item),
            ),
          )
          .toList(),
    );
  }
}
