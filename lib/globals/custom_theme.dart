
import 'package:flutter/material.dart';

ButtonStyle redButtons = ElevatedButton.styleFrom(
  backgroundColor: Colors.red,
  foregroundColor: Colors.black
);


ElevatedButtonThemeData redButtonTheme = ElevatedButtonThemeData(
  style: redButtons
);

ThemeData customRedButtonTheme = ThemeData(
  elevatedButtonTheme: redButtonTheme,
);


ButtonStyle amberButtons = ElevatedButton.styleFrom(
  backgroundColor: Colors.amber,
  foregroundColor: Colors.black
);


ElevatedButtonThemeData amberButtonTheme = ElevatedButtonThemeData(
  style: amberButtons
);

ThemeData customAmberButtonTheme = ThemeData(
  elevatedButtonTheme: amberButtonTheme,
);
