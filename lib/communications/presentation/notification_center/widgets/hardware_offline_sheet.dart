import 'package:flutter/material.dart';

class HardwareOfflineSheet extends StatelessWidget {
  const HardwareOfflineSheet({
    super.key,
    required this.title,
    required this.assignedDevice,
    required this.onAcknowledge,
  });

  final String title;
  final String assignedDevice;
  final VoidCallback onAcknowledge;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE1E4EA),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Color(0xFF4B5563)),
              ),
            ],
          ),
          Text(
            '(Assigned: $assignedDevice)',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "The device has stopped transmitting data. A 'heartbeat loss' indicates the central server hasn't received a status ping within the 300s window. Check for physical obstruction or power failure.",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _metricRow('Last Recorded Telemetry', '8.42 kg'),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                _metricRow('Last Heartbeat', '14 mins ago'),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                _metricRow('Last Known Temp', '4.2°C'),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                _metricRow('Last Known Humidity', '62%'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Color(0xFF10B981), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Check power supply and WiFi connectivity of the device. Ensure the device signal is not obstructed by metal shielding or industrial equipment.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFE2E8F0),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF374151),
                      side: const BorderSide(color: Color(0xFFD1D5DB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Acknowledge / Dismiss',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onAcknowledge();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Try Reconnect',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563))),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
        ],
      ),
    );
  }
}
