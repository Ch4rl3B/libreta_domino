import 'package:faker/faker.dart';
import 'package:hive/hive.dart';
import 'package:libreta_domino/core/constants/constants.dart';

part 'settings.g.dart';

@HiveType(typeId: Constants.settingsTypeId, adapterName: 'SettingsDataAdapter')
class Settings extends HiveObject {
  @HiveField(0, defaultValue: 'es')
  String locale;

  @HiveField(1, defaultValue: 1) // Brightness.light
  int brightness;

  @HiveField(2, defaultValue: 1.0)
  double textScale;

  @HiveField(3, defaultValue: 1)
  int settingsHash;
  Settings._(this.locale, this.brightness, this.textScale, this.settingsHash);

  factory Settings() => Settings._(
        'en',
        1,
        1.0,
        'new'.hashCode,
      );

  Settings copyWith({
    String? locale,
    int? brightness,
    double? textScale,
  }) =>
      Settings._(
        locale ?? this.locale,
        brightness ?? this.brightness,
        textScale ?? this.textScale,
        Faker().guid.guid().hashCode,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          runtimeType == other.runtimeType &&
          settingsHash == other.settingsHash;

  @override
  int get hashCode => settingsHash;

  @override
  String toString() {
    return 'Settings{locale: $locale, brightness: $brightness, textScale: $textScale}';
  }
}
