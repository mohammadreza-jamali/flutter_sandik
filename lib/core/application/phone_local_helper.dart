import 'package:device_region/device_region.dart';

class PhoneLocalHelper {
  static String phoneLocal = "en";
  static Future getCountryPhoneCode() async {
    var isoCode = await DeviceRegion.getSIMCountryCode();
    print("country code $isoCode");
    phoneLocal = isoCode ?? "ir".toLowerCase();
    //return "+" + countryList.firstWhere((element) => element.isoCode == isoCode, orElse: () => countryList.first).phoneCode;
  }
}
