import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../presentation/features/auth/screen/splash_screen.dart';
import '../../presentation/features/home/screen/home_screen.dart';
import '../../presentation/features/auth/screen/login_screen.dart';
import '../../presentation/features/auth/screen/register_screen.dart';
import '../../presentation/features/workout/screen/workout_list_screen.dart';
import '../../presentation/features/workout/screen/workout_detail_screen.dart';
import '../../presentation/features/meal/screen/meal_plan_screen.dart';
import '../../presentation/features/meal/screen/meal_detail_screen.dart';
import '../../presentation/features/progress/screen/progress_screen.dart';
import '../../presentation/features/profile/screen/profile_screen.dart';
import '../../presentation/features/ai_chat/screen/ai_chat_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // Splash and Auth Routes
    AutoRoute(page: SplashRoute.page, path: '/splash', initial: true),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: RegisterRoute.page, path: '/register'),

    // Main App Routes
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
      children: [
        AutoRoute(page: WorkoutListRoute.page, path: 'workouts'),
        AutoRoute(page: MealPlanRoute.page, path: 'meals'),
        AutoRoute(page: ProgressRoute.page, path: 'progress'),
        AutoRoute(page: ProfileRoute.page, path: 'profile'),
      ],
    ),

    // Detail Routes
    AutoRoute(page: WorkoutDetailRoute.page, path: '/workout/:id'),
    AutoRoute(page: MealDetailRoute.page, path: '/meal/:id'),
    AutoRoute(page: AiChatRoute.page, path: '/ai-chat'),
  ];
}
