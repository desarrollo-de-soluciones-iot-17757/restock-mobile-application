import 'package:flutter/material.dart';
import 'package:restock/resources/presentation/batches/batch_list/bloc/batch_list_event.dart';

class BatchFilterRow extends StatelessWidget {
  const BatchFilterRow({
    super.key,
    required this.stockFilter,
    required this.onStockFilterChanged,
  });

  final BatchStockFilter stockFilter;
  final ValueChanged<BatchStockFilter> onStockFilterChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterButton(
            label: 'All Categories',
            icon: Icons.keyboard_arrow_down,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PopupMenuButton<BatchStockFilter>(
            initialValue: stockFilter,
            onSelected: onStockFilterChanged,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: BatchStockFilter.any,
                child: Text('Stock Level: Any'),
              ),
              PopupMenuItem(
                value: BatchStockFilter.low,
                child: Text('Low Stock'),
              ),
              PopupMenuItem(
                value: BatchStockFilter.available,
                child: Text('Available Stock'),
              ),
            ],
            child: _FilterButton(
              label: _stockFilterLabel(stockFilter),
              icon: Icons.filter_list,
              onTap: null,
            ),
          ),
        ),
      ],
    );
  }

  String _stockFilterLabel(BatchStockFilter filter) {
    return switch (filter) {
      BatchStockFilter.any => 'Stock Level',
      BatchStockFilter.low => 'Low Stock',
      BatchStockFilter.available => 'Available',
    };
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFD7DCE3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF424854),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(icon, color: const Color(0xFF6B7280), size: 20),
          ],
        ),
      ),
    );
  }
}
