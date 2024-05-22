import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void setupMethodChannels() {
  const secureStorageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel,
          (MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'read':
        return null; // Simulate no encryption key found initially
      case 'write':
        return null; // Simulate successful write
      default:
        return null;
    }
  });

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(pathProviderChannel,
          (MethodCall methodCall) async {
    if (methodCall.method == 'getTemporaryDirectory') {
      return '/mock/temp/dir';
    }
    return null;
  });
}
