// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class IaTrainingCreateProps {
  final String? name;
  final String? goal;
  final List<String>? groups;
  final String? time;
  final String? weight;
  final String? height;
  final String? physicalCondition;

  IaTrainingCreateProps({
    this.name,
    this.goal,
    this.groups,
    this.time,
    this.weight,
    this.height,
    this.physicalCondition,
  });

  IaTrainingCreateProps copyWith({
    String? name,
    String? goal,
    List<String>? groups,
    String? time,
    String? weight,
    String? height,
    String? physicalCondition,
  }) {
    return IaTrainingCreateProps(
      name: name ?? this.name,
      goal: goal ?? this.goal,
      groups: groups ?? this.groups,
      time: time ?? this.time,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      physicalCondition: physicalCondition ?? this.physicalCondition,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'goal': goal,
      'groups': groups,
      'time': time,
      'weight': weight,
      'height': height,
      'physicalCondition': physicalCondition,
    };
  }

  factory IaTrainingCreateProps.fromMap(Map<String, dynamic> map) {
    return IaTrainingCreateProps(
      name: map['name'] != null ? map['name'] as String : null,
      goal: map['goal'] != null ? map['goal'] as String : null,
      groups: List<String>.from((map['groups'] as List<String>)),
      time: map['time'] != null ? map['time'] as String : null,
      weight: map['weight'] != null ? map['weight'] as String : null,
      height: map['height'] != null ? map['height'] as String : null,
      physicalCondition: map['physicalCondition'] != null ? map['physicalCondition'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IaTrainingCreateProps.fromJson(String source) => IaTrainingCreateProps.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'IaTrainingCreateProps(name: $name, goal: $goal, groups: $groups, time: $time, weight: $weight, height: $height, physicalCondition: $physicalCondition)';
  }

  @override
  bool operator ==(covariant IaTrainingCreateProps other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.goal == goal &&
      listEquals(other.groups, groups) &&
      other.time == time &&
      other.weight == weight &&
      other.height == height &&
      other.physicalCondition == physicalCondition;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      goal.hashCode ^
      groups.hashCode ^
      time.hashCode ^
      weight.hashCode ^
      height.hashCode ^
      physicalCondition.hashCode;
  }
}
