import 'package:flutter/material.dart';
import 'package:mevduat_ceza/screens/MevzuatList.dart';
import 'package:provider/provider.dart';
import 'shared/themes.dart' as themes;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  AppModel appModel = new AppModel();
  @override
  void initState() {
    super.initState();
    _initAppTheme();
  }
  void _initAppTheme() async {
    appModel.darkTheme = await appModel.appPreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AppModel>.value(
      value: appModel,
      child: Consumer<AppModel>(
          builder: (context, value, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: appModel.darkTheme ? themes.buildDarkTheme() : themes.buildLightTheme(),
              home: MevzuatList(),
            );
          }
      ),
    );
  }
}

class AppPreference {
  static const THEME_SETTING = "THEMESETTING";
  setThemePref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_SETTING, value);
  }
  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_SETTING) ?? false;
  }
}

class AppModel extends ChangeNotifier {
  AppPreference appPreference = AppPreference();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;
  set darkTheme(bool value) {
    _darkTheme = value;
    appPreference.setThemePref(value);
    notifyListeners();
  }
}