import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

const _titleColor = Color(0xFF8B6B1A);
const _cancelColor = Color(0xFFE05A3C);
const _saveColor = Color(0xFF7CB87C);

Future<Color?> showAppColorPickerDialog(
  BuildContext context, {
  required String title,
  required Color originalColor,
}) {
  return showDialog<Color>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (context) {
      return ColorPickerDialog(
        title: title,
        originalColor: originalColor,
      );
    },
  );
}

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    super.key,
    required this.title,
    required this.originalColor,
  });

  final String title;
  final Color originalColor;

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _newColor;

  @override
  void initState() {
    super.initState();
    _newColor = widget.originalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: ColorPicker(
                    color: _newColor,
                    onColorChanged: (color) {
                      setState(() => _newColor = color);
                    },
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.wheel: true,
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.custom: false,
                      ColorPickerType.both: false,
                    },
                    enableShadesSelection: true,
                    wheelDiameter: 200,
                    wheelWidth: 20,
                    wheelSubheading: const Text(
                      'Selected color and its material shades',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _titleColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    showMaterialName: false,
                    showColorName: false,
                    showColorCode: false,
                    spacing: 6,
                    runSpacing: 6,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _comparisonSwatch('Original', widget.originalColor)),
                  Expanded(child: _comparisonSwatch('New', _newColor)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: _cancelColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(_newColor),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: _saveColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _comparisonSwatch(String label, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
          ),
        ),
      ],
    );
  }
}
