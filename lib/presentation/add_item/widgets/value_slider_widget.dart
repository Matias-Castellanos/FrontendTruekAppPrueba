import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class ValueSliderWidget extends StatelessWidget {
  final double currentValue;
  final double minValue;
  final double maxValue;
  final Function(double) onValueChanged;

  const ValueSliderWidget({
    super.key,
    required this.currentValue,
    required this.minValue,
    required this.maxValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estimated Value',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        Slider(
          value: currentValue,
          min: minValue,
          max: maxValue,
          divisions: (maxValue - minValue).toInt(),
          label: currentValue.toStringAsFixed(0),
          onChanged: onValueChanged,
          activeColor: AppTheme.lightTheme.colorScheme.primary,
        ),
        SizedBox(height: 1.h),
        Text(
          '\$${currentValue.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
        ),
      ],
    );
  }
}
