import 'package:currensee_pkr/core/theme/app_theme.dart';
import 'package:currensee_pkr/features/auth/screens/auth_wrapper.dart';
import 'package:currensee_pkr/features/converter/providers/converter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CurrenSeeApp());
}

class CurrenSeeApp extends StatelessWidget {
  const CurrenSeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConverterProvider()),
      ],
      child: MaterialApp(
        title: 'CurrenSee',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}
