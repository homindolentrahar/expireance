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

  @override
  String toString() {
    return """
    {
        "id: $id"
        "name: $name"
        "desc: $desc"
        "amount: $amount"
        "expireDate: ${date.toIso8601String()}"
        "image: $image"
        "category: ${category.slug}"
    }
    """;
  }
}
