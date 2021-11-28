import 'package:hive_flutter/hive_flutter.dart';

@HiveType()
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
  String categoryId;

  ExpireItemEntity(
    this.id,
    this.name,
    this.desc,
    this.amount,
    this.date,
    this.image,
    this.categoryId,
  );

  factory ExpireItemEntity.empty() =>
      ExpireItemEntity("", "", "", 0, "", "", "");
}
