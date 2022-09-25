import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

/// A single task item.
///
/// Contains a [taskName], [taskPriority] and an [isCompleted]
/// flag.
///
/// If an [id] is provided, it must not be empty. If no [id] is
/// passed, it will be generated.
///
@immutable
@JsonSerializable()
class Task extends Equatable {
  final String id;
  final String taskName;
  final String taskPriority;
  final bool isCompleted;

  Task({
    String? id,
    required this.taskName,
    required this.taskPriority,
    this.isCompleted = false,
  })  : assert(
          id == null || id.isNotEmpty,
          'id must not be empty',
        ),
        assert(
            taskPriority == TaskPriority.low ||
                taskPriority == TaskPriority.normal ||
                taskPriority == TaskPriority.high,
            'task priority values can only be one of the following: {low, normal, high}'),
        id = id ?? const Uuid().v1(); // Time based id

  Task copyWith({
    String? id,
    String? taskName,
    String? taskPriority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      taskPriority: taskPriority ?? this.taskPriority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Converts the given [Map<String, dynamic>] into a [Task].
  static Task fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// Converts this [Task] into a [Map<String, dynamic>].
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  List<Object> get props => [id, taskName, taskPriority, isCompleted];
}
