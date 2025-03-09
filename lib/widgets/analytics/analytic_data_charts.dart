import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/models/blood_suger_data_model.dart';

class AnalyticDataCharts extends StatelessWidget {
  final List<BloodSugerDataModel> entries;
  const AnalyticDataCharts({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
            ),
            lineBarsData: [
              LineChartBarData(
                spots: _convertEntriesToSpots(
                  entries,
                ),
                isCurved: true,
                color: selectionColor,
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      selectionColor.withOpacity(0.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
            titlesData: _buildTitlesData(entries),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
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
