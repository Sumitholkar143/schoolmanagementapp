import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesfile {
  static Future<bool> getIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? islogin = prefs.getBool('isLogin');
    return islogin == null || !islogin ? false : true;
    ;
  }

  static Future<void> deleteAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isTeach');
    await prefs.remove('name');
    await prefs.remove('isLogin');
    await prefs.remove('username');
  }

  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    return name != null ? name : 'Sample';
  }

  static Future<bool> isTeacher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? name = prefs.getBool('isTeach');
    print(name);
    return name != null ? name : false;
  }

  static Future<String> getClass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('class');
    return name != null ? name : 'Sample';
  }

  static Future<String> getEnroll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('enroll');
    return name != null ? name : 'Sample';
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('email');
    return name != null ? name : 'S';
  }

  static Future<String> getNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('number');
    return name != null ? name : 'Sample';
  }
}
