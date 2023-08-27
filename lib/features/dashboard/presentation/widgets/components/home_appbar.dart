import 'package:todo/features/dashboard/presentation/widgets/home_screen.dart';
import 'package:todo/features/shared/presentation/widgets/onboarding/overlay_container.dart';
import 'package:todo/features/todo_management/domain/models/todo_model.dart';
import 'package:todo/utils/date_time_util.dart';
import 'package:flutter/material.dart';

/// Widget for the [HomeScreen] app bar.
class HomeAppBar extends StatefulWidget {
  /// Creates an instance of [HomeAppBar].
  const HomeAppBar({
    super.key,
    required this.todos,
  });

  /// The todos.
  final List<TodoModel> todos;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  static const double kExpandedHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    int personalTodos = widget.todos
        .where((TodoModel element) => element.type == TodoType.personal)
        .length;

    int businessTodos = widget.todos
        .where((TodoModel element) => element.type == TodoType.business)
        .length;

    int completedTodos =
        widget.todos.where((TodoModel element) => element.isCompleted).length;

    int totalTodos = widget.todos.length;

    double progress = totalTodos == 0 ? 0.0 : (completedTodos / totalTodos);
    String progressString = (progress * 100).toStringAsFixed(2);

    return SliverAppBar(
      pinned: true,
      expandedHeight: kExpandedHeight,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          bool isSliverAppBarExpanded =
              MediaQuery.of(context).padding.top + kToolbarHeight ==
                  constraints.biggest.height;

          return Stack(
            children: <Widget>[
              FlexibleSpaceBar(
                // show and hide SliverAppBar Title
                title: isSliverAppBarExpanded
                    ? Text(
                        'Home',
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      )
                    : null,

                background: Stack(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/app_bar_background.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: OverlayContainer(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // height of the collapsed app bar
                              const SizedBox(height: kToolbarHeight),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "Your\nThings",
                                    style: theme.textTheme.displaySmall,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            personalTodos.toString(),
                                            style: theme.textTheme.bodyLarge,
                                          ),
                                          Text(
                                            "Personal",
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            businessTodos.toString(),
                                            style: theme.textTheme.bodyLarge,
                                          ),
                                          Text(
                                            "Buisness",
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    getDateInyMMMdFormat(DateTime.now()),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CustomCircularProgressIndicator(
                                          progress: progress,
                                          progressColor:
                                              theme.colorScheme.primary,
                                          backgroundColor: Colors.transparent,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "$progressString% done",
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: CustomLinearProgressIndicator(
                        progress: progress,
                        progressColor:
                            theme.colorScheme.primary.withOpacity(0.35),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CustomLinearProgressIndicator(
                  progress: progress,
                  progressColor: theme.colorScheme.primary,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// This widget is used to animate the linear progress indicator.
class CustomLinearProgressIndicator extends StatelessWidget {
  /// Creates an instance of [CustomLinearProgressIndicator].
  const CustomLinearProgressIndicator({
    Key? key,
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    this.animationDuration = const Duration(seconds: 2),
  }) : super(key: key);

  /// The progress of the linear progress indicator.
  final double progress;

  /// The color of the linear progress indicator.
  final Color progressColor;

  /// The background color of the linear progress indicator.
  final Color backgroundColor;

  /// The duration of the animation.
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: animationDuration,
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: progress,
      ),
      builder: (BuildContext context, double value, _) =>
          LinearProgressIndicator(
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

/// This widget is used to animate the circular progress indicator.
class CustomCircularProgressIndicator extends StatelessWidget {
  /// Creates an instance of [CustomLinearProgressIndicator].
  const CustomCircularProgressIndicator({
    Key? key,
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    this.animationDuration = const Duration(seconds: 2),
  }) : super(key: key);

  /// The progress of the linear progress indicator.
  final double progress;

  /// The color of the linear progress indicator.
  final Color progressColor;

  /// The background color of the linear progress indicator.
  final Color backgroundColor;

  /// The duration of the animation.
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: animationDuration,
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: 0,
        end: progress,
      ),
      builder: (BuildContext context, double value, _) =>
          CircularProgressIndicator(
        value: value,
        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
