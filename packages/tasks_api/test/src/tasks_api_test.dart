import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_api/tasks_api.dart';

class TestTasksApi extends TasksApi {
  TestTasksApi() : super();

  // Added to omit implementations for members of its interface
  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('TasksApi', () {
    test('can be constructed', () {
      expect(TestTasksApi.new, returnsNormally);
    });
  });
}
