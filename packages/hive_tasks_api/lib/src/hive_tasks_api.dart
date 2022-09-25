import 'package:hive/hive.dart';
import 'package:hive_tasks_api/hive_tasks_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tasks_api/tasks_api.dart' as tasks_api;

class HiveTasksApi extends tasks_api.TasksApi {
  // HiveTasksApi(this.hive) {
  //   _init();
  // }
  HiveTasksApi(this.hive);

  final HiveInterface hive;

  late Box<Task> _tasksBox;
  final String _tasksBoxName = 'tasks';

  /// Provides a [Stream] of [List] of base Task model.
  final _taskStreamController =
      BehaviorSubject<List<tasks_api.Task>>.seeded(const []);

  /// Setup Hive.
  /// Required to call this, before doing other operations.
  /// Otherwise, operations will fail.
  ///
  /// Setups the [TypeAdapter] for [Task]
  /// and opens a [Box] for it.
  Future<void> init() async {
    hive.registerAdapter(TaskAdapter());
    _tasksBox = await hive.openBox<Task>(_tasksBoxName);

    // Get task values from Box
    final taskList = _tasksBox.values.toList();

    // Convert to the Task Model
    List<tasks_api.Task> convertedTasks = [];
    for (final taskHive in taskList) {
      final task = taskHive.toTaskModel();
      convertedTasks.add(task);
    }

    _taskStreamController.add(convertedTasks);
  }

  @override
  Stream<List<tasks_api.Task>> getTasks() =>
      _taskStreamController.asBroadcastStream();

  @override
  Future<void> deleteTask(String id) async {
    // Get the current value of tasksApi.Tasks in the Stream
    final tasks = [..._taskStreamController.value];

    // Check if task already exists.
    final taskIndex = tasks.indexWhere((t) => t.id == id);

    if (taskIndex == -1) {
      throw tasks_api.TaskNotFoundException();
    } else {
      tasks.removeAt(taskIndex);
      _taskStreamController.add(tasks);

      // Remove from Box
      final taskToRemove =
          _tasksBox.values.firstWhere((element) => element.id == id);
      await taskToRemove.delete();
    }
  }

  @override
  Future<void> saveTask(tasks_api.Task task) async {
    // Get the current value of tasksApi.Tasks in the Stream
    final tasks = [..._taskStreamController.value];

    // Check if task already exists.
    final taskIndex = tasks.indexWhere((t) => t.id == task.id);

    if (taskIndex >= 0) {
      // Task is already existing
      tasks[taskIndex] = task;
      await _tasksBox.put(taskIndex, Task.fromTaskModel(task));
    } else {
      // Task not yet existing
      tasks.add(task);
      await _tasksBox.add(Task.fromTaskModel(task));
    }
    // add to stream the new list of tasks
    _taskStreamController.add(tasks);
  }
}
