import 'package:geocoder/geocoder.dart';

class AddressTool {
  static Future<Address> getAddressFromString(String str) async {
    bool error = false;
    List<Address> addresses =
    await Geocoder.local.findAddressesFromQuery(str).catchError((_) {
      error = true;
    });
    return (error == false ? addresses.first : null);
  }

}