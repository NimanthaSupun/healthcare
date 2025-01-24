// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class BloodSugarLineChart extends StatelessWidget {
//   final List<BloodSugarEntry> entries;

//   const BloodSugarLineChart({Key? key, required this.entries}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       LineChartData(
//         lineBarsData: [
//           LineChartBarData(
//             spots: _convertEntriesToSpots(),
//             isCurved: true,
//             color: Colors.blue,
//             barWidth: 3,
//             belowBarData: BarAreaData(
//               show: true,
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.blue.withOpacity(0.5),
//                   Colors.transparent
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//         ],
//         titlesData: _buildTitlesData(),
//         gridData: FlGridData(show: false),
//         borderData: FlBorderData(show: false),
//       ),
//     );
//   }

//   List<FlSpot> _convertEntriesToSpots() {
//     return entries.asMap().entries.map((entry) {
//       final index = entry.key;
//       final bloodSugarEntry = entry.value;
//       return FlSpot(index.toDouble(), bloodSugarEntry.sugarLevel);
//     }).toList();
//   }

//   FlTitlesData _buildTitlesData() {
//     return FlTitlesData(
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           getTitlesWidget: (value, meta) {
//             final index = value.toInt();
//             if (index < 0 || index >= entries.length) return Container();
            
//             return Text(
//               _formatDate(entries[index].timestamp),
//               style: const TextStyle(fontSize: 10, color: Colors.grey),
//             );
//           },
//         ),
//       ),
//       leftTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           interval: 20,
//           getTitlesWidget: (value, meta) {
//             return Text(
//               value.toStringAsFixed(0),
//               style: const TextStyle(fontSize: 10, color: Colors.grey),
//             );
//           },
//         ),
//       ),
//       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}';
//   }
// }