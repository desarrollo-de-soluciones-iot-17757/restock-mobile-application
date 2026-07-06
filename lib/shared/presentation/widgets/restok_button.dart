import 'package:flutter/material.dart';

/// A reusable button widget for the Restock application, with built-in loading state and customizable text and height.
class RestockButton extends StatelessWidget {
  /// Creates a [RestockButton] with customizable styling, callback, and state.
  const RestockButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.height = 54,
  });

  /// The text displayed inside the button.
  final String text;

  /// The callback that is called when the button is tapped.
  ///
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// Whether the button is in a loading state.
  ///
  /// When true, a circular progress indicator is shown instead of the text,
  /// and interactions are disabled.
  final bool isLoading;

  /// Whether the button is enabled.
  ///
  /// When false, the button visual opacity is reduced and interactions are disabled.
  final bool enabled;

  /// The height of the button. Defaults to 54.
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled || isLoading;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDisabled
              ? const Color(0xFF1B4332).withValues(alpha: 0.4)
              : const Color(0xFF1B4332),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}