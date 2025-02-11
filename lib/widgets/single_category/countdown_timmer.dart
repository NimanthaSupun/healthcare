
import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime dueDate;
  final TimeOfDay time;
  
  const CountdownTimer({
    super.key,
    required this.dueDate,
    required this.time,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late DateTime _targetDateTime;
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Combine date and time into a single DateTime
    _targetDateTime = DateTime(
      widget.dueDate.year,
      widget.dueDate.month,
      widget.dueDate.day,
      widget.time.hour,
      widget.time.minute,
    );
    _calculateRemainingTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _calculateRemainingTime(),
    );
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    setState(() {
      _remainingTime = _targetDateTime.difference(now);
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return "Deadline passed";
    }

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    final parts = <String>[];
    
    if (days > 0) {
      parts.add('$days d');
    }
    if (hours > 0 || days > 0) {
      parts.add('$hours h');
    }
    if (minutes > 0 || hours > 0 || days > 0) {
      parts.add('$minutes min');
    }
    parts.add('$seconds s');

    return parts.join(' ');
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedTime = _formatDuration(_remainingTime);
    return Text(
      formattedTime,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
    );
  }
}
