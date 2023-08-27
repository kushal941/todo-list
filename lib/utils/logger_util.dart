import 'package:todo/main.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// Instance of [Logger] class.
Logger logger = Logger();

/// Setup logger.
Future<void> setupLogger() async {
  Logger.level = Level.debug; // Set the desired log level

  if (!isInDebugMode) {
    // Get the directory for storing the log file
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory logDir = Directory('${appDocDir.path}/logs');
    await logDir.create(recursive: true);

    // Create a log file
    final File logFile = File('${logDir.path}/app.log');
    if (!logFile.existsSync()) {
      logFile.createSync();
    }

    // Redirect logger output to the log file
    final FileOutput fileOutput = FileOutput(file: logFile);

    logger = Logger(
      printer: PrettyPrinter(),
      output: fileOutput,
    );
  } else {
    logger = Logger(
      printer: PrettyPrinter(),
    );
  }
}
