import 'dart:convert';

import 'package:http/http.dart' as http;

class PhoneLocalHelper {
  static String phoneLocal = "en";
  static Future getCountryPhoneCode() async {
    var response = await http.get(Uri.parse('http://ip-api.com/json'));
    var jsonResponse = json.decode(response.body);
    final isoCode = jsonResponse['countryCode'];
    print("country code " + isoCode);
    phoneLocal = isoCode.toString().toLowerCase();
    //return "+" + countryList.firstWhere((element) => element.isoCode == isoCode, orElse: () => countryList.first).phoneCode;
  }
}
