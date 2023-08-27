import 'package:todo/features/todo_management/domain/models/todo_model.dart';

/// A list of todos for testing.
final List<TodoModel> todoList = <TodoModel>[
  TodoModel(
    uuid: "1",
    title: "Learn to juggle chainsaws",
    description: "Start with one, then work your way up!",
    dateTime: DateTime.now(),
    type: TodoType.personal,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "2",
    title: "Teach a cat to breakdance",
    description: "Find the most agile feline around",
    dateTime: DateTime.now(),
    type: TodoType.fun,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "3",
    title: "Create a business plan for a marshmallow factory",
    description: "Determine the best flavors, shapes, and marketing strategies",
    dateTime: DateTime.now(),
    type: TodoType.business,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "4",
    title: "Convince a penguin to be your butler",
    description:
        "Dress in a tuxedo and offer a fishy incentive. Penguins love fish!",
    dateTime: DateTime.now(),
    type: TodoType.personal,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "5",
    title: "Invent a language only you can understand",
    description:
        "Combine gibberish and made-up words to create your unique language",
    dateTime: DateTime.now(),
    type: TodoType.personal,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "6",
    title: "Prepare a stand-up comedy routine for a corporate event",
    description: "Practice jokes that are both funny and appropriate",
    dateTime: DateTime.now(),
    type: TodoType.business,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "7",
    title: "Learn to speak fluent dolphin",
    description: "Practice your clicks and whistles in the ocean",
    dateTime: DateTime.now(),
    type: TodoType.personal,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "8",
    title: "Become a professional pillow fighter",
    description: "Train in the art of soft, yet epic, battles",
    dateTime: DateTime.now(),
    type: TodoType.fun,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "9",
    title: "Create a marketing campaign for a clown college",
    description: "Come up with catchy slogans and eye-catching ads",
    dateTime: DateTime.now(),
    type: TodoType.business,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "10",
    title: "Master the art of eating pizza without getting messy",
    description:
        "Devise a strategy and practice with different sizes and toppings",
    dateTime: DateTime.now(),
    type: TodoType.personal,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "11",
    title: "Organize a paper airplane championship",
    description:
        "Invite friends to compete in distance, accuracy, and style categories",
    dateTime: DateTime.now(),
    type: TodoType.fun,
    isCompleted: false,
  ),
  TodoModel(
    uuid: "12",
    title: "Develop a budget for a pet rock adoption agency",
    description:
        "Consider costs for rock grooming, feeding, & rock-themed accessories",
    dateTime: DateTime.now(),
    type: TodoType.business,
    isCompleted: false,
  ),
];
