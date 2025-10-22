import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/all_utils.dart';
import '../../../../core/services/data_service.dart';

@RoutePage()
class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  List<Map<String, dynamic>> _meals = [];
  List<Map<String, dynamic>> _recentMeals = [];
  Map<String, double> _todayNutrition = {
    'calories': 0,
    'protein': 0,
    'carbs': 0,
    'fat': 0,
  };
  bool _isLoading = true;
  String _selectedMealType = 'All';

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      final mealHistory = await DataService.getMealHistory();
      final profile = await DataService.getUserProfile();
      final todayStats = await DataService.getTodayStats(profile.id);

      setState(() {
        _meals = _getPredefinedMeals();
        _recentMeals = mealHistory.take(5).toList();
        _todayNutrition = {
          'calories': todayStats.caloriesConsumed,
          'protein': todayStats.proteinConsumed,
          'carbs': todayStats.carbsConsumed,
          'fat': todayStats.fatConsumed,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      AllUtils.showErrorSnackBar(context, 'Failed to load meals: $e');
    }
  }

  List<Map<String, dynamic>> _getPredefinedMeals() {
    return [
      {
        'id': '1',
        'name': 'Greek Yogurt Parfait',
        'type': 'Breakfast',
        'calories': 320,
        'protein': 20,
        'carbs': 35,
        'fat': 8,
        'prepTime': 5,
        'difficulty': 'Easy',
        'ingredients': [
          '1 cup Greek yogurt',
          '1/2 cup mixed berries',
          '2 tbsp granola',
          '1 tbsp honey',
        ],
        'instructions': [
          'Layer yogurt in a glass',
          'Add berries on top',
          'Sprinkle with granola',
          'Drizzle with honey',
        ],
        'image': 'assets/images/parfait.jpg',
        'color': const Color(0xFF3498DB),
      },
      {
        'id': '2',
        'name': 'Grilled Chicken Salad',
        'type': 'Lunch',
        'calories': 450,
        'protein': 35,
        'carbs': 25,
        'fat': 22,
        'prepTime': 15,
        'difficulty': 'Medium',
        'ingredients': [
          '150g grilled chicken breast',
          '2 cups mixed greens',
          '1/2 avocado',
          '1/4 cup cherry tomatoes',
          '2 tbsp olive oil',
          '1 tbsp balsamic vinegar',
        ],
        'instructions': [
          'Grill chicken breast until cooked',
          'Slice chicken and avocado',
          'Combine all ingredients in a bowl',
          'Drizzle with olive oil and vinegar',
        ],
        'image': 'assets/images/salad.jpg',
        'color': const Color(0xFF2ECC71),
      },
      {
        'id': '3',
        'name': 'Salmon with Quinoa',
        'type': 'Dinner',
        'calories': 520,
        'protein': 40,
        'carbs': 45,
        'fat': 18,
        'prepTime': 25,
        'difficulty': 'Medium',
        'ingredients': [
          '200g salmon fillet',
          '1 cup quinoa',
          '1 cup steamed broccoli',
          '1 tbsp olive oil',
          'Lemon juice',
          'Herbs and spices',
        ],
        'instructions': [
          'Cook quinoa according to package directions',
          'Season salmon with herbs and spices',
          'Pan-sear salmon until golden',
          'Steam broccoli until tender',
          'Serve salmon over quinoa with broccoli',
        ],
        'image': 'assets/images/salmon.jpg',
        'color': const Color(0xFFE74C3C),
      },
      {
        'id': '4',
        'name': 'Protein Smoothie',
        'type': 'Snack',
        'calories': 280,
        'protein': 25,
        'carbs': 30,
        'fat': 6,
        'prepTime': 5,
        'difficulty': 'Easy',
        'ingredients': [
          '1 scoop protein powder',
          '1 banana',
          '1 cup almond milk',
          '1 tbsp peanut butter',
          '1 cup spinach',
          'Ice cubes',
        ],
        'instructions': [
          'Add all ingredients to blender',
          'Blend until smooth',
          'Add ice if needed for consistency',
          'Pour into glass and enjoy',
        ],
        'image': 'assets/images/smoothie.jpg',
        'color': const Color(0xFF9B59B6),
      },
    ];
  }

  List<Map<String, dynamic>> get _filteredMeals {
    if (_selectedMealType == 'All') return _meals;
    return _meals.where((m) => m['type'] == _selectedMealType).toList();
  }

  Future<void> _logMeal(Map<String, dynamic> meal) async {
    try {
      // Add to meal history
      await DataService.addMeal({
        'meal_id': meal['id'],
        'name': meal['name'],
        'type': meal['type'],
        'calories': meal['calories'],
        'protein': meal['protein'],
        'carbs': meal['carbs'],
        'fat': meal['fat'],
        'logged_at': DateTime.now().toIso8601String(),
      });

      // Update today's stats
      final profile = await DataService.getUserProfile();
      final todayStats = await DataService.getTodayStats(profile.id);
      await DataService.updateTodayStats(profile.id, {
        'calories_consumed': todayStats.caloriesConsumed + meal['calories'],
        'protein_consumed': todayStats.proteinConsumed + meal['protein'],
        'carbs_consumed': todayStats.carbsConsumed + meal['carbs'],
        'fat_consumed': todayStats.fatConsumed + meal['fat'],
      });

      AllUtils.showSuccessSnackBar(context, 'Meal logged successfully!');
      _loadMeals(); // Refresh the data
    } catch (e) {
      AllUtils.showErrorSnackBar(context, 'Failed to log meal: $e');
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
          'Meal Plans',
          style: TextStyle(
            fontSize: AllUtils.getResponsiveFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadMeals),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMeals,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AllUtils.getResponsivePadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Nutrition Summary
              _buildNutritionSummary(isMobile),

              SizedBox(height: AllUtils.getResponsivePadding(context)),

              // Filter Chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snack']
                          .map(
                            (type) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(type),
                                selected: _selectedMealType == type,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedMealType = type;
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

              // Recent Meals
              if (_recentMeals.isNotEmpty) ...[
                Text(
                  'Recent Meals',
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
                    itemCount: _recentMeals.length,
                    itemBuilder: (context, index) {
                      final meal = _recentMeals[index];
                      return _buildRecentMealCard(meal, isMobile);
                    },
                  ),
                ),
                SizedBox(height: AllUtils.getResponsivePadding(context)),
              ],

              // Available Meals
              Text(
                'Available Meals',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: AllUtils.getResponsiveFontSize(context, 18),
                ),
              ),

              SizedBox(height: isMobile ? 12 : 16),

              // Meal List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredMeals.length,
                itemBuilder: (context, index) {
                  final meal = _filteredMeals[index];
                  return _buildMealCard(meal, isMobile);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.push(const AiChatRoute()),
        icon: const Icon(Icons.chat),
        label: const Text('AI Meal Plan'),
        backgroundColor: const Color(0xFF6C5CE7),
      ),
    );
  }

  Widget _buildNutritionSummary(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF9B59B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Nutrition',
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
                child: _buildNutritionItem(
                  'Calories',
                  '${AllUtils.formatNumber(_todayNutrition['calories']!, decimals: 0)}',
                  '2000',
                  Icons.local_fire_department,
                  isMobile,
                ),
              ),
              Expanded(
                child: _buildNutritionItem(
                  'Protein',
                  '${AllUtils.formatNumber(_todayNutrition['protein']!, decimals: 0)}g',
                  '150g',
                  Icons.fitness_center,
                  isMobile,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Row(
            children: [
              Expanded(
                child: _buildNutritionItem(
                  'Carbs',
                  '${AllUtils.formatNumber(_todayNutrition['carbs']!, decimals: 0)}g',
                  '250g',
                  Icons.grain,
                  isMobile,
                ),
              ),
              Expanded(
                child: _buildNutritionItem(
                  'Fat',
                  '${AllUtils.formatNumber(_todayNutrition['fat']!, decimals: 0)}g',
                  '67g',
                  Icons.opacity,
                  isMobile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(
    String label,
    String current,
    String target,
    IconData icon,
    bool isMobile,
  ) {
    final currentValue =
        double.tryParse(current.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    final targetValue =
        double.tryParse(target.replaceAll(RegExp(r'[^\d.]'), '')) ?? 1;
    final progress = (currentValue / targetValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: isMobile ? 16 : 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: isMobile ? 12 : 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$current / $target',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white.withValues(alpha: 0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }

  Widget _buildRecentMealCard(Map<String, dynamic> meal, bool isMobile) {
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
                Icons.restaurant,
                color: Colors.green,
                size: isMobile ? 16 : 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  meal['name'] ?? 'Meal',
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
            AllUtils.formatTime(DateTime.parse(meal['logged_at'])),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isMobile ? 10 : 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${meal['calories']} cal • ${meal['type']}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isMobile ? 10 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal, bool isMobile) {
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
          onTap: () => _showMealDetails(meal),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Row(
              children: [
                // Meal Icon
                Container(
                  width: isMobile ? 50 : 60,
                  height: isMobile ? 50 : 60,
                  decoration: BoxDecoration(
                    color: (meal['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: meal['color'] as Color,
                    size: isMobile ? 24 : 30,
                  ),
                ),

                SizedBox(width: isMobile ? 12 : 16),

                // Meal Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal['name'],
                        style: TextStyle(
                          fontSize: AllUtils.getResponsiveFontSize(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${meal['calories']} cal • ${meal['prepTime']} min prep',
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            meal['type'],
                            Icons.schedule,
                            isMobile,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            '${meal['protein']}g protein',
                            Icons.fitness_center,
                            isMobile,
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            meal['difficulty'],
                            Icons.star,
                            isMobile,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Log Button
                IconButton(
                  onPressed: () => _logMeal(meal),
                  icon: const Icon(Icons.add),
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

  void _showMealDetails(Map<String, dynamic> meal) {
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
                                      color: (meal['color'] as Color)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.restaurant,
                                      color: meal['color'] as Color,
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
                                          meal['name'],
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${meal['calories']} calories • ${meal['prepTime']} min prep',
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

                              // Nutrition Info
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildNutritionDetail(
                                      'Protein',
                                      '${meal['protein']}g',
                                      Icons.fitness_center,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildNutritionDetail(
                                      'Carbs',
                                      '${meal['carbs']}g',
                                      Icons.grain,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildNutritionDetail(
                                      'Fat',
                                      '${meal['fat']}g',
                                      Icons.opacity,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Ingredients
                              const Text(
                                'Ingredients',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              ...(meal['ingredients'] as List)
                                  .map(
                                    (ingredient) => Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Color(0xFF6C5CE7),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              ingredient,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),

                              const SizedBox(height: 24),

                              // Instructions
                              const Text(
                                'Instructions',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              ...(meal['instructions'] as List)
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF6C5CE7),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${entry.key + 1}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              entry.value,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),

                              const SizedBox(height: 24),

                              // Log Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _logMeal(meal);
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
                                    'Log This Meal',
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

  Widget _buildNutritionDetail(String label, String value, IconData icon) {
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
