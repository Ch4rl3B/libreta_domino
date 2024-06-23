import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:libreta_domino/translations/data/model/translation.dart';

part 'app_localization.freezed.dart';
part 'app_localization.g.dart';

@freezed
class AppLocalization with _$AppLocalization {
  const factory AppLocalization({
    @JsonKey(name: 'appId') @Default("libretadomino") String appId,
    @JsonKey(name: 'version') @Default(1) int version,
    @JsonKey(
      name: 'data',
      includeToJson: false,
      includeFromJson: false,
    )
    @Default([])
    List<Translation> data,
  }) = _AppLocalization;

  factory AppLocalization.fromJson(Map<String, Object?> json) =>
      _$AppLocalizationFromJson(json);
}
