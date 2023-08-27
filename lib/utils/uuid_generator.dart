import 'package:uuid/uuid.dart';

/// Generates a unique identifier.
String generateUUID() {
  const Uuid uuid = Uuid();
  return uuid.v4();
}
