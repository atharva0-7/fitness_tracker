import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/all_utils.dart';
import '../../../../core/services/data_service.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/models/daily_stats.dart';
import '../../workout/screen/workout_list_screen.dart';
import '../../meal/screen/meal_plan_screen.dart';
import '../../progress/screen/progress_screen.dart';
import '../../profile/screen/profile_screen.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  UserProfile? _userProfile;
  DailyStats? _todayStats;
  Map<String, dynamic>? _progressSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final profile = await DataService.getUserProfile();
      final todayStats = await DataService.getTodayStats(profile.id);
      final progressSummary = await DataService.getProgressSummary(profile.id);

      setState(() {
        _userProfile = profile;
        _todayStats = todayStats;
        _progressSummary = progressSummary;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AllUtils.showErrorSnackBar(context, 'Failed to load data: $e');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardTab(
            userProfile: _userProfile!,
            todayStats: _todayStats!,
            progressSummary: _progressSummary!,
            onRefresh: _refreshData,
          ),
          const WorkoutListScreen(),
          const MealPlanScreen(),
          const ProgressScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF6C5CE7),
          unselectedItemColor: Colors.grey[600],
          selectedFontSize: isMobile ? 12 : 14,
          unselectedFontSize: isMobile ? 10 : 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              activeIcon: Icon(Icons.fitness_center),
              label: 'Workouts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              activeIcon: Icon(Icons.restaurant),
              label: 'Meals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              activeIcon: Icon(Icons.trending_up),
              label: 'Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  final UserProfile userProfile;
  final DailyStats todayStats;
  final Map<String, dynamic> progressSummary;
  final VoidCallback onRefresh;

  const DashboardTab({
    super.key,
    required this.userProfile,
    required this.todayStats,
    required this.progressSummary,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AllUtils.isMobile(context);
    final greeting = AllUtils.getGreeting();

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AllUtils.getResponsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greeting, ${userProfile.name}!',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: AllUtils.getResponsiveFontSize(context, 16),
                        ),
                      ),
                      Text(
                        'Ready to crush your goals?',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: AllUtils.getResponsiveFontSize(context, 20),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => context.router.push(const ProfileRoute()),
                  child: Container(
                    width: isMobile ? 45 : 50,
                    height: isMobile ? 45 : 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7),
                      borderRadius: BorderRadius.circular(isMobile ? 22.5 : 25),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AllUtils.getResponsivePadding(context)),

            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Calories',
                    AllUtils.formatNumber(
                      todayStats.caloriesConsumed,
                      decimals: 0,
                    ),
                    'of ${AllUtils.formatNumber(todayStats.caloriesGoal, decimals: 0)}',
                    const Color(0xFF6C5CE7),
                    Icons.local_fire_department,
                    isMobile,
                    progress:
                        todayStats.caloriesConsumed / todayStats.caloriesGoal,
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 16),
                Expanded(
                  child: _buildStatCard(
                    'Steps',
                    AllUtils.formatNumber(
                      todayStats.steps.toDouble(),
                      decimals: 0,
                    ),
                    'of ${AllUtils.formatNumber(todayStats.stepsGoal.toDouble(), decimals: 0)}',
                    const Color(0xFF00CEC9),
                    Icons.directions_walk,
                    isMobile,
                    progress: todayStats.stepsProgress,
                  ),
                ),
              ],
            ),

            SizedBox(height: isMobile ? 12 : 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Weight',
                    AllUtils.formatNumber(userProfile.weight, decimals: 1),
                    'kg',
                    const Color(0xFFFF7675),
                    Icons.monitor_weight,
                    isMobile,
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 16),
                Expanded(
                  child: _buildStatCard(
                    'BMI',
                    AllUtils.formatNumber(userProfile.bmi, decimals: 1),
                    userProfile.bmiCategory,
                    AllUtils.getBMIColor(userProfile.bmi),
                    Icons.analytics,
                    isMobile,
                  ),
                ),
              ],
            ),

            SizedBox(height: AllUtils.getResponsivePadding(context)),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: AllUtils.getResponsiveFontSize(context, 18),
              ),
            ),

            SizedBox(height: isMobile ? 12 : 16),

            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    'Start Workout',
                    Icons.play_arrow,
                    const Color(0xFF6C5CE7),
                    () => context.router.push(const WorkoutListRoute()),
                    isMobile,
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 16),
                Expanded(
                  child: _buildQuickActionCard(
                    'Log Meal',
                    Icons.restaurant,
                    const Color(0xFF00CEC9),
                    () => context.router.push(const MealPlanRoute()),
                    isMobile,
                  ),
                ),
              ],
            ),

            SizedBox(height: isMobile ? 12 : 16),

            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    'AI Chat',
                    Icons.chat,
                    const Color(0xFF9B59B6),
                    () => context.router.push(const AiChatRoute()),
                    isMobile,
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 16),
                Expanded(
                  child: _buildQuickActionCard(
                    'View Progress',
                    Icons.trending_up,
                    const Color(0xFFE67E22),
                    () => context.router.push(const ProgressRoute()),
                    isMobile,
                  ),
                ),
              ],
            ),

            SizedBox(height: AllUtils.getResponsivePadding(context)),

            // Today's Summary
            Text(
              'Today\'s Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: AllUtils.getResponsiveFontSize(context, 18),
              ),
            ),

            SizedBox(height: isMobile ? 12 : 16),

            _buildSummaryCard(
              'Water Intake',
              '${AllUtils.formatNumber(todayStats.waterIntake, decimals: 1)}L',
              'of 2.5L',
              todayStats.waterProgress,
              Icons.water_drop,
              const Color(0xFF3498DB),
              isMobile,
            ),

            SizedBox(height: isMobile ? 8 : 12),

            _buildSummaryCard(
              'Workout Time',
              '${todayStats.workoutMinutes} min',
              'of 30 min',
              todayStats.workoutProgress,
              Icons.fitness_center,
              const Color(0xFFE74C3C),
              isMobile,
            ),

            SizedBox(height: isMobile ? 8 : 12),

            _buildSummaryCard(
              'Sleep',
              '${todayStats.sleepHours}h',
              'of 8h',
              todayStats.sleepProgress,
              Icons.bedtime,
              const Color(0xFF8E44AD),
              isMobile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
    IconData icon,
    bool isMobile, {
    double? progress,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: isMobile ? 20 : 24),
              if (progress != null)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 12 : 14,
                  ),
                ),
            ],
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 18 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.grey[600],
            ),
          ),
          if (progress != null) ...[
            SizedBox(height: isMobile ? 8 : 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: isMobile ? 24 : 32),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 12 : 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String subtitle,
    double progress,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: isMobile ? 20 : 24),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '$value $subtitle',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: isMobile ? 4 : 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
