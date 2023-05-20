import 'package:flutter/material.dart';
import 'package:online_jamiya/api/local_db.dart';
import 'package:online_jamiya/managers/managers.dart';
import 'package:online_jamiya/theme.dart';
import 'package:provider/provider.dart';
import 'navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appStateManager = AppStateManager();
  await appStateManager.initializeApp();
  await DataBaseConn.instance.getToken();
  runApp(JamiyaOnline(appStateManager: appStateManager));
}

class JamiyaOnline extends StatefulWidget {
  final appStateManager = AppStateManager();

  JamiyaOnline({Key? key, required appStateManager}) : super(key: key);

  @override
  State<JamiyaOnline> createState() => _JamiyaOnlineState();
}

class _JamiyaOnlineState extends State<JamiyaOnline> {
  final _profileManager = ProfileManager();
  final _jamiyaManager = JamiyaManager();
  final notificationManager = NotificationManager();
  final _appcache = AppCache();
  late final _appRouter = AppRouter(widget.appStateManager, _profileManager,
      _jamiyaManager, notificationManager);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _jamiyaManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        ),
        ChangeNotifierProvider(
          create: (context) => widget.appStateManager,
        ),
        ChangeNotifierProvider(
          create: (context) => notificationManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _appcache,
        ),
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = JamiyaTheme.dark();
          } else {
            theme = JamiyaTheme.light();
          }

          final router = _appRouter.router;

          return MaterialApp.router(
            theme: theme,
            title: 'Jamiya Online',
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
          );
        },
      ),
    );
  }
}
