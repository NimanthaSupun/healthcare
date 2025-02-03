import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Clinic {
  final String id;
  final String reason;
  final String note;
  final DateTime dueDate;
  final TimeOfDay dueTime;

  Clinic({
    required this.id,
    required this.reason,
    required this.note,
    required this.dueDate,
    required this.dueTime,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] ?? '',
      reason: json['reason'] ?? '',
      note: json['note'] ?? '',
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      dueTime: TimeOfDay.fromDateTime((json['dueTime'] as Timestamp).toDate()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'reason':reason,
      'note':note,
      'dueDate': Timestamp.fromDate(dueDate),
      'dueTime': Timestamp.fromDate(DateTime(
        dueDate.year,
        dueDate.month,
        dueDate.day,
        dueTime.hour,
        dueTime.minute,
      )),
    };
  }
}
