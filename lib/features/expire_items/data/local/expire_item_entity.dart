import 'package:expireance/features/expire_items/data/local/category_entity.dart';
import 'package:expireance/features/expire_items/domain/models/expire_item_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'expire_item_entity.g.dart';

@HiveType(typeId: 101)
class ExpireItemEntity extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String desc;
  @HiveField(3)
  int amount;
  @HiveField(4)
  String date;
  @HiveField(5)
  String image;
  @HiveField(6)
  CategoryEntity category;

  ExpireItemEntity(
    this.id,
    this.name,
    this.desc,
    this.amount,
    this.date,
    this.image,
    this.category,
  );

  ExpireItemEntity copyWith({
    String? name,
    String? desc,
    int? amount,
    String? date,
    String? image,
    CategoryEntity? category,
  }) =>
      ExpireItemEntity(
        id,
        name ?? this.name,
        desc ?? this.desc,
        amount ?? this.amount,
        date ?? this.date,
        image ?? this.image,
        category ?? this.category,
      );

  factory ExpireItemEntity.empty() => ExpireItemEntity(
        "",
        "",
        "",
        0,
        "",
        "",
        CategoryEntity.empty(),
      );

  factory ExpireItemEntity.fromModel(ExpireItemModel model) {
    return ExpireItemEntity(
      model.id,
      model.name,
      model.desc,
      model.amount,
      model.date.toIso8601String(),
      model.image,
      CategoryEntity.fromModel(model.category),
    );
  }

  ExpireItemModel toModel() => ExpireItemModel(
        id: id,
        name: name,
        desc: desc,
        amount: amount,
        date: DateTime.parse(date),
        image: image,
        category: category.toModel(),
      );
}
