import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

/// Education fields follow the Django EducationSerializer response.
@JsonSerializable(fieldRename: FieldRename.snake)
class Education {
  const Education({
    required this.institution,
    required this.degree,
    required this.fieldOfStudy,
    required this.startYear,
    required this.description,
    this.endYear,
    this.thumbnail = '',
    this.id,
    this.degreeDisplay = '',
    this.isCurrent = false,
    this.starCount = 0,
    this.isStarred = false,
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;
  final String institution;
  final String degree;
  final String fieldOfStudy;
  final int startYear;
  final int? endYear;
  @JsonKey(defaultValue: '')
  final String thumbnail;
  final String description;
  @JsonKey(includeToJson: false, defaultValue: '')
  final String degreeDisplay;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isCurrent;
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  static const degrees = {
    'elementary': 'Elementary School',
    'junior_high': 'Junior High School',
    'high_school': 'High School',
    'bachelor': 'Bachelor Degree',
    'master': 'Master Degree',
    'doctoral': 'Doctoral Degree',
  };

  String get degreeLabel =>
      degreeDisplay.isNotEmpty ? degreeDisplay : degrees[degree] ?? degree;

  Map<String, dynamic> toJson() => _$EducationToJson(this);
}
