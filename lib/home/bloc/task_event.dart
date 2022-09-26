part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskSubscriptionRequested extends TaskEvent {}

class TaskDeleted extends TaskEvent {}

class TaskAdded extends TaskEvent {
  const TaskAdded(this.taskName, this.taskPriority);

  final String taskName;
  final String taskPriority;
}

class TaskTicked extends TaskEvent {
  const TaskTicked(this.task);

  final Task task;
}
