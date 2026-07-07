import 'package:flutter/material.dart';

/// A custom outlined button widget for the Restock application.
///
/// Features a transparent background with a bordered border, supporting
/// a loading state and disabled/enabled visual feedback.
class RestockOutlinedButton extends StatelessWidget {
  /// Creates a [RestockOutlinedButton] with customizable styling, callback, and state.
  const RestockOutlinedButton({
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
  /// When false, the button visual border opacity is reduced and interactions are disabled.
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
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDisabled
                ? const Color(0xFFC9CED8).withValues(alpha: 0.4)
                : const Color(0xFFC9CED8),
            width: 1.5,
          ),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: Color(0xFF7A808A),
              strokeWidth: 2,
            ),
          )
              : Text(
            text,
            style: TextStyle(
              color: isDisabled
                  ? const Color(0xFF7A808A).withValues(alpha: 0.4)
                  : const Color(0xFF7A808A),
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