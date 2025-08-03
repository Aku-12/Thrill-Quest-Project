import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:thrill_quest/core/utils/internet_checker.dart';

class InternetCheckerImpl implements InternetChecker {
  @override
  Future<bool> isConnected() async {
    try {
      return await InternetConnection().hasInternetAccess;
    } catch (e) {
      return false; // Assume no internet on error
    }
  }
}
