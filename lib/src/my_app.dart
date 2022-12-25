import 'package:ble_project/src/app_flow/main_app_flow/devices_list/ble_devices_list_bloc.dart';
import 'package:ble_project/src/app_flow/main_app_flow/devices_list/ble_devices_list_screen.dart';
import 'package:ble_project/src/localisation_manager/language_manager.dart';
import 'package:flutter/material.dart';

import 'app_theme/dark_theme.dart';
import 'app_theme/light_theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      title: 'BLE Example',
      debugShowCheckedModeBanner: false,
      darkTheme: appDarkTheme(),
      theme: appLightTheme(),
      themeMode: ThemeMode.system,
      home: FutureBuilder<Map<String, dynamic>>(
        future: LanguageManager().loadLanguage(languageCode: 'en'),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> futureData) {
          if(futureData.hasData) {
            return BLEDevicesListScreen(bloc: BLEDevicesListBloc());
          }
          else
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),),
            );
        },
      ),
    );
  }
}