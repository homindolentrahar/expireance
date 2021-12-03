import 'package:expireance/data/local/expire_category_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expireance/domain/models/expire_item_model.dart';

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
  ExpireCategoryEntity category;

  ExpireItemEntity(
    this.id,
    this.name,
    this.desc,
    this.amount,
    this.date,
    this.image,
    this.category,
  );

  factory ExpireItemEntity.empty() => ExpireItemEntity(
        "",
        "",
        "",
        0,
        "",
        "",
        ExpireCategoryEntity.empty(),
      );

  factory ExpireItemEntity.fromModel(ExpireItemModel model) {
    return ExpireItemEntity(
      model.id,
      model.name,
      model.desc,
      model.amount,
      model.date.toIso8601String(),
      model.image,
      ExpireCategoryEntity.fromModel(model.category),
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
