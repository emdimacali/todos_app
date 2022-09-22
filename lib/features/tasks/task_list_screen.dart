import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          print('ADD TASK');
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 3,
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              if (index == 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Chip(label: Text('PENDING: 2 | COMPLETED: 2 | TOTAL: 4')),
                  ],
                );
              }
              return Card(
                elevation: 2,
                child: CheckboxListTile(
                  value: false,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Some task #$index'),
                      const Chip(
                        label: Text('HIGH'),
                      )
                    ],
                  ),
                  secondary: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      print('MORE BUTTON WAS PRESSED');
                    },
                  ),
                  onChanged: (isTicked) {
                    print('CHECKBOX WAS CHANGED');
                  },
                ),
              );
            },
            itemCount: 5,
          ),
        ),
      ),
    );
  }
}
