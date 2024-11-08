// lib/view/screens/survey_results_screen.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:mondongo/services/data_service.dart';
import 'package:mondongo/models/encuesta.dart';
import 'package:fl_chart/fl_chart.dart';

@RoutePage()
class SurveyResultsPage extends StatefulWidget {
  final int mesaNumero;

  const SurveyResultsPage({Key? key, required this.mesaNumero})
      : super(key: key);

  @override
  _SurveyResultsScreenState createState() => _SurveyResultsScreenState();
}

class _SurveyResultsScreenState extends State<SurveyResultsPage> {
  final DataService _dataService = DataService();
  late Future<List<Encuesta>> _encuestasFuture;

  @override
  void initState() {
    super.initState();
    _encuestasFuture = _dataService.fetchEncuestasByMesa(widget.mesaNumero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de Encuestas - Mesa ${widget.mesaNumero}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Encuesta>>(
          future: _encuestasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error al cargar las encuestas: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No hay encuestas para esta mesa.'),
              );
            } else {
              final encuestas = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gráfico de Distribución de Satisfacción (Gráfico de Pastel)
                    Text(
                      'Distribución de Satisfacción',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        height: 300,
                        child: SatisfactionPieChart(encuestas: encuestas)),
                    SizedBox(height: 20),

                    // Gráfico de Conteo de Satisfacción (Gráfico de Barras)
                    Text(
                      'Conteo de Satisfacción',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        height: 300,
                        child: SatisfactionBarChart(encuestas: encuestas)),
                    SizedBox(height: 20),

                    // Gráfico de Satisfacción a lo Largo del Tiempo (Gráfico Lineal)
                    Text(
                      'Satisfacción a lo Largo del Tiempo',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                        height: 300,
                        child: SatisfactionLineChart(encuestas: encuestas)),
                    SizedBox(height: 20),

                    // Lista de Comentarios
                    Text(
                      'Comentarios de los Clientes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: encuestas.length,
                      itemBuilder: (context, index) {
                        final encuesta = encuestas[index];
                        return Card(
                          child: ListTile(
                            title:
                                Text('Calificación: ${encuesta.satisfaction}'),
                            subtitle: Text(encuesta.comentarios),
                            trailing: Text(
                              '${encuesta.creadoEn.toLocal()}'.split(' ')[0],
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

/// Gráfico de Pastel para Distribución de Satisfacción
class SatisfactionPieChart extends StatelessWidget {
  final List<Encuesta> encuestas;

  SatisfactionPieChart({required this.encuestas});

  @override
  Widget build(BuildContext context) {
    // Calcular la distribución de satisfacción
    Map<int, int> distribution = {};
    for (var encuesta in encuestas) {
      int rating = encuesta.satisfaction.round();
      distribution[rating] = (distribution[rating] ?? 0) + 1;
    }

    List<PieChartSectionData> sections = distribution.entries.map((entry) {
      double percentage = (entry.value / encuestas.length) * 100;
      return PieChartSectionData(
        color: _getColor(entry.key),
        value: percentage,
        title: '${entry.key}★\n${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Color _getColor(int rating) {
    switch (rating) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

/// Gráfico de Barras para Conteo de Satisfacción
class SatisfactionBarChart extends StatelessWidget {
  final List<Encuesta> encuestas;

  SatisfactionBarChart({required this.encuestas});

  @override
  Widget build(BuildContext context) {
    // Calcular el conteo de cada calificación
    Map<int, int> counts = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var encuesta in encuestas) {
      int rating = encuesta.satisfaction.round();
      counts[rating] = (counts[rating] ?? 0) + 1;
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (counts.values.reduce((a, b) => a > b ? a : b)).toDouble() + 1,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                int intValue = value.toInt();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text('$intValue★'),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: counts.entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: _getColor(entry.key),
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getColor(int rating) {
    switch (rating) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

/// Gráfico Lineal para Satisfacción a lo Largo del Tiempo
class SatisfactionLineChart extends StatelessWidget {
  final List<Encuesta> encuestas;

  SatisfactionLineChart({required this.encuestas});

  @override
  Widget build(BuildContext context) {
    // Ordenar las encuestas por fecha
    encuestas.sort((a, b) => a.creadoEn.compareTo(b.creadoEn));

    List<FlSpot> spots = [];
    for (int i = 0; i < encuestas.length; i++) {
      spots.add(FlSpot(i.toDouble(), encuestas[i].satisfaction));
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (encuestas.length > 0) ? encuestas.length.toDouble() - 1 : 1,
        minY: 0,
        maxY: 5,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
