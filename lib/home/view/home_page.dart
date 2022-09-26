import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:todos_app/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TaskBloc(tasksRepository: context.read<TasksRepository>())
            ..add(TaskSubscriptionRequested()),
      child: Builder(builder: (buildContext) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('To-Do App'),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: buildContext,
                  builder: (_) {
                    return BlocProvider.value(
                      value: buildContext.read<TaskBloc>(),
                      child: const AddTaskDialog(),
                    );
                  });
            },
          ),
          body: const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: 3,
              ),
              child: TaskList(),
            ),
          ),
        );
      }),
    );
  }
}
