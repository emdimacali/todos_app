import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required TasksRepository tasksRepository,
  })  : _tasksRepository = tasksRepository,
        super(const TaskState()) {
    on<TaskSubscriptionRequested>(_onSubscriptionRequested);
    on<TaskAdded>(_onTaskAdded);
    on<TaskTicked>(_onTaskTicked);
    on<TaskViewed>(_onTaskViewed);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskDeleted>(_onTaskDeleted);
  }

  final TasksRepository _tasksRepository;

  Future<void> _onSubscriptionRequested(
    TaskSubscriptionRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));

    await emit.forEach<List<Task>>(_tasksRepository.getTasks(),
        onData: (tasks) {
          final completedTasksCount = _getCompletedTasks(tasks);
          final pendingTasksCount = _getPendingTasks(tasks);
          final sortedTasks = _sortTasks(tasks);

          return state.copyWith(
            status: TaskStatus.success,
            tasks: sortedTasks,
            completedTasks: completedTasksCount,
            pendingTasks: pendingTasksCount,
          );
        },
        onError: (_, __) => state.copyWith(status: TaskStatus.failure));
  }

  int taskPriorityImportance(String taskPriority) {
    if (taskPriority == TaskPriority.low) return 3;
    if (taskPriority == TaskPriority.normal) return 2;
    if (taskPriority == TaskPriority.high) return 1;

    return 0;
  }

  List<Task> _sortTasks(List<Task> tasks) {
    final highPrioTasks =
        tasks.where((task) => task.taskPriority == TaskPriority.high).toList();
    final normalPrioTasks = tasks
        .where((task) => task.taskPriority == TaskPriority.normal)
        .toList();
    final lowPrioTasks =
        tasks.where((task) => task.taskPriority == TaskPriority.low).toList();

    highPrioTasks.sort((a, b) => a.taskName.compareTo(b.taskName));
    normalPrioTasks.sort((a, b) => a.taskName.compareTo(b.taskName));
    lowPrioTasks.sort((a, b) => a.taskName.compareTo(b.taskName));

    return [
      ...highPrioTasks,
      ...normalPrioTasks,
      ...lowPrioTasks,
    ];
  }

  int _getCompletedTasks(List<Task> tasks) =>
      tasks.where((task) => task.isCompleted).length;
  int _getPendingTasks(List<Task> tasks) =>
      tasks.where((task) => !task.isCompleted).length;

  Future<void> _onTaskAdded(
    TaskAdded event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));

    try {
      final newTask = Task(
        taskName: event.taskName,
        taskPriority: event.taskPriority,
        isCompleted: false,
      );

      await _tasksRepository.saveTask(newTask);
      emit(state.copyWith(status: TaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure));
    }
  }

  Future<void> _onTaskTicked(
    TaskTicked event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));

    try {
      Task updatedTask =
          event.task.copyWith(isCompleted: !event.task.isCompleted);

      await _tasksRepository.saveTask(updatedTask);
      emit(state.copyWith(status: TaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure));
    }
  }

  Future<void> _onTaskViewed(
    TaskViewed event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));

    try {
      emit(state.copyWith(
          status: TaskStatus.success, taskBeingEdited: event.task));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure));
    }
  }

  Future<void> _onTaskUpdated(
    TaskUpdated event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));

    try {
      Task updatedTask = state.taskBeingEdited!
          .copyWith(taskName: event.taskName, taskPriority: event.taskPriority);
      await _tasksRepository.saveTask(updatedTask);
      emit(state.copyWith(status: TaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure));
    }
  }

  Future<void> _onTaskDeleted(
    TaskDeleted event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));

    try {
      await _tasksRepository.deleteTask(event.id);
      emit(state.copyWith(status: TaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.failure));
    }
  }
}
