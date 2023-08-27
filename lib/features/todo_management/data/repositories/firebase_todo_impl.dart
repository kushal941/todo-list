import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/features/todo_management/data/repositories/todo_repository.dart';
import 'package:todo/features/todo_management/domain/models/todo_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A implementation class of [TodoRepository] for firebase database.
class FirebaseTodoImpl implements TodoRepository {
  /// Creates an instance of [FirebaseAuthImpl].
  FirebaseTodoImpl(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<List<TodoModel>> getTodos() async {
    final User? currentUser = _firebaseAuth.currentUser;
    final QuerySnapshot<Map<String, dynamic>> todosSnapshot = await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todos')
        .get();

    return todosSnapshot.docs.map((
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
    ) {
      final Map<String, dynamic> data = doc.data();
      data['uuid'] = doc.id;
      return TodoModel.fromJson(data);
    }).toList();
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    final User? currentUser = _firebaseAuth.currentUser;
    final Map<String, dynamic> todoData = todo.toJson();

    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todos')
        .doc(todo.uuid) // Assigning a specific document ID
        .set(todoData);
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    final User? currentUser = _firebaseAuth.currentUser;
    final Map<String, dynamic> todoData = todo.toJson();

    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todos')
        .doc(todo.uuid)
        .update(todoData);
  }

  @override
  Future<void> deleteTodo(String uuid) async {
    final User? currentUser = _firebaseAuth.currentUser;
    await _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('todos')
        .doc(uuid)
        .delete();
  }
}
