import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:yoink/app_colour.dart';
import 'package:yoink/dialog/colour_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.appColors});

  final AppColors appColors;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const _deleteColor = Color(0xFFE05A3C);
  static const _backupColor = Color(0xFF7CB87C);

  late List<DragAndDropList> _sections;

  AppColors get _colors => widget.appColors;

  @override
  void initState() {
    super.initState();
    _sections = _buildSections();
    _colors.addListener(_onColorsChanged);
  }

  @override
  void dispose() {
    _colors.removeListener(_onColorsChanged);
    super.dispose();
  }

  void _onColorsChanged() {
    setState(() {
      _sections = _buildSections();
    });
  }

  List<DragAndDropList> _buildSections() {
    return [
      _colourSection(),
      _section(
        title: 'Preset Theme Preference',
        items: [
          _item(
            label: 'Theme',
            trailing: const _RainbowSwatch(),
          ),
        ],
      ),
      _section(
        title: 'Date/Time Preferences',
        items: [
          _item(
            label: 'Set Time',
            trailing: _trailingText('19:00 - Today'),
          ),
          _item(
            label: 'Set Date',
            trailing: _trailingText('12:00 - 27th May'),
          ),
        ],
      ),
      _section(
        title: 'Font Preference',
        items: [
          _item(
            label: 'Font',
            trailing: _trailingText('Font'),
          ),
        ],
      ),
    ];
  }

  DragAndDropList _colourSection() {
    return _section(
      title: 'Colour Preferences',
      items: [
        _item(
          label: 'Background Colour',
          trailing: _colorSwatch(fill: _colors.backgroundColor),
          onTap: () => _pickColor(
            title: 'Background colour',
            initialColor: _colors.backgroundColor,
            onSelected: _colors.setBackgroundColor,
          ),
        ),
        _item(
          label: 'Foreground Colour',
          trailing: _colorSwatch(fill: _colors.foregroundColor),
          onTap: () => _pickColor(
            title: 'Foreground colour',
            initialColor: _colors.foregroundColor,
            onSelected: _colors.setForegroundColor,
          ),
        ),
        _item(
          label: 'Text Colour',
          labelColor: _colors.textColor,
          trailing: _colorSwatch(fill: _colors.textColor),
          onTap: () => _pickColor(
            title: 'Text colour',
            initialColor: _colors.textColor,
            onSelected: _colors.setTextColor,
          ),
        ),
      ],
    );
  }

  Future<void> _pickColor({
    required String title,
    required Color initialColor,
    required ValueChanged<Color> onSelected,
  }) async {
    final picked = await showAppColorPickerDialog(
      context,
      title: title,
      originalColor: initialColor,
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  DragAndDropList _section({
    required String title,
    required List<DragAndDropItem> items,
  }) {
    return DragAndDropList(
      canDrag: false,
      header: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
        child: Text(
          title,
          style: TextStyle(
            color: _colors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      children: items,
    );
  }

  DragAndDropItem _item({
    required String label,
    required Widget trailing,
    Color? labelColor,
    VoidCallback? onTap,
  }) {
    return DragAndDropItem(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: _colors.foregroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(width: 28),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: labelColor ?? _colors.textColor,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorSwatch({required Color fill, Color? border}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: border != null ? Border.all(color: border, width: 1.5) : null,
      ),
    );
  }

  Widget _trailingText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: _colors.textColor.withValues(alpha: 0.7),
      ),
    );
  }

  void _onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedItem =
          _sections[oldListIndex].children.removeAt(oldItemIndex);
      _sections[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  void _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      final movedList = _sections.removeAt(oldListIndex);
      _sections.insert(newListIndex, movedList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _colors,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: _colors.backgroundColor,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                  child: Row(
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: _colors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: _colors.textColor,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DragAndDropLists(
                    children: _sections,
                    onItemReorder: _onItemReorder,
                    onListReorder: _onListReorder,
                    listPadding: const EdgeInsets.symmetric(horizontal: 20),
                    itemDivider: const SizedBox(height: 8),
                    listDivider: const SizedBox(height: 4),
                    itemDragHandle: DragHandle(
                      onLeft: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Icon(
                          Icons.drag_indicator,
                          color: _colors.textColor,
                          size: 22,
                        ),
                      ),
                    ),
                    itemDecorationWhileDragging: BoxDecoration(
                      color: _colors.foregroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Delete all data',
                          style: TextStyle(
                            color: _deleteColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Backup all data',
                          style: TextStyle(
                            color: _backupColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RainbowSwatch extends StatelessWidget {
  const _RainbowSwatch();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
            Colors.red,
          ],
        ),
      ),
    );
  }
}