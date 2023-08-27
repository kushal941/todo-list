import 'package:todo/features/dashboard/domain/models/todos_model.dart';
import 'package:todo/features/dashboard/presentation/states/todos_state.dart';
import 'package:todo/features/dashboard/presentation/widgets/components/custom_drawer.dart';
import 'package:todo/features/dashboard/presentation/widgets/components/home_appbar.dart';
import 'package:todo/features/dashboard/presentation/widgets/components/home_body_section.dart';
import 'package:todo/features/dashboard/presentation/widgets/components/todo_filter_section.dart';
import 'package:todo/features/todo_management/domain/models/todo_model.dart';
import 'package:todo/features/todo_management/presentation/widgets/todo_edit_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/route/app_routes.dart' as route;

/// The screen that shows the app dashboard.
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates an instance of [HomeScreen].
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TodosModel unFilteredTodosModel = const TodosModel();
  TodosModel filteredTodoModel = const TodosModel();

  /// The todos loading state.
  late bool isLoading;

  TodoFilterType selectedFilterType = TodoFilterType.all;
  TodoSortType selectedSortType = TodoSortType.newest;

  @override
  void initState() {
    loadTodos();

    super.initState();
  }

  Future<void> loadTodos() async {
    setState(() {
      isLoading = true;
    });
    //Wait till build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(loadTodosCommandStateProvider).run().whenComplete(() {
        // Get the updated todos model
        unFilteredTodosModel = ref.read(todosModelStateProvider);
        setState(() {
          isLoading =
              false; // Set the loading state to false when todos are loaded
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    unFilteredTodosModel = ref.watch(todosModelStateProvider);

    filteredTodoModel = unFilteredTodosModel;

    // Use the filterType to filter the todos
    filteredTodoModel = filteredTodoModel.copyWith(
      todos: filteredTodoModel.todos.where(
        (TodoModel element) {
          // Use switch statement to filter the todos
          switch (selectedFilterType) {
            case TodoFilterType.all:
              return true;
            case TodoFilterType.business:
              return element.type == TodoType.business;
            case TodoFilterType.fun:
              return element.type == TodoType.fun;
            case TodoFilterType.personal:
              return element.type == TodoType.personal;
          }
        },
      ).toList(),
    );

    // Use the sortType to sort the todos
    filteredTodoModel = filteredTodoModel.copyWith(
      todos: filteredTodoModel.todos.toList()
        ..sort((TodoModel a, TodoModel b) {
          if (selectedSortType == TodoSortType.newest) {
            return b.dateTime.compareTo(a.dateTime);
          } else {
            return a.dateTime.compareTo(b.dateTime);
          }
        }),
    );

    final List<TodoModel> inboxTodos = filteredTodoModel.todos
        .where((TodoModel element) => element.isCompleted == false)
        .toList();

    final List<TodoModel> completedTodos = filteredTodoModel.todos
        .where((TodoModel element) => element.isCompleted == true)
        .toList();

    return Scaffold(
      drawer: const CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: loadTodos,
        child: CustomScrollView(
          slivers: <Widget>[
            HomeAppBar(
              todos: unFilteredTodosModel.todos,
            ),
            !isLoading && unFilteredTodosModel.todos.isNotEmpty
                ? FilterTodosSection(
                    onFilterSelection: (TodoFilterType value) {
                      setState(() {
                        selectedFilterType = value;
                      });
                    },
                    onSortSelection: (TodoSortType value) {
                      setState(() {
                        selectedSortType = value;
                      });
                    },
                    selectedFilterType: selectedFilterType,
                    selectedSortType: selectedSortType,
                  )
                : const SliverToBoxAdapter(
                    child: SizedBox(),
                  ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Inbox',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            HomeBodyList(
              todos: inboxTodos,
              isLoading: isLoading,
              listType: ListType.inbox,
            ),
            const SliverToBoxAdapter(
              child: Divider(
                height: 1,
                thickness: 1,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Completed',
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            ),
            HomeBodyList(
              todos: completedTodos,
              isLoading: isLoading,
              listType: ListType.completed,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            route.AppRoutes.addEditTodoScreen,
            arguments: const AddEditTodoScreenArguments(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
