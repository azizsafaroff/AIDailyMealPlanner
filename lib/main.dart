import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'logic/app_service.dart';
import 'theme/app_theme.dart';
import 'ui/screens/root_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final appService = await AppService.bootstrap();
  runApp(MyApp(appService: appService));
}

class MyApp extends StatelessWidget {
  final AppService appService;

  const MyApp({super.key, required this.appService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appService,
      child: MaterialApp(
        title: 'AI Daily Meal Planner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        builder: (context, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: child,
          );
        },
        home: const RootScreen(),
      ),
    );
  }
}
