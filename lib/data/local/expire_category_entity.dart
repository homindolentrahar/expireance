import 'package:hive_flutter/hive_flutter.dart';
import 'package:expireance/domain/models/expire_category_model.dart';

part 'expire_category_entity.g.dart';

@HiveType(typeId: 201)
class ExpireCategoryEntity extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String slug;
  @HiveField(2)
  String name;

  ExpireCategoryEntity(
    this.id,
    this.slug,
    this.name,
  );

  factory ExpireCategoryEntity.empty() => ExpireCategoryEntity("", "", "");

  factory ExpireCategoryEntity.fromModel(ExpireCategoryModel model) =>
      ExpireCategoryEntity(
        model.id,
        model.slug,
        model.name,
      );

  ExpireCategoryModel toModel() => ExpireCategoryModel(
        id: id,
        slug: slug,
        name: name,
      );
}
