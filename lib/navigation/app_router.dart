import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online_jamiya/components/components.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:provider/provider.dart';
import '../components/payment_page.dart';
import '../screens/screens.dart';
import 'package:online_jamiya/models/models.dart';

class AppRouter {
  final AppStateManager appStateManager;
  final ProfileManager profileManager;
  final JamiyaManager jamiyaManager;
  final NotificationManager notificationManager;

  AppRouter(
      this.appStateManager, this.profileManager, this.jamiyaManager, this.notificationManager);

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
          return Consumer2<NotificationManager, JamiyaManager>(
            builder: (context, manager1, manager2, child) =>
                Home(key: state.pageKey, currentTab: tab),
          );
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
            name: 'userNotification',
            path: 'userNotification',
            builder: (context, state) {
              final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
              return UserNotificationBody(currentTab: tab);
            },
          ),
          GoRoute(
              name: 'editMyJamiya',
              path: 'editMyJamiya',
              builder: (context, state) {
                final selectedJamiya = state.extra as Jamiya;
                final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
                return EditMyJamiya(jamiya: selectedJamiya, tab: tab);
              }),
          GoRoute(
              name: 'paymentPage',
              path: 'paymentPage',
              builder: (context, state) {
                Map<String, Object?> myExtras =
                state.extra as Map<String, Object?>;
                final selectedJamiya = myExtras['jamiya'] as Jamiya;
                final currentUser = myExtras['user'] as User;
                final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
                return PaymentPage(jamiya: selectedJamiya,currentUser: currentUser, tab: tab);
              }),
          GoRoute(
            name: 'newJamiya',
            path: 'newJamiya',
            builder: (context, state) {
              return const JamiyaForm();
            },
          ),
          GoRoute(
              name: 'jamiya',
              path: ':selectedJamiyaId',
              builder: (context, state) {
                final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
                final selectedJamiyaId = int.tryParse(state.params['selectedJamiyaId'] ?? '') ?? 0;
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
      final loggingIn = (state.location == '/login' || state.location == '/login/register');
      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/${JamiyaTabs.mainScreen}';
      return null;
    },
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color.fromRGBO(200, 120, 100, 1), Colors.white]
              )
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Text(
                state.error.toString(),
              ),
            ),
          ),
        ),
      );
    },
  );

  void buildDialog(BuildContext context, String msg) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Authentication Error'),
          content: SingleChildScrollView(
            child: Text(msg),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
