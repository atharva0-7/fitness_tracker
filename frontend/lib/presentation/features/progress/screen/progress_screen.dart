import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/utils/all_utils.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/models/daily_stats.dart';

@RoutePage()
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  UserProfile? _userProfile;
  List<DailyStats> _weeklyStats = [];
  Map<String, dynamic>? _progressSummary;
  bool _isLoading = true;
  String _selectedTimeframe = 'Week';

  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }

  Future<void> _loadProgressData() async {
    try {
      final profile = await DataService.getUserProfile();
      final weeklyStats = await DataService.getWeeklyStats(profile.id);
      final progressSummary = await DataService.getProgressSummary(profile.id);

      setState(() {
        _userProfile = profile;
        _weeklyStats = weeklyStats;
        _progressSummary = progressSummary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AllUtils.showErrorSnackBar(context, 'Failed to load progress data: $e');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadProgressData();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = AllUtils.isMobile(context);

    if (_isLoading) {
      return Scaffold(
        body: Center(child: AllUtils.buildLoadingIndicator(size: 50)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progress',
          style: TextStyle(
            fontSize: AllUtils.getResponsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AllUtils.getResponsivePadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeframe Selector
              Row(
                children:
                    ['Week', 'Month', 'Year']
                        .map(
                          (timeframe) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: FilterChip(
                                label: Text(timeframe),
                                selected: _selectedTimeframe == timeframe,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedTimeframe = timeframe;
                                  });
                                },
                                selectedColor: const Color(
                                  0xFF6C5CE7,
                                ).withValues(alpha: 0.2),
                                checkmarkColor: const Color(0xFF6C5CE7),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),

              SizedBox(height: AllUtils.getResponsivePadding(context)),

              // BMI and Weight Card
              _buildBMICard(isMobile),

              SizedBox(height: AllUtils.getResponsivePadding(context)),

              // Weekly Progress Charts
              _buildProgressCharts(isMobile),

              SizedBox(height: AllUtils.getResponsivePadding(context)),

              // Goals Achievement
              _buildGoalsAchievement(isMobile),

              SizedBox(height: AllUtils.getResponsivePadding(context)),

              // Weekly Summary
              _buildWeeklySummary(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBMICard(bool isMobile) {
    final bmi = _userProfile!.bmi;
    final bmiCategory = _userProfile!.bmiCategory;
    final bmiColor = AllUtils.getBMIColor(bmi);

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bmiColor, bmiColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your BMI',
            style: TextStyle(
              color: Colors.white,
              fontSize: AllUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AllUtils.formatNumber(bmi, decimals: 1),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 32 : 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      bmiCategory,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: isMobile ? 14 : 16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: isMobile ? 80 : 100,
                height: isMobile ? 80 : 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${_userProfile!.weight.toInt()}kg',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCharts(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Progress',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: AllUtils.getResponsiveFontSize(context, 18),
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),

        // Calories Chart
        _buildChartCard('Calories Consumed', _buildCaloriesChart(), isMobile),

        SizedBox(height: isMobile ? 12 : 16),

        // Steps Chart
        _buildChartCard('Daily Steps', _buildStepsChart(), isMobile),
      ],
    );
  }

  Widget _buildChartCard(String title, Widget chart, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AllUtils.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          SizedBox(height: isMobile ? 200 : 250, child: chart),
        ],
      ),
    );
  }

  Widget _buildCaloriesChart() {
    final spots =
        _weeklyStats.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.caloriesConsumed);
        }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() < days.length) {
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(fontSize: 12),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF6C5CE7),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsChart() {
    final spots =
        _weeklyStats.asMap().entries.map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.steps.toDouble());
        }).toList();

    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${(value / 1000).toInt()}k',
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() < days.length) {
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(fontSize: 12),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups:
            spots
                .map(
                  (spot) => BarChartGroupData(
                    x: spot.x.toInt(),
                    barRods: [
                      BarChartRodData(
                        toY: spot.y,
                        color: const Color(0xFF00CEC9),
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildGoalsAchievement(bool isMobile) {
    final goalsMet = _progressSummary!['goals_met'] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goals Achievement',
            style: TextStyle(
              fontSize: AllUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),

          Row(
            children: [
              Expanded(
                child: _buildGoalItem(
                  'Calories',
                  goalsMet['calories'],
                  7,
                  Icons.local_fire_department,
                  const Color(0xFFE74C3C),
                  isMobile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGoalItem(
                  'Steps',
                  goalsMet['steps'],
                  7,
                  Icons.directions_walk,
                  const Color(0xFF00CEC9),
                  isMobile,
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 12 : 16),

          Row(
            children: [
              Expanded(
                child: _buildGoalItem(
                  'Workouts',
                  goalsMet['workouts'],
                  7,
                  Icons.fitness_center,
                  const Color(0xFF6C5CE7),
                  isMobile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGoalItem(
                  'Overall',
                  ((goalsMet['calories'] +
                              goalsMet['steps'] +
                              goalsMet['workouts']) /
                          21 *
                          100)
                      .round(),
                  100,
                  Icons.trending_up,
                  const Color(0xFF2ECC71),
                  isMobile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(
    String title,
    int achieved,
    int total,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    final percentage = (achieved / total * 100).round();

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isMobile ? 24 : 30),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            '$achieved/$total',
            style: TextStyle(
              fontSize: isMobile ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          SizedBox(height: isMobile ? 4 : 8),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary(bool isMobile) {
    final weeklyAverages =
        _progressSummary!['weekly_averages'] as Map<String, dynamic>;
    final trends = _progressSummary!['trends'] as Map<String, dynamic>;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Summary',
            style: TextStyle(
              fontSize: AllUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),

          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Avg Calories',
                  AllUtils.formatNumber(
                    weeklyAverages['calories'],
                    decimals: 0,
                  ),
                  trends['calories'] > 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  trends['calories'] > 0 ? Colors.green : Colors.red,
                  isMobile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryItem(
                  'Avg Steps',
                  AllUtils.formatNumber(weeklyAverages['steps'], decimals: 0),
                  trends['weight'] > 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  trends['weight'] > 0 ? Colors.green : Colors.red,
                  isMobile,
                ),
              ),
            ],
          ),

          SizedBox(height: isMobile ? 12 : 16),

          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Avg Weight',
                  '${AllUtils.formatNumber(weeklyAverages['weight'], decimals: 1)} kg',
                  trends['weight'] > 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  trends['weight'] > 0 ? Colors.red : Colors.green,
                  isMobile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryItem(
                  'Workouts',
                  '${_progressSummary!['counts']['workouts_this_week']}',
                  Icons.fitness_center,
                  const Color(0xFF6C5CE7),
                  isMobile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isMobile ? 20 : 24),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
