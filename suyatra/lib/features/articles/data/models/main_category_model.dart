import 'dart:convert';

import 'package:suyatra/core/typedef.dart';
import 'package:suyatra/features/articles/domain/entities/main_category_entity.dart';

class MainCategoryModel extends MainCategoryEntity {
  const MainCategoryModel({
    required super.id,
    required super.title,
    required super.value,
  });

  factory MainCategoryModel.fromJson(String source) {
    return MainCategoryModel.fromMap(jsonDecode(source));
  }

  MainCategoryModel.fromMap(DataMap map)
      : this(
          id: map["id"],
          title: map["title"],
          value: map["value"],
        );

  MainCategoryModel copyWith({
    int? id,
    String? title,
    String? value,
  }) {
    return MainCategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
    );
  }

  DataMap toMap() => {
    "id": id,
    "title": title,
    "value": value,
  };

  String toJson() => jsonEncode(toMap());
}
