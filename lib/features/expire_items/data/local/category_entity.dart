import 'package:expireance/features/expire_items/domain/models/category_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'category_entity.g.dart';

@HiveType(typeId: 201)
class CategoryEntity extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String slug;
  @HiveField(2)
  String name;

  CategoryEntity(
    this.id,
    this.slug,
    this.name,
  );

  factory CategoryEntity.empty() => CategoryEntity("", "", "");

  factory CategoryEntity.fromModel(CategoryModel model) =>
      CategoryEntity(
        model.id,
        model.slug,
        model.name,
      );

  CategoryModel toModel() => CategoryModel(
        id: id,
        slug: slug,
        name: name,
      );
}
