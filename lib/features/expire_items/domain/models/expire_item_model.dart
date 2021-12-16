
import 'package:expireance/features/expire_items/domain/models/category_model.dart';

class ExpireItemModel {
  String id;
  String name;
  String desc;
  int amount;
  DateTime date;
  String image;
  CategoryModel category;

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
