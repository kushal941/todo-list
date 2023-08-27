import 'package:flutter/material.dart';
import 'dart:math' as math;

/// The type of todos sorting.
enum TodoSortType {
  /// The oldest todos first.
  oldest,

  /// The newest todos first.
  newest,
}

/// Returns the label for a given TodoSortType.
String getTodoSortTypeLabel(TodoSortType type) {
  // Return the label for a given TodoType.
  switch (type) {
    case TodoSortType.oldest:
      return 'Sort by Oldest';
    case TodoSortType.newest:
      return 'Sort by Newest';
  }
}

/// The type of todos filtering.
enum TodoFilterType {
  /// The all todos.
  all,

  /// The business todos.
  business,

  /// The personal todos.
  personal,

  /// The fun todos.
  fun,
}

/// Returns the label for a given TodoType.
String getTodoFilterTypeLabel(TodoFilterType type) {
  // Return the label for a given TodoType.
  switch (type) {
    case TodoFilterType.all:
      return 'All';
    case TodoFilterType.business:
      return 'Business';
    case TodoFilterType.personal:
      return 'Personal';
    case TodoFilterType.fun:
      return 'Fun';
  }
}

/// Widget for the filtering and sorting section.
class FilterListContent extends StatelessWidget {
  /// Creates an instance of [FilterListContent].
  const FilterListContent({
    Key? key,
    required this.sectionHeight,
    this.onFilterSelection,
    this.onSortSelection,
    required this.selectedFilterType,
    required this.selectedSortType,
  }) : super(key: key);

  /// The height of the section.
  final double sectionHeight;

  /// The callback for when a filter is selected.
  final void Function(TodoFilterType)? onFilterSelection;

  /// The callback for when a sort is selected.
  final void Function(TodoSortType)? onSortSelection;

  /// The selected filter type.
  final TodoFilterType selectedFilterType;

  /// The selected sort type.
  final TodoSortType selectedSortType;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceVariant,
      height: sectionHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            PopupMenuButton<TodoFilterType>(
              icon: const Icon(Icons.filter_list),
              initialValue: selectedFilterType,
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<TodoFilterType>>[
                  for (TodoFilterType type in TodoFilterType.values)
                    PopupMenuItem<TodoFilterType>(
                      value: type,
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(getTodoFilterTypeLabel(type)),
                        leading: Radio<TodoFilterType>(
                          value: type,
                          groupValue: selectedFilterType,
                          onChanged: (TodoFilterType? value) {
                            onFilterSelection?.call(value!);
                          },
                        ),
                      ),
                    ),
                ];
              },
              onSelected: (TodoFilterType value) {
                onFilterSelection?.call(value);
              },
            ),
            const Spacer(),
            PopupMenuButton<TodoSortType>(
              icon: const Icon(Icons.sort),
              initialValue: selectedSortType,
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<TodoSortType>>[
                  for (TodoSortType type in TodoSortType.values)
                    PopupMenuItem<TodoSortType>(
                      value: type,
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        title: Text(getTodoSortTypeLabel(type)),
                        leading: Radio<TodoSortType>(
                          value: type,
                          groupValue: selectedSortType,
                          onChanged: (TodoSortType? value) {
                            onSortSelection?.call(value!);
                          },
                        ),
                      ),
                    ),
                ];
              },
              onSelected: (TodoSortType value) {
                onSortSelection?.call(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A delegate that makes [FilterListContent] persistent.
class FilterListSectionDelegate extends SliverPersistentHeaderDelegate {
  /// Creates an instance of [FilterListSectionDelegate].
  FilterListSectionDelegate({
    required this.collapsedHeight,
    required this.expandedHeight,
    this.onFilterSelection,
    this.onSortSelection,
    required this.selectedFilterType,
    required this.selectedSortType,
  });

  /// The callback for when a filter is selected.
  final void Function(TodoFilterType)? onFilterSelection;

  /// The callback for when a sort is selected.
  final void Function(TodoSortType)? onSortSelection;

  /// The selected filter type.
  final TodoFilterType selectedFilterType;

  /// The selected sort type.
  final TodoSortType selectedSortType;

  /// The height of the section when collapsed.
  final double expandedHeight;

  /// The height of the section when expanded.
  final double collapsedHeight;

  @override
  double get minExtent => collapsedHeight;
  @override
  double get maxExtent => math.max(expandedHeight, minExtent);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // A nice filter list section
    return FilterListContent(
      sectionHeight: maxExtent,
      onFilterSelection: onFilterSelection,
      onSortSelection: onSortSelection,
      selectedFilterType: selectedFilterType,
      selectedSortType: selectedSortType,
    );
  }

  @override
  bool shouldRebuild(FilterListSectionDelegate oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        collapsedHeight != oldDelegate.collapsedHeight ||
        selectedFilterType != oldDelegate.selectedFilterType ||
        selectedSortType != oldDelegate.selectedSortType;
  }
}

/// A widget that represents the filter todos section.
class FilterTodosSection extends StatelessWidget {
  /// Creates an instance of [FilterTodosSection].
  const FilterTodosSection({
    super.key,
    this.onFilterSelection,
    this.onSortSelection,
    required this.selectedFilterType,
    required this.selectedSortType,
  });

  /// The callback for when a filter is selected.
  final void Function(TodoFilterType)? onFilterSelection;

  /// The callback for when a sort is selected.
  final void Function(TodoSortType)? onSortSelection;

  /// The selected filter type.
  final TodoFilterType selectedFilterType;

  /// The selected sort type.
  final TodoSortType selectedSortType;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: FilterListSectionDelegate(
        collapsedHeight: 50,
        expandedHeight: 50,
        onFilterSelection: onFilterSelection,
        onSortSelection: onSortSelection,
        selectedFilterType: selectedFilterType,
        selectedSortType: selectedSortType,
      ),
      pinned: true, // Keep the filter button pinned
    );
  }
}
