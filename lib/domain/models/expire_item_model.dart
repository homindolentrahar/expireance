import 'package:expireance/domain/models/expire_category_model.dart';

class ExpireItemModel {
  String id;
  String name;
  String desc;
  int amount;
  DateTime date;
  String image;
  ExpireCategoryModel category;

  ExpireItemModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.amount,
    required this.date,
    required this.image,
    required this.category,
  });
}
