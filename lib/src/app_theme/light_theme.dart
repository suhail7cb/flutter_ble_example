import 'package:flutter/material.dart';

ThemeData appLightTheme() {

  ButtonThemeData buttonTextThemeForLightMode(ButtonThemeData base) {
    return base.copyWith(
      buttonColor: Color(0xFF05537A),
      disabledColor: Color(0xFF85D3FA),
      textTheme: ButtonTextTheme.primary,
    );
  }

  ElevatedButtonThemeData elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Color(0xFF05537A);
              else if (states.contains(MaterialState.disabled))
                return  Color(0xFF85D3FA);
              return Color(0xFF05537A); // Use the component's default.
            }),

        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled))
                return TextStyle(fontWeight: FontWeight.w700,fontSize: 18, color: Colors.white60);
              else
                return TextStyle(fontWeight: FontWeight.w700,fontSize: 18, color: Colors.white);
            }),
        elevation: MaterialStateProperty.resolveWith<double>(
              (Set<MaterialState> states) {
            return 15.0;
          },),
        shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                (Set<MaterialState> states) {
              return RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)));
            }),
        minimumSize: MaterialStateProperty.resolveWith<Size>(
                (Set<MaterialState> states) {
              return  Size(200, 50);
            }),
      ),
    );
  }


  final  ThemeData lightTheme = ThemeData.light();
  return lightTheme.copyWith(
    primaryColor: Color(0xFF05537A),
    buttonTheme: buttonTextThemeForLightMode(lightTheme.buttonTheme),
    elevatedButtonTheme: elevatedButtonThemeData(),
    ///Provide value to other properties if needed
  );
}

class HxColors {
  HxColors._();

  static const _hxPrimaryValue = 0xFF088CCC;

  static const MaterialColor hxBlue = const MaterialColor(
    _hxPrimaryValue,
    const <int, Color>{
      50:  const Color(0xFFE7f6FE),
      100: const Color(0xFFB6E4FC),
      200: const Color(0xFF85D3FA),
      300: const Color(0xFF54C1F8),
      400: const Color(0xFF23AFF6),
      500: const Color(_hxPrimaryValue),
      600: const Color(0xFF23AFF6),
      700: const Color(0xFF0775AB),
      800: const Color(0xFF05537A),
      900: const Color(0xFF033249),
    },
  );
}