import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/charts_repository.dart';
import '../models/chart_model.dart';

final chartsRepositoryProvider = Provider((ref) => ChartsRepository());

final topChartsProvider = FutureProvider<List<ChartModel>>((ref) async {
  return await ref.watch(chartsRepositoryProvider).getTopCharts();
});
