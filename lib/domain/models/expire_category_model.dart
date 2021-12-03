class ExpireCategoryModel {
  String id;
  String slug;
  String name;

  ExpireCategoryModel({
    required this.id,
    required this.slug,
    required this.name,
  });

  factory ExpireCategoryModel.empty() =>
      ExpireCategoryModel(id: "", slug: "", name: "");
}
