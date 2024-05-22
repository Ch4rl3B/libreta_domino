import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libreta_domino/features/settings/data/repository/settings_repository.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

export 'mocks.mocks.dart';

@GenerateMocks(
  [
    SettingsRepository,

    // external mocks
    FlutterSecureStorage,
    Logger,
    Box,
    Directory,
    PathProviderPlatform,
  ],
)
void main() {}
