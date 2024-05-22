import 'package:hive/hive.dart';
import 'package:libreta_domino/core/constants/constants.dart';

part 'settings.g.dart';

@HiveType(typeId: Constants.settingsTypeId, adapterName: 'SettingsDataAdapter')
class Settings extends HiveObject {
  @HiveField(0, defaultValue: 'es')
  String locale;

  @HiveField(1, defaultValue: 1) // Brightness.light
  int brightness;

  @HiveField(2, defaultValue: 14.0)
  double textScale;

  Settings._(this.locale, this.brightness, this.textScale);

  factory Settings() => Settings._('es', 1, 14.0);

  Settings copyWith({
    String? locale,
    int? brightness,
    double? textScale,
  }) =>
      Settings._(
        locale ?? this.locale,
        brightness ?? this.brightness,
        textScale ?? this.textScale,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          runtimeType == other.runtimeType &&
          locale == other.locale &&
          brightness == other.brightness &&
          textScale == other.textScale;

  @override
  int get hashCode =>
      locale.hashCode ^ brightness.hashCode ^ textScale.hashCode;
}
