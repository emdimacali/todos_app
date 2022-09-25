import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// This is how urgent a task is.
///
/// - *high* is most urgent
///
/// - *normal* is urgent
///
/// - *low* is least urgent

enum TaskPriority {
  high,
  normal,
  low,
}

/// A single task item.
///
/// Contains a [taskName], [taskPriority] and an [isCompleted]
/// flag.
///
/// If an [id] is provided, it must not be empty. If no [id] is
/// passed, it will be generated.
///
class Task extends Equatable {
  final String id;
  final String taskName;
  final TaskPriority taskPriority;
  final bool isCompleted;

  Task({
    String? id,
    required this.taskName,
    required this.taskPriority,
    this.isCompleted = false,
  })  : assert(
          id == null || id.isNotEmpty,
          'id cannot be null and must not be empty',
        ),
        id = id ?? const Uuid().v1(); // Time based id

  Task copyWith({
    String? id,
    String? taskName,
    TaskPriority? taskPriority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      taskPriority: taskPriority ?? this.taskPriority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [id, taskName, taskPriority, isCompleted];
}
