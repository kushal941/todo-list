import 'package:todo/features/dashboard/presentation/states/todos_state.dart';
import 'package:todo/features/todo_management/domain/models/todo_model.dart';
import 'package:todo/features/todo_management/presentation/states/todo_state.dart';
import 'package:todo/features/todo_management/presentation/widgets/todo_edit_add_screen.dart';
import 'package:todo/route/app_routes.dart' as route;
import 'package:todo/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The type of lists.
enum ListType {
  /// The inbox list.
  inbox,

  /// The completed list.
  completed,
}

/// Widget for the [HomeScreen] body.
class HomeBodyList extends ConsumerWidget {
  /// Creates an instance of [HomeBodyList].
  const HomeBodyList({
    super.key,
    required this.todos,
    required this.isLoading,
    required this.listType,
  });

  /// The todos.
  final List<TodoModel> todos;

  /// The loading state.
  final bool isLoading;

  /// Type of list to display.
  final ListType listType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// The function to call when a todos is deleted.
    Future<void> onDelete(int index) async {
      await ref.read(deleteTodoCommandStateProvider).run(
            todos[index].uuid,
            ref.read(todosModelStateProvider),
          );
    }

    /// The function to call when a todos is marked as done.
    void onDone(int index) {
      ref.read(updateTodoCommandStateProvider).run(
            todos[index].copyWith(isCompleted: true),
            ref.read(todosModelStateProvider),
          );
    }

    return !isLoading && todos.isNotEmpty
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // Determine whether to show a separator
                final bool isLastItem = index == todos.length - 1;
                final Widget tile = TodoDisplayTile(
                  title: todos[index].title,
                  description: todos[index].description,
                  dateTime: todos[index].dateTime,
                  index: index,
                  type: todos[index].type,
                  isCompleted: todos[index].isCompleted,
                  onEdit: () {
                    Navigator.pushNamed(
                      context,
                      route.AppRoutes.addEditTodoScreen,
                      arguments: AddEditTodoScreenArguments(
                        todoModel: todos[index],
                      ),
                    );
                  },
                  onDelete: () {
                    onDelete(index);
                  },
                );

                if (isLastItem) {
                  return todos[index].isCompleted
                      ? tile
                      : CustomDismissible(
                          uuid: todos[index].uuid,
                          onDelete: () {
                            onDelete(index);
                          },
                          onDone: () {
                            onDone(index);
                          },
                          child: tile,
                        ); // No separator for the last item
                }

                // Return the tile with a separator
                return todos[index].isCompleted
                    ? Column(
                        children: <Widget>[
                          tile,
                          const Divider(
                            height: 0,
                            endIndent: 16,
                            indent: 16,
                          ), // Add a separator between items
                        ],
                      )
                    : CustomDismissible(
                        uuid: todos[index].uuid,
                        onDelete: () {
                          onDelete(index);
                        },
                        onDone: () {
                          onDone(index);
                        },
                        child: Column(
                          children: <Widget>[
                            tile,
                            const Divider(
                              height: 0,
                              endIndent: 16,
                              indent: 16,
                            ), // Add a separator between items
                          ],
                        ),
                      );
              },
              childCount: todos.length,
            ),
          )
        : !isLoading && todos.isEmpty
            ? SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      listType == ListType.completed
                          ? 'No todos in Completed...'
                          : 'No todos in Inbox...',
                    ),
                  ],
                ),
              )
            : SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      listType == ListType.completed
                          ? 'Loading completed todos...'
                          : 'Loading inbox todos...',
                    ),
                  ],
                ),
              );
  }
}

/// Widget for a custom [Dismissible] widget.
class CustomDismissible extends StatelessWidget {
  /// Creates an instance of [CustomDismissible].
  const CustomDismissible({
    super.key,
    required this.uuid,
    required this.child,
    this.onDelete,
    this.onDone,
  });

  /// The index of the item.
  final String uuid;

  /// The child widget.
  final Widget child;

  /// The callback function for when the item is deleted.
  final void Function()? onDelete;

  /// The callback function for when the item is marked as done.
  final void Function()? onDone;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(uuid),
      background: Container(
        color: Colors.red,
        child: const ListTile(
          leading: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        child: const ListTile(
          trailing: Icon(Icons.done, color: Colors.white),
        ),
      ),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          onDelete?.call();
        } else if (direction == DismissDirection.endToStart) {
          onDone?.call();
        }
      },
      child: child,
    );
  }
}

/// Widget for todos display tile.
class TodoDisplayTile extends StatefulWidget {
  /// Creates an instance of [TodoDisplayTile].
  const TodoDisplayTile({
    Key? key,
    required this.index,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.type,
    required this.isCompleted,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  /// The index of the item.
  final int index;

  /// The todos title.
  final String title;

  /// The todos description.
  final String description;

  /// The todos time.
  final DateTime dateTime;

  /// The todos type.
  final TodoType type;

  /// Whether the todos is completed.
  final bool isCompleted;

  /// The onEdit callback.
  final void Function()? onEdit;

  /// The onDelete callback.
  final void Function()? onDelete;

  @override
  State<TodoDisplayTile> createState() => _TodoDisplayTileState();
}

class _TodoDisplayTileState extends State<TodoDisplayTile> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: ListTile(
        enabled: !widget.isCompleted,
        leading: Icon(
          widget.type == TodoType.business
              ? Icons.work
              : widget.type == TodoType.personal
                  ? Icons.person
                  : Icons.sports_volleyball,
        ),
        title: AnimatedCrossFade(
          // Wrap the title with AnimatedCrossFade
          firstChild: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium!.copyWith(
              decoration: widget.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          secondChild: Text(
            widget.title,
            style: theme.textTheme.titleMedium!.copyWith(
              decoration: widget.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        subtitle: AnimatedCrossFade(
          firstChild: Text(
            widget.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall!.copyWith(
              decoration: widget.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          secondChild: Text(
            widget.description,
            style: theme.textTheme.bodySmall!.copyWith(
              decoration: widget.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(getDateInyMMMdFormat(widget.dateTime)),
                Text(getTimeInhhmmaFormat(widget.dateTime)),
              ],
            ),
            !widget.isCompleted
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: widget.onEdit,
                  )
                : IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  ),
          ],
        ),
      ),
    );
  }
}
