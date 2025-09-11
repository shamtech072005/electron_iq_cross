import 'package:connectivity_plus/connectivity_plus.dart';

/// A service class to handle network-related checks.
class NetworkService {
  final Connectivity _connectivity = Connectivity();

  /// Checks if the device is connected to a network (Wi-Fi, Mobile, or Ethernet).
  ///
  /// Returns `true` if a connection is available, otherwise `false`.
  Future<bool> isNetworkConnected() async {
    final List<ConnectivityResult> connectivityResult =
        await _connectivity.checkConnectivity();
        
    // The new version of connectivity_plus returns a list of results.
    // We check if the list contains any of the connected types.
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    }
    return false;
  }
}
