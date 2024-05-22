import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 2, adapterName: 'SettingsDataAdapter')
class Settings extends HiveObject {
  @HiveField(0, defaultValue: 'es')
  late String locale;

  @HiveField(1, defaultValue: 1) // Brightness.light
  late int brightness;

  @HiveField(2, defaultValue: 14.0)
  late double textScale;

  Settings();

  Settings copyWith({
    String? locale,
    int? brightness,
    double? textScale,
  }) =>
      Settings()
        ..textScale = textScale ?? this.textScale
        ..brightness = brightness ?? this.brightness
        ..locale = locale ?? this.locale;
}
