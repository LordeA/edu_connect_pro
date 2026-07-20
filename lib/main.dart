import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';

import 'package:edu_connect_pro/firebase_options.dart';

import 'package:edu_connect_pro/app_router.dart';

import 'package:edu_connect_pro/providers/auth_provider.dart';

import 'package:edu_connect_pro/providers/course_provider.dart';



// 1. Nou kreye yon tiThemeProvider senp isit la pou jere Mode Sombre la

class ThemeProvider with ChangeNotifier {

  ThemeMode _themeMode = ThemeMode.light;



  ThemeMode get themeMode => _themeMode;



  bool get isDarkMode => _themeMode == ThemeMode.dark;



  void toggleTheme(bool isOn) {

    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    notifyListeners(); // Sa ap fè tout aplikasyon an chanje koulè yon sèl kou

  }

}



void main() async {

  // Toujou asire w Flutter mare ak sistèm nan anlè a piske n ap inisyalize Firebase

  WidgetsFlutterBinding.ensureInitialized();

 

  // Inisyalize Firebase parfe anvan aplikasyon an demare

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );



  runApp(const MyApp());

}



class MyApp extends StatelessWidget {

  const MyApp({super.key});



  @override

  Widget build(BuildContext context) {

    // Nou ajoute ThemeProvider la nan MultiProvider rasin lan

    return MultiProvider(

      providers: [

        ChangeNotifierProvider(create: (_) => AuthProvider()),   // Pou koneksyon an

        ChangeNotifierProvider(create: (_) => CourseProvider()), // Pati pa w la (S2)!

        ChangeNotifierProvider(create: (_) => ThemeProvider()),  // Jere Mode Sombre la!

        // Kòlèg yo (Membres B et C) ap ka ajoute ProgressProvider la a aprè:

        // ChangeNotifierProvider(create: (_) => ProgressProvider()),

      ],

      child: const _AppRoot(),

    );

  }

}



// Widget séparé pour pouvoir accéder à AuthProvider via context

// et construire le routeur APRÈS que MultiProvider soit monté

class _AppRoot extends StatelessWidget {

  const _AppRoot();



  @override

  Widget build(BuildContext context) {

    // Si w bezwen gade si moun nan konekte ak authProvider la, ou ka kite liy sa a

    // final authProvider = context.watch<AuthProvider>();



    // Nou koute chanjman tèm nan la a an tan reyèl ak context.watch

    final themeProvider = context.watch<ThemeProvider>();



    return MaterialApp(

      title: 'EduConnect Pro',

      debugShowCheckedModeBanner: false,

     

      // Jere tèm yo otomatikman selon chwa elèv la

      themeMode: themeProvider.themeMode,

     

      // Tèm Klè (Light Theme)

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(

          seedColor: const Color(0xFF0D47A1),

          brightness: Brightness.light,

        ),

        scaffoldBackgroundColor: const Color(0xFFF8F9FA),

        useMaterial3: true,

      ),

     

      // Tèm Nwa (Dark Theme)

      darkTheme: ThemeData(

        colorScheme: ColorScheme.fromSeed(

          seedColor: const Color(0xFF0D47A1),

          brightness: Brightness.dark,

        ),

        scaffoldBackgroundColor: const Color(0xFF121212),

        useMaterial3: true,

      ),



      // Nou itilize wout premye paj la (Splash Screen) kòm premye wout

      initialRoute: AppRouter.splash,

      // Nou pase sistèm generateRoute nou te kreye a la

      onGenerateRoute: AppRouter.generateRoute,

    );

  }

} 

