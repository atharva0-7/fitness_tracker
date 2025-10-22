import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/all_utils.dart';
import '../../../../core/services/data_service.dart';

@RoutePage()
class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  List<Map<String, dynamic>> _workouts = [];
  List<Map<String, dynamic>> _recentWorkouts = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    try {
      final workoutHistory = await DataService.getWorkoutHistory();
      setState(() {
        _workouts = _getPredefinedWorkouts();
        _recentWorkouts = workoutHistory.take(5).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AllUtils.showErrorSnackBar(context, 'Failed to load workouts: $e');
    }
  }

  List<Map<String, dynamic>> _getPredefinedWorkouts() {
    return [
      {
        'id': '1',
        'name': 'Morning Cardio Blast',
        'duration': 30,
        'difficulty': 'Beginner',
        'calories': 250,
        'type': 'Cardio',
        'equipment': ['None'],
        'description': 'High-energy cardio workout to start your day',
        'exercises': [
          {'name': 'Jumping Jacks', 'duration': 60, 'reps': 30},
          {'name': 'High Knees', 'duration': 60, 'reps': 30},
          {'name': 'Burpees', 'duration': 60, 'reps': 10},
          {'name': 'Mountain Climbers', 'duration': 60, 'reps': 20},
        ],
        'image': 'assets/images/cardio.jpg',
        'color': const Color(0xFFE74C3C),
      },
      {
        'id': '2',
        'name': 'Strength Training',
        'duration': 45,
        'difficulty': 'Intermediate',
        'calories': 400,
        'type': 'Strength',
        'equipment': ['Dumbbells', 'Bench'],
        'description': 'Build muscle and strength with compound movements',
        'exercises': [
          {'name': 'Squats', 'duration': 0, 'reps': 15, 'sets': 3},
          {'name': 'Push-ups', 'duration': 0, 'reps': 12, 'sets': 3},
          {'name': 'Dumbbell Rows', 'duration': 0, 'reps': 10, 'sets': 3},
          {'name': 'Plank', 'duration': 60, 'reps': 1, 'sets': 3},
        ],
        'image': 'assets/images/strength.jpg',
        'color': const Color(0xFF3498DB),
      },
      {
        'id': '3',
        'name': 'Yoga Flow',
        'duration': 60,
        'difficulty': 'All Levels',
        'calories': 200,
        'type': 'Flexibility',
        'equipment': ['Yoga Mat'],
        'description': 'Relaxing yoga session for flexibility and mindfulness',
        'exercises': [
          {'name': 'Sun Salutation', 'duration': 300, 'reps': 3},
          {'name': 'Warrior Poses', 'duration': 180, 'reps': 2},
          {'name': 'Tree Pose', 'duration': 60, 'reps': 2},
          {'name': 'Savasana', 'duration': 300, 'reps': 1},
        ],
        'image': 'assets/images/yoga.jpg',
        'color': const Color(0xFF2ECC71),
      },
      {
        'id': '4',
        'name': 'HIIT Workout',
        'duration': 25,
        'difficulty': 'Advanced',
        'calories': 350,
        'type': 'HIIT',
        'equipment': ['None'],
        'description': 'High-intensity interval training for maximum results',
        'exercises': [
          {'name': 'Sprint in Place', 'duration': 30, 'reps': 1},
          {'name': 'Rest', 'duration': 30, 'reps': 1},
          {'name': 'Burpees', 'duration': 30, 'reps': 1},
          {'name': 'Rest', 'duration': 30, 'reps': 1},
        ],
        'image': 'assets/images/hiit.jpg',
        'color': const Color(0xFF9B59B6),
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredWorkouts {
    if (_selectedFilter == 'All') return _workouts;
    return _workouts.where((w) => w['type'] == _selectedFilter).toList();
  }

  Future<void> _startWorkout(Map<String, dynamic> workout) async {
    try {
      // Add to workout history
      await DataService.addWorkout({
        'workout_id': workout['id'],
        'name': workout['name'],
        'duration': workout['duration'],
        'calories_burned': workout['calories'],
        'exercises': workout['exercises'],
        'completed_at': DateTime.now().toIso8601String(),
      });

      // Update today's stats
      final profile = await DataService.getUserProfile();
      final todayStats = await DataService.getTodayStats(profile.id);
      await DataService.updateTodayStats(profile.id, {
        'workout_minutes': todayStats.workoutMinutes + workout['duration'],
        'calories_burned': todayStats.caloriesBurned + workout['calories'],
      });

      AllUtils.showSuccessSnackBar(context, 'Workout completed! Great job!');
      _loadWorkouts(); // Refresh the list
    } catch (e) {
      AllUtils.showErrorSnackBar(context, 'Failed to save workout: $e');
    }
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
          'Workouts',
          style: TextStyle(
            fontSize: AllUtils.getResponsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadWorkouts),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadWorkouts,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AllUtils.getResponsivePadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      ['All', 'Cardio', 'Strength', 'HIIT', 'Flexibility']
                          .map(
                            (filter) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(filter),
                                selected: _selectedFilter == filter,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                selectedColor: const Color(
                                  0xFF6C5CE7,
                                ).withValues(alpha: 0.2),
                                checkmarkColor: const Color(0xFF6C5CE7),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),

              SizedBox(height: AllUtils.getResponsivePadding(context)),

              // Recent Workouts
              if (_recentWorkouts.isNotEmpty) ...[
                Text(
                  'Recent Workouts',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: AllUtils.getResponsiveFontSize(context, 18),
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 16),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recentWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = _recentWorkouts[index];
                      return _buildRecentWorkoutCard(workout, isMobile);
                    },
                  ),
                ),
                SizedBox(height: AllUtils.getResponsivePadding(context)),
              ],

              // Available Workouts
              Text(
                'Available Workouts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: AllUtils.getResponsiveFontSize(context, 18),
                ),
              ),

              SizedBox(height: isMobile ? 12 : 16),

              // Workout List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = _filteredWorkouts[index];
                  return _buildWorkoutCard(workout, isMobile);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.push(const AiChatRoute()),
        icon: const Icon(Icons.chat),
        label: const Text('AI Workout'),
        backgroundColor: const Color(0xFF6C5CE7),
      ),
    );
  }

  Widget _buildRecentWorkoutCard(Map<String, dynamic> workout, bool isMobile) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
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
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: isMobile ? 16 : 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  workout['name'] ?? 'Workout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 12 : 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AllUtils.formatTime(DateTime.parse(workout['completed_at'])),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isMobile ? 10 : 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${workout['duration']} min • ${workout['calories_burned']} cal',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isMobile ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> workout, bool isMobile) {
    return Container(
      margin: EdgeInsets.only(bottom: isMobile ? 12 : 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showWorkoutDetails(workout),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Row(
              children: [
                // Workout Icon
                Container(
                  width: isMobile ? 50 : 60,
                  height: isMobile ? 50 : 60,
                  decoration: BoxDecoration(
                    color: (workout['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.fitness_center,
                    color: workout['color'] as Color,
                    size: isMobile ? 24 : 30,
                  ),
                ),

                SizedBox(width: isMobile ? 12 : 16),

                // Workout Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout['name'],
                        style: TextStyle(
                          fontSize: AllUtils.getResponsiveFontSize(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        workout['description'],
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            '${workout['duration']} min',
                            Icons.schedule,
                            isMobile,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            '${workout['calories']} cal',
                            Icons.local_fire_department,
                            isMobile,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            workout['difficulty'],
                            Icons.speed,
                            isMobile,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Start Button
                IconButton(
                  onPressed: () => _startWorkout(workout),
                  icon: const Icon(Icons.play_arrow),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 8,
        vertical: isMobile ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isMobile ? 12 : 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showWorkoutDetails(Map<String, dynamic> workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder:
                (context, scrollController) => Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Content
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: (workout['color'] as Color)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.fitness_center,
                                      color: workout['color'] as Color,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workout['name'],
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          workout['description'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Stats
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatItem(
                                      'Duration',
                                      '${workout['duration']} min',
                                      Icons.schedule,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatItem(
                                      'Calories',
                                      '${workout['calories']} cal',
                                      Icons.local_fire_department,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatItem(
                                      'Difficulty',
                                      workout['difficulty'],
                                      Icons.speed,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Exercises
                              const Text(
                                'Exercises',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              ...(workout['exercises'] as List)
                                  .map(
                                    (exercise) => Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF6C5CE7,
                                              ).withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.play_arrow,
                                              color: Color(0xFF6C5CE7),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  exercise['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                if (exercise['duration'] > 0)
                                                  Text(
                                                    '${exercise['duration']} seconds',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                else
                                                  Text(
                                                    '${exercise['reps']} reps × ${exercise['sets']} sets',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),

                              const SizedBox(height: 24),

                              // Start Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _startWorkout(workout);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6C5CE7),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Start Workout',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6C5CE7), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
