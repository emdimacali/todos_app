part of 'task_bloc.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  const TaskState({
    this.tasks = const [],
    this.status = TaskStatus.initial,
    this.completedTasks = 0,
    this.pendingTasks = 0,
    this.taskBeingEdited,
  });

  final List<Task> tasks;
  final TaskStatus status;
  final int completedTasks;
  final int pendingTasks;
  final Task? taskBeingEdited;

  @override
  List<Object?> get props => [
        tasks,
        status,
        completedTasks,
        pendingTasks,
        taskBeingEdited,
      ];

  TaskState copyWith({
    List<Task>? tasks,
    TaskStatus? status,
    int? completedTasks,
    int? pendingTasks,
    Task? taskBeingEdited,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      completedTasks: completedTasks ?? this.completedTasks,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      taskBeingEdited: taskBeingEdited ?? this.taskBeingEdited,
    );
  }
}
