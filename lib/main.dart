import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:yoink/app_colour.dart';
import 'package:yoink/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppColors _appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yoink It!',
      home: HomePage(appColors: _appColors),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.appColors});

  final AppColors appColors;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<({String title, List<String> subTasks})> _tabLists = [
    (title: 'Tab List 1', subTasks: ['Sub task']),
    (title: 'Tab List 2', subTasks: <String>[]),
  ];
  int _nextListNumber = 3;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  DragAndDropItem _tabListItem({
    required String title,
    List<String> subTasks = const [],
  }) {
    final colors = widget.appColors;

    return DragAndDropItem(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: colors.foregroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 28),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colors.textColor,
                    ),
                  ),
                  for (final subTask in subTasks)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8),
                      child: Row(
                        children: [
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.textColor.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            subTask,
                            style: TextStyle(
                              fontSize: 14,
                              color: colors.textColor.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DragAndDropList> _buildDragLists() {
    return [
      DragAndDropList(
        canDrag: false,
        children: [
          for (final tabList in _tabLists)
            _tabListItem(
              title: tabList.title,
              subTasks: tabList.subTasks,
            ),
        ],
      ),
    ];
  }

  void _onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedItem = _tabLists.removeAt(oldItemIndex);
      _tabLists.insert(newItemIndex, movedItem);
    });
  }

  void _onListReorder(int oldListIndex, int newListIndex) {}

  void _addTabList() {
    setState(() {
      _tabLists.add((
        title: 'Tab List $_nextListNumber',
        subTasks: <String>[],
      ));
      _nextListNumber++;
    });
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => SettingsPage(appColors: widget.appColors),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.appColors;

    return ListenableBuilder(
      listenable: colors,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: colors.backgroundColor,
          floatingActionButton: FloatingActionButton(
            onPressed: _addTabList,
            backgroundColor: colors.foregroundColor,
            elevation: 0,
            child: Icon(Icons.add, color: colors.textColor, size: 32),
          ),
          body: SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'What do you need to do?',
                            style: TextStyle(
                              color: colors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings, color: colors.textColor),
                          iconSize: 28,
                          onPressed: _openSettings,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 88),
                  sliver: DragAndDropLists(
                    children: _buildDragLists(),
                    onItemReorder: _onItemReorder,
                    onListReorder: _onListReorder,
                    sliverList: true,
                    scrollController: _scrollController,
                    listPadding: const EdgeInsets.symmetric(horizontal: 20),
                    itemDivider: const SizedBox(height: 12),
                    itemDragHandle: DragHandle(
                      onLeft: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Icon(
                          Icons.drag_indicator,
                          color: colors.textColor,
                          size: 22,
                        ),
                      ),
                    ),
                    itemDecorationWhileDragging: BoxDecoration(
                      color: colors.foregroundColor,
                      borderRadius: BorderRadius.circular(16),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
