import 'package:flutter/material.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/theme.dart';
import 'package:provider/provider.dart';
import 'navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appStateManager = AppStateManager();
  await appStateManager.initializeApp();
  runApp(Jamiya(appStateManager: appStateManager));
}

class Jamiya extends StatefulWidget {
final appStateManager = AppStateManager();

Jamiya({Key? key, required appStateManager}) : super(key: key);

@override
State<Jamiya> createState() => _JamiyaState();
}

class _JamiyaState extends State<Jamiya> {
  late final _profileManager = ProfileManager();
  late final _jamiyaManager = JamiyaManager();
  late final _appRouter = AppRouter(widget.appStateManager, _profileManager,_jamiyaManager);

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



