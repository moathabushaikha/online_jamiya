import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/screens/enroll_permission.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class AppRouter {
  final AppStateManager appStateManager;
  final ProfileManager profileManager;
  final JamiyaManager jamiyaManager;

  AppRouter(this.appStateManager, this.profileManager, this.jamiyaManager);

  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: appStateManager,
    initialLocation: '/login',
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
        routes: [
          GoRoute(
            name: 'register',
            path: 'register',
            builder: (context, state) {
              return const RegisterUser();
            },
          ),
        ],
      ),
      GoRoute(
        name: 'home',
        path: '/:tab',
        builder: (context, state) {
          final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
          return Home(key: state.pageKey, currentTab: tab);
        },
        routes: [
          GoRoute(
              name: 'profile',
              path: 'profile',
              builder: (context, state) {
                final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
                return ProfileScreen(currentTab: tab);
              }),
          GoRoute(
            name: 'enroll_permission',
            path: 'enroll_permission',
            builder: (context, state) {
              final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
              return EnrollPermission(currentTab: tab);
            },
          ),
          GoRoute(
            name: 'newJamiya',
            path: 'newJamiya',
            builder: (context, state) {
              return JamiyaForm(
                onCreate: (item) {
                  jamiyaManager.addJamiyaItem(item);
                },
              );
            },
          ),
          GoRoute(
              name: 'jamiya',
              path: ':selectedJamiyaId',
              builder: (context, state) {
                final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
                final selectedJamiyaId =
                    int.tryParse(state.params['selectedJamiyaId'] ?? '') ?? 0;
                return JamiyaView(
                  currentTab: tab,
                  selectedJamiyaIndex: selectedJamiyaId,
                  manager: jamiyaManager,
                );
              }),
        ],
      ),
    ],
    // [GoRouter] : setting initial location to LoginScreen
    redirect: (context, state) {
      final loggedIn = appStateManager.isLoggedIn;
      final loggingIn =
          (state.location == '/login' || state.location == '/login/register');
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/${JamiyaTabs.mainScreen}';
      return null;
    },
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
  );
}
