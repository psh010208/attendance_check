
import 'package:flutter/material.dart';

class QrModel {
  final String qr_code;
  final bool check;
  final String student_id;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  QrModel({
    required this.qr_code,
    required this.check,
    required this.student_id,
    required TimeOfDay? startTime,
    required TimeOfDay? endTime,
  });
}