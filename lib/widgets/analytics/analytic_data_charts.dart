import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/blood_suger_data_model.dart';

class AnalyticDataCharts extends StatelessWidget {
  const AnalyticDataCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
  
  List<FlSpot> _convertEntriesToSpots(List<BloodSugerDataModel> entries) {
    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final bloodSugarEntry = entry.value;
      return FlSpot(index.toDouble(), bloodSugarEntry.sugerLevel);
    }).toList();
  }

  FlTitlesData _buildTitlesData(List<BloodSugerDataModel> entries) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= entries.length) return Container();

            return Text(
              _formatDate(entries[index].date),
              style: const TextStyle(
                fontSize: 12,
                // color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 12,
                // color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}