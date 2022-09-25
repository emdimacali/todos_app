import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/src/tasks_repository.dart';

class MockTodosApi extends Mock implements TasksApi {}

class FakeTodo extends Fake implements Task {}

void main() {
  group('TasksRepository', () {
    late TasksApi api;

    final tasks = [
      Task(
        id: '1',
        taskName: 'title 1',
        taskPriority: TaskPriority.low,
      ),
      Task(
        id: '2',
        taskName: 'title 2',
        taskPriority: TaskPriority.normal,
      ),
    ];

    setUpAll(() {
      registerFallbackValue(FakeTodo());
    });

    setUp(() {
      api = MockTodosApi();
      when(() => api.getTasks()).thenAnswer((_) => Stream.value(tasks));
      when(() => api.saveTask(any())).thenAnswer((_) async {});
      when(() => api.deleteTask(any())).thenAnswer((_) async {});
    });

    TasksRepository newTasksRepository() => TasksRepository(tasksApi: api);

    group('constructor', () {
      test('works properly', () {
        expect(
          newTasksRepository,
          returnsNormally,
        );
      });
    });

    group('getTasks', () {
      test('makes correct api request', () {
        final tasksRepository = newTasksRepository();

        expect(
          tasksRepository.getTasks(),
          isNot(throwsA(anything)),
        );

        verify(() => api.getTasks()).called(1);
      });

      test('returns stream of current list todos', () {
        expect(
          newTasksRepository().getTasks(),
          emits(tasks),
        );
      });
    });

    group('saveTask', () {
      test('makes correct api request', () {
        final newTask = Task(
          id: '4',
          taskName: 'title 4',
          taskPriority: TaskPriority.high,
        );

        final tasksRepository = newTasksRepository();

        expect(tasksRepository.saveTask(newTask), completes);

        verify(() => api.saveTask(newTask)).called(1);
      });
    });

    group('deleteTask', () {
      test('makes correct api request', () {
        final tasksRepository = newTasksRepository();

        expect(tasksRepository.deleteTask(tasks[0].id), completes);

        verify(() => api.deleteTask(tasks[0].id)).called(1);
      });
    });
  });
}
