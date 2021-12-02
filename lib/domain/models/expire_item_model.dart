class ExpireItemModel {
  String id;
  String name;
  String desc;
  int amount;
  DateTime date;
  String image;
  String categoryId;

  ExpireItemModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.amount,
    required this.date,
    required this.image,
    required this.categoryId,
  });
}
