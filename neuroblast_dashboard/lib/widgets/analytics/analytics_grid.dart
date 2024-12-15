import 'package:flutter/material.dart';
import 'package:neuroblast_dashboard/widgets/analytics/charts/decease_diversity_chart.dart';
import 'package:neuroblast_dashboard/widgets/analytics/charts/gender_ratio_chart.dart';
import 'package:neuroblast_dashboard/widgets/analytics/charts/patients_by_date_chart.dart';

class ChartsGrid extends StatelessWidget {
  const ChartsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _buildChartContainer(
          title: 'Ratio Between Diseases',
          chart: const DeceaseDiversityChart(),
        ),
        _buildChartContainer(
          title: 'Male to Female Patients',
          chart: const GenderRatioChart(),
        ),
        _buildChartContainer(
          title: 'Patients by Date',
          chart: const PatientsByDateChart(),
        ),
      ],
    );
  }

  Widget _buildChartContainer({required String title, required Widget chart}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: chart),
        ],
      ),
    );
  }
}
