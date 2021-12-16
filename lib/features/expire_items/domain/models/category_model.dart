class CategoryModel {
  String id;
  String slug;
  String name;

  CategoryModel({
    required this.id,
    required this.slug,
    required this.name,
  });

  factory CategoryModel.empty() =>
      CategoryModel(id: "", slug: "", name: "");
}
