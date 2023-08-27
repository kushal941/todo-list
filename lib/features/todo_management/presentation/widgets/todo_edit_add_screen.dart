import 'package:todo/features/dashboard/presentation/states/todos_state.dart';
import 'package:todo/features/todo_management/domain/models/todo_model.dart';
import 'package:todo/features/todo_management/presentation/states/todo_state.dart';
import 'package:todo/utils/date_time_util.dart';
import 'package:todo/utils/logger_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/utils/uuid_generator.dart';

/// The function to select date and time.
Future<DateTime?> selectDateTime(BuildContext context) async {
  DateTime? selectedDateTime;
  final DateTime currentDate = DateTime.now();
  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: currentDate,
    lastDate: DateTime(currentDate.year + 1),
  );

  if (selectedDate != null && context.mounted) {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    }
  }

  return selectedDateTime;
}

/// The screen that shows the todos edit / add screen.
class AddEditTodoScreen extends ConsumerStatefulWidget {
  /// Creates an instance of [AddEditTodoScreen].
  const AddEditTodoScreen({Key? key, required this.arguments})
      : super(key: key);

  /// Arguments passed when screen pushed.
  final AddEditTodoScreenArguments arguments;

  @override
  ConsumerState<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends ConsumerState<AddEditTodoScreen> {
  late TodoType selectedType = widget.arguments.todoModel == null
      ? TodoType.business
      : widget.arguments.todoModel!.type;

  late TextEditingController titleController =
      widget.arguments.todoModel == null
          ? TextEditingController()
          : TextEditingController(text: widget.arguments.todoModel!.title);

  late TextEditingController descriptionController = widget
              .arguments.todoModel ==
          null
      ? TextEditingController()
      : TextEditingController(text: widget.arguments.todoModel!.description);

  late DateTime? selectedDateTime = widget.arguments.todoModel == null
      ? null
      : widget.arguments.todoModel!.dateTime;

  GlobalKey<FormState> formKey = GlobalKey<FormState>(); // Add form key

  Future<void> updateTodo() async {
    // Validate the form
    if (formKey.currentState?.validate() == true) {
      TodoModel todoModel = TodoModel(
        uuid: widget.arguments.todoModel!.uuid,
        title: titleController.text,
        description: descriptionController.text,
        type: selectedType,
        dateTime: selectedDateTime!,
        isCompleted: widget.arguments.todoModel!.isCompleted,
      );

      try {
        if (context.mounted) {
          setState(() {
            _isProcessing = true;
          });
        }

        await ref.read(updateTodoCommandStateProvider).run(
              todoModel,
              ref.read(todosModelStateProvider),
            );

        // Reset the form after successful update
        formKey.currentState?.reset();
        // Navigate back to the previous screen
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        logger.e(e);
      } finally {
        if (context.mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  Future<void> addTodo() async {
    // Validate the form
    if (formKey.currentState?.validate() == true) {
      TodoModel todoModel = TodoModel(
        uuid: generateUUID(),
        title: titleController.text,
        description: descriptionController.text,
        type: selectedType,
        dateTime: selectedDateTime!,
        isCompleted: false,
      );

      try {
        if (context.mounted) {
          setState(() {
            _isProcessing = true;
          });
        }

        await ref.read(addTodoCommandCommandStateProvider).run(
              todoModel,
              ref.read(todosModelStateProvider),
            );

        // Reset the form after successful update
        formKey.currentState?.reset();
        // Navigate back to the previous screen
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        logger.e(e);
      } finally {
        if (context.mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      }
    }
  }

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.arguments.todoModel == null ? 'Add New Todo' : 'Edit Todo',
          ),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              DropdownButtonFormField<TodoType>(
                value: selectedType,
                onChanged: (TodoType? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedType = newValue;
                    });
                  }
                },
                items: TodoType.values.map((TodoType type) {
                  return DropdownMenuItem<TodoType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Type of Todo',
                ),
                validator: (TodoType? value) {
                  if (value == null) {
                    return 'Please select a type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Todo Title',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      titleController.clear();
                    },
                  ),
                ),
                validator: (String? value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Todo Description',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      descriptionController.clear();
                    },
                  ),
                ),
                validator: (String? value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                readOnly: true,
                onTap: () async {
                  selectedDateTime = await selectDateTime(context);
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Todo Date and Time',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: selectedDateTime != null
                      ? '${getDateInyMMMdFormat(selectedDateTime!)} '
                          '${getTimeInhhmmaFormat(selectedDateTime!)}'
                      : 'DD MM YYYY HH:MM AM/PM',
                ),
                validator: (String? value) {
                  if (selectedDateTime == null) {
                    return 'Please select a date and time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              _isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : FilledButton(
                      onPressed: widget.arguments.todoModel == null
                          ? addTodo
                          : updateTodo,
                      child: const Text('Done'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Takes [AddEditTodoScreen] arguments passed when screen pushed.
class AddEditTodoScreenArguments {
  /// Defining [AddEditTodoScreenArguments] constructor.
  const AddEditTodoScreenArguments({
    this.todoModel,
  });

  /// Takes [TodoModel] as an argument.
  final TodoModel? todoModel;
}
