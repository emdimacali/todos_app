import 'package:flutter/material.dart';

class HighPriorityChip extends StatelessWidget {
  const HighPriorityChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Chip(
      label: Text('HIGH'),
      backgroundColor: Colors.red,
    );
  }
}

class NormalPriorityChip extends StatelessWidget {
  const NormalPriorityChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Chip(
      label: Text('NORMAL'),
      backgroundColor: Colors.blue,
    );
  }
}

class LowPriorityChip extends StatelessWidget {
  const LowPriorityChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Chip(
      label: Text('LOW'),
      backgroundColor: Colors.grey,
    );
  }
}
