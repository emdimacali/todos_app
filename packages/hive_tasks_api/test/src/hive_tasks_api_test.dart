import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_tasks_api/hive_tasks_api.dart';
import 'package:hive_tasks_api/src/hive_tasks_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tasks_api/tasks_api.dart' as tasks_api;

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<Task> {}

void main() {
  late MockHiveInterface mockHiveInterface;
  late MockHiveBox mockHiveBox;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBox();
    registerFallbackValue(Task(
      id: '1',
      taskName: 'task',
      taskPriority: tasks_api.TaskPriority.low,
      isCompleted: false,
    ));
  });

  group('HiveTasksApi', () {
    final tasks = [
      Task(
        id: '1',
        taskName: 'task1',
        taskPriority: tasks_api.TaskPriority.low,
        isCompleted: false,
      ),
      Task(
        id: '2',
        taskName: 'task2',
        taskPriority: tasks_api.TaskPriority.normal,
        isCompleted: false,
      ),
      Task(
        id: '3',
        taskName: 'task3',
        taskPriority: tasks_api.TaskPriority.high,
        isCompleted: false,
      ),
    ];

    final tasksApiTasks = [
      tasks_api.Task(
        id: '1',
        taskName: 'task1',
        taskPriority: tasks_api.TaskPriority.low,
        isCompleted: false,
      ),
      tasks_api.Task(
        id: '2',
        taskName: 'task2',
        taskPriority: tasks_api.TaskPriority.normal,
        isCompleted: false,
      ),
      tasks_api.Task(
        id: '3',
        taskName: 'task3',
        taskPriority: tasks_api.TaskPriority.high,
        isCompleted: false,
      ),
    ];

    HiveTasksApi newHiveTasksApi() {
      when(() => mockHiveInterface.openBox<Task>(any()))
          .thenAnswer((_) => Future.value(mockHiveBox));
      final hiveTasksApi = HiveTasksApi(mockHiveInterface);
      hiveTasksApi.init();

      return hiveTasksApi;
    }

    Future<HiveTasksApi> awaitNewHiveTasksApi() async {
      when(() => mockHiveInterface.openBox<Task>(any()))
          .thenAnswer((_) => Future.value(mockHiveBox));
      final hiveTasksApi = HiveTasksApi(mockHiveInterface);
      await hiveTasksApi.init();

      return hiveTasksApi;
    }

    group('constructor', () {
      test('works properly', () {
        when(() => mockHiveBox.values).thenReturn([]);
        expect(newHiveTasksApi, returnsNormally);
      });

      group('initializes the todos stream', () {
        test('with existing todos if there are any', () {
          when(() => mockHiveBox.values).thenReturn(tasks);
          final hiveTasksApi = newHiveTasksApi();

          expect(hiveTasksApi.getTasks(), emitsThrough(tasksApiTasks));
          verify(
            () => mockHiveInterface.openBox<Task>('tasks'),
          ).called(1);
        });

        test('with empty list if there is none', () {
          when(() => mockHiveBox.values).thenReturn(<Task>[]);
          final hiveTasksApi = newHiveTasksApi();

          expect(hiveTasksApi.getTasks(), emitsThrough(<tasks_api.Task>[]));
          verify(
            () => mockHiveInterface.openBox<Task>('tasks'),
          ).called(1);
        });
      });
    });

    test('getTasks returns stream of current list todos', () {
      when(() => mockHiveBox.values).thenReturn(tasks);
      expect(
        newHiveTasksApi().getTasks(),
        emitsThrough(tasksApiTasks),
      );
    });

    group('saveTask', () {
      test('saves new task', () async {
        final taskApiNewTask = tasks_api.Task(
          id: '4',
          taskName: 'title 4',
          taskPriority: tasks_api.TaskPriority.high,
          isCompleted: false,
        );
        final taskApiNewTasks = [...tasksApiTasks, taskApiNewTask];
        when(() => mockHiveBox.values).thenReturn(tasks);
        when(() => mockHiveBox.add(any()))
            .thenAnswer((invocation) => Future.value(1));

        final hiveTasksApi = await awaitNewHiveTasksApi();

        //ensure that saveTasks completes
        expect(hiveTasksApi.saveTask(taskApiNewTask), completes);

        //ensure that when we get tasks the list has the new task.
        expect(hiveTasksApi.getTasks(), emitsThrough(taskApiNewTasks));
      });

      test('calls add on hivebox', () async {
        final taskApiNewTask = tasks_api.Task(
          id: '4',
          taskName: 'title 4',
          taskPriority: tasks_api.TaskPriority.high,
          isCompleted: false,
        );

        when(() => mockHiveBox.values).thenReturn(tasks);
        when(() => mockHiveBox.add(any()))
            .thenAnswer((invocation) => Future.value(1));

        final hiveTasksApi = await awaitNewHiveTasksApi();
        await hiveTasksApi.saveTask(taskApiNewTask);
        verify(() => mockHiveBox.add(any()))
            .called(1); //Verify add is being called on Hive Box
      });
      test('updates existing task', () async {
        final tasksApiUpdatedTask = tasks_api.Task(
          id: '1',
          taskName: 'task1',
          taskPriority: tasks_api.TaskPriority.low,
          isCompleted: false,
        );

        final updatedTask = Task(
          id: '1',
          taskName: 'task1',
          taskPriority: tasks_api.TaskPriority.low,
          isCompleted: false,
        );

        final newTasks = [tasksApiUpdatedTask, ...tasksApiTasks.sublist(1)];

        when(() => mockHiveBox.values).thenReturn(tasks);
        when(() => mockHiveBox.put(any(), any()))
            .thenAnswer((_) => Future.value());

        final hiveTasksApi = await awaitNewHiveTasksApi();

        expect(hiveTasksApi.saveTask(tasksApiUpdatedTask), completes);
        expect(hiveTasksApi.getTasks(), emitsThrough(newTasks));

        //expect(actual, matcher);
      });
    });

    group('deleteTask', () {
      test('throws TaskNotFoundException if task does not exist', () async {
        when(() => mockHiveBox.values).thenReturn(tasks);

        final hiveTasksApi = await awaitNewHiveTasksApi();
        expect(hiveTasksApi.deleteTask('something'),
            throwsA(isA<tasks_api.TaskNotFoundException>()));
      });
    });
  });
}
