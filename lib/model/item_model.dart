class ItemResponse {
  int? totalCount;
  bool? incompleteResults;
  List<Items>? items;

  ItemResponse({this.totalCount, this.incompleteResults, this.items});

  ItemResponse.fromJson(Map<String, dynamic> json) {
    totalCount = json['total_count'];
    incompleteResults = json['incomplete_results'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_count'] = totalCount;
    data['incomplete_results'] = incompleteResults;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  String? fullName;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? pushedAt;

  Items({
    this.id,
    this.name,
    this.fullName,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fullName = json['full_name'];
    createdAt = DateTime.tryParse(json['created_at']);
    updatedAt = DateTime.tryParse(json['updated_at']);
    pushedAt = DateTime.tryParse(json['pushed_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['full_name'] = fullName;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    data['pushed_at'] = pushedAt?.toIso8601String();

    return data;
  }
}
