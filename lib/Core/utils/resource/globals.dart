import 'package:flutter_news_app/Presentation/Widgets/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

//launch URL
void goToUrl(String url) async {
  bool validate = Uri.tryParse(url)?.hasAbsolutePath ?? false;
  if (url == "") {
    toastMsg('Can\'t open empty link');
    return;
  }
  if (!validate) {
    toastMsg('URL is not valid');
    return;
  }
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $uri';
  }
}

//SharedPreference
setPreference(String key, dynamic value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (value.runtimeType) {
    case String:
      await prefs.setString(key, value);
      break;
    case int:
      await prefs.setInt(key, value);
      break;
    case double:
      await prefs.setDouble(key, value);
      break;
    case bool:
      await prefs.setBool(key, value);
      break;
    case List<String>:
      await prefs.setStringList(key, value);
      break;
    default:
      await prefs.setString(key, value);
      break;
  }
}

getPreference(String key, {String type = 'string'}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic value;
  if (type == 'string') value = prefs.getString(key);
  if (type == 'list') value = prefs.getStringList(key);
  if (type == 'bool') value = prefs.getBool(key);
  return value;
}

deletePreference(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

cleanPreference(String useCase) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
}
