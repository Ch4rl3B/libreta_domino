import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation.freezed.dart';
part 'translation.g.dart';

@freezed
class Translation with _$Translation {
  const factory Translation({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'locale') required String locale,
    @JsonKey(name: 'key') required String key,
    @JsonKey(name: 'value') required String value,
    @JsonKey(name: 'pluralize') @Default(false) bool pluralize,
    @JsonKey(name: 'parametrized') @Default(false) bool parametrized,
    @JsonKey(name: 'parameterKeys') @Default("") String parameterKeys,
  }) = _Translation;

  factory Translation.fromJson(Map<String, Object?> json) =>
      _$TranslationFromJson(json);
}
