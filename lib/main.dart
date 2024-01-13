import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/bloc/authentication/authentication_bloc.dart';
import 'package:myshoppinglist/bloc/category/category_bloc.dart';
import 'package:myshoppinglist/bloc/myitem/myitem_bloc.dart';
import 'package:myshoppinglist/bloc/profile/profile_bloc.dart';
import 'package:myshoppinglist/globals/theme_globals.dart';
import 'package:myshoppinglist/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myshoppinglist/repository/category_repository.dart';
import 'package:myshoppinglist/repository/item_repository.dart';
import 'package:myshoppinglist/repository/user_repository.dart';
import 'package:myshoppinglist/theme/dark_theme.dart';
import 'package:myshoppinglist/theme/light_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  UserRepository userRepository = UserRepository();
  CategoryRepository categoryRepository = CategoryRepository();
  ItemRepository itemRepository = ItemRepository();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc(userRepository)..add(AppStarted())),
        BlocProvider(create: (context) => CategoryBloc(categoryRepository)),
        BlocProvider(create: (context) => MyitemBloc(itemRepository)),
        BlocProvider(create: (context) => ProfileBloc(userRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {

    themeManager.addListener(themeListener);

    super.initState();
  }
  
  themeListener () {
    if(mounted) {
      setState(() {
        
      });
    }
  }

  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Shopping List App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeManager.themeMode,
      home: Homepage()
    );
  }
}
