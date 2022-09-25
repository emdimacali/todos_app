import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_api/tasks_api.dart';

void main() {
  group('Task', () {
    Task newTask({
      String? id = 'randomId',
      String taskName = 'taskName',
      TaskPriority taskPriority = TaskPriority.normal,
      bool isCompleted = true,
    }) {
      return Task(
        id: id,
        taskName: taskName,
        taskPriority: taskPriority,
        isCompleted: isCompleted,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(newTask, returnsNormally);
      });

      test('throws AssertionError when the id is empty', () {
        expect(() => newTask(id: ''), throwsA(isA<AssertionError>()));
      });

      test('sets the id if not provided', () {
        expect(newTask(id: null).id, isNotEmpty);
      });

      test('supports value equality', () {
        expect(newTask(), equals(newTask()));
      });

      test('props are correct', () {
        expect(
            newTask().props,
            equals([
              'randomId',
              'taskName',
              TaskPriority.normal,
              true,
            ]));
      });
    });

    group('copyWith', () {
      test('returns the same obejct if arguments are not provided', () {
        //no argument provided in copyWith so nothing should have changed.
        expect(newTask().copyWith(), equals(newTask()));
      });

      test('retains the old value for every parameter if null is provided', () {
        //null values provided are similar to not passing anything as an argument.
        expect(
            newTask().copyWith(
                id: null,
                taskName: null,
                taskPriority: null,
                isCompleted: null),
            equals(newTask()));
      });

      test('replaces every non-null parameter', () {
        expect(
            newTask().copyWith(
                id: '2lKioO',
                taskName: 'amazing task',
                taskPriority: TaskPriority.high,
                isCompleted: false),
            equals(newTask(
                id: '2lKioO',
                taskName: 'amazing task',
                taskPriority: TaskPriority.high,
                isCompleted: false)));
      });
    });
  });
}
