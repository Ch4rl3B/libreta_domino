import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';

class WebSecureStorage extends FlutterSecureStorage {
  const WebSecureStorage();

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    await setValue(key, value);
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    await removeKey(key);
  }

  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    return getMatchingSharedPrefKeys(key).isNotEmpty;
  }

  @override
  Future<String> read({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    return getStringAsync(key);
  }
}
